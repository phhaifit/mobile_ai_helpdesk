import 'package:ai_helpdesk/constants/env.dart';
import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/data/auth/oauth_browser_client.dart';
import 'package:ai_helpdesk/data/auth/oauth_pkce.dart';
import 'package:ai_helpdesk/data/local/auth/auth_local_datasource.dart';
import 'package:ai_helpdesk/data/network/apis/auth/stack_auth_api.dart';
import 'package:ai_helpdesk/data/network/stack_error_mapper.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_failure.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_session.dart';
import 'package:ai_helpdesk/domain/entity/auth/otp_send_result.dart';
import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final StackAuthApi _api;
  final AuthLocalDatasource _local;
  final EnvConfig _env;
  final OAuthBrowserClient _browser;
  final OAuthPkceGenerator _pkce;

  AuthRepositoryImpl(
    this._api,
    this._local,
    this._env, {
    required OAuthBrowserClient browser,
    OAuthPkceGenerator? pkce,
  })  : _browser = browser,
        _pkce = pkce ?? OAuthPkceGenerator();

  @override
  Future<Either<Failure, OtpSendResult>> sendOtp({
    required String email,
  }) async {
    try {
      final json = await _api.sendSignInCode(
        email: email,
        callbackUrl: _env.otpCallbackUrl,
      );
      return Right(OtpSendResult.fromJson(json));
    } on DioException catch (e) {
      return Left(StackErrorMapper.map(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> signInWithOtp({
    required String code,
    required String nonce,
  }) async {
    try {
      final concatenated = '$code$nonce';
      final json = await _api.signInWithCode(concatenatedCode: concatenated);
      final session = AuthSession.fromJson(json);
      await _local.saveSession(session);
      return Right(session);
    } on DioException catch (e) {
      return Left(StackErrorMapper.map(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> signInWithGoogle() async {
    final pair = _pkce.generatePair();
    final state = _pkce.generateState();

    final authorizeUrl = _api.buildGoogleAuthorizeUrl(
      clientId: _env.stackProjectId,
      publishableClientKey: _env.stackPublishableClientKey,
      redirectUri: _env.oauthRedirectUri,
      state: state,
      codeChallenge: pair.challenge,
      errorRedirectUri: _env.oauthErrorRedirectUri,
    );

    final String callbackUrl;
    try {
      callbackUrl = await _browser.authenticate(
        url: authorizeUrl,
        callbackUrlScheme: _env.oauthCallbackUrlScheme,
      );
    } on OAuthCancelledException {
      return const Left(OAuthCancelledFailure());
    } catch (e) {
      return Left(OAuthFailedFailure(e.toString()));
    }

    final callbackUri = Uri.tryParse(callbackUrl);
    if (callbackUri == null) {
      return const Left(OAuthFailedFailure());
    }
    final params = callbackUri.queryParameters;
    // Stack Auth surfaces provider-side errors via `?error=...` on the
    // configured error_redirect_url — propagate as a recoverable failure.
    final errorParam = params['error'];
    if (errorParam != null && errorParam.isNotEmpty) {
      return Left(OAuthFailedFailure(errorParam));
    }
    final receivedCode = params['code'];
    final receivedState = params['state'];
    if (receivedCode == null || receivedCode.isEmpty) {
      return const Left(OAuthFailedFailure());
    }
    if (receivedState != state) {
      // CSRF guard — never trust a callback whose state we did not mint.
      return const Left(OAuthFailedFailure('State mismatch.'));
    }

    try {
      final json = await _api.exchangeOAuthCode(
        code: receivedCode,
        redirectUri: _env.oauthRedirectUri,
        clientId: _env.stackProjectId,
        publishableClientKey: _env.stackPublishableClientKey,
        codeVerifier: pair.verifier,
      );
      final accessToken = json['access_token'];
      final refreshToken = json['refresh_token'];
      if (accessToken is! String ||
          accessToken.isEmpty ||
          refreshToken is! String ||
          refreshToken.isEmpty) {
        return const Left(OAuthFailedFailure());
      }
      // OAuth token response uses `newUser` (camelCase) and omits `user_id`
      // (which is populated downstream by the splash guard / SSO-validate
      // round-trip), so build the [AuthSession] manually instead of through
      // [AuthSession.fromJson] which expects the OTP-flow snake_case shape.
      final session = AuthSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: '',
        isNewUser: json['newUser'] == true,
      );
      await _local.saveSession(session);
      return Right(session);
    } on DioException catch (e) {
      return Left(StackErrorMapper.map(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> refreshAccessToken() async {
    final refresh = await _local.getRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      return const Left(SessionExpiredFailure());
    }
    try {
      final json = await _api.refreshSession(refreshToken: refresh);
      final newAccess = json['access_token'];
      if (newAccess is! String || newAccess.isEmpty) {
        return const Left(SessionExpiredFailure());
      }
      await _local.updateAccessToken(newAccess);
      return Right(newAccess);
    } on DioException catch (e) {
      final failure = StackErrorMapper.map(e);
      if (failure is SessionExpiredFailure ||
          failure is UnauthorizedFailure ||
          (e.response?.statusCode == 401)) {
        await _local.clearAll();
        return const Left(SessionExpiredFailure());
      }
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    final access = await _local.getAccessToken();
    final refresh = await _local.getRefreshToken();
    Failure? failure;
    if (access != null &&
        access.isNotEmpty &&
        refresh != null &&
        refresh.isNotEmpty) {
      try {
        await _api.signOutCurrent(accessToken: access, refreshToken: refresh);
      } on DioException catch (e) {
        // Non-fatal: we still clear local state so the user can proceed.
        failure = StackErrorMapper.map(e);
      } catch (_) {
        // Ignore — local clear is the source of truth for sign-out state.
      }
    }
    await _local.clearAll();
    return failure == null ? const Right(null) : Left(failure);
  }

  @override
  Future<AuthSession?> loadSession() => _local.loadSession();

  @override
  Future<bool> isAuthenticated() async {
    final refresh = await _local.getRefreshToken();
    return refresh != null && refresh.isNotEmpty;
  }
}
