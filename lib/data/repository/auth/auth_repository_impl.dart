import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/data/local/auth/auth_local_datasource.dart';
import 'package:ai_helpdesk/data/models/auth/change_password_request.dart';
import 'package:ai_helpdesk/data/models/auth/login_request.dart';
import 'package:ai_helpdesk/data/models/auth/register_request.dart';
import 'package:ai_helpdesk/data/models/auth/reset_password_request.dart';
import 'package:ai_helpdesk/data/network/apis/auth/auth_api.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_response.dart';
import 'package:ai_helpdesk/domain/entity/auth/user.dart';
import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ai_helpdesk/core/data/network/exceptions/network_exceptions.dart';
import 'package:flutter/foundation.dart';

/// Auth Repository Implementation — combines API + Local storage.
///
/// Auth flow for sign-in / sign-up:
///   1. Call auth endpoint → receive `{access_token, refresh_token, user_id}`.
///   2. Persist tokens locally.
///   3. Call `getCurrentUser` to fetch full user profile.
///   4. Persist user + mark logged-in.
///   5. Return [AuthResponse] with user attached.
class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _api;
  final AuthLocalDatasource _localDatasource;

  AuthRepositoryImpl(this._api, this._localDatasource);

  // ── Sign In ────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, AuthResponse>> login(LoginRequest request) async {
    try {
      final tokenData = await _api.login(request);
      return _completeAuthFlow(tokenData);
    } on DioException catch (e) {
      return Left(NetworkExceptions.getDioException(e));
    } on Exception catch (e) {
      return Left(NetworkFailure(_cleanMessage(e)));
    }
  }

  // ── Sign Up ────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, AuthResponse>> register(
    RegisterRequest request,
  ) async {
    try {
      final tokenData = await _api.register(request);
      return _completeAuthFlow(tokenData);
    } on DioException catch (e) {
      return Left(NetworkExceptions.getDioException(e));
    } on Exception catch (e) {
      return Left(NetworkFailure(_cleanMessage(e)));
    }
  }

  // ── Get Current User ───────────────────────────────────────────────────────

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final token = await _localDatasource.getAuthToken();
      if (token == null || token.isEmpty) {
        return const Left(NetworkFailure('No auth token found'));
      }

      final data = await _api.getCurrentUser(token);
      final user = User.fromJson(data);
      await _localDatasource.saveUser(user);
      return Right(user);
    } on DioException catch (e) {
      return Left(NetworkExceptions.getDioException(e));
    } on Exception catch (e) {
      return Left(NetworkFailure(_cleanMessage(e)));
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final accessToken = await _localDatasource.getAuthToken() ?? '';
      final refreshToken = await _localDatasource.getRefreshToken() ?? '';

      if (accessToken.isNotEmpty) {
        await _api.logout(accessToken, refreshToken);
      }

      await _localDatasource.clearAllAuthData();
      return const Right(null);
    } on DioException catch (e) {
      // Even if the server call fails, clear local data.
      await _localDatasource.clearAllAuthData();
      return Left(NetworkExceptions.getDioException(e));
    } on Exception catch (_) {
      await _localDatasource.clearAllAuthData();
      return const Right(null);
    }
  }

  // ── Change Password ───────────────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> changePassword(
    ChangePasswordRequest request,
  ) async {
    try {
      final token = await _localDatasource.getAuthToken();
      if (token == null || token.isEmpty) {
        return const Left(NetworkFailure('No auth token found'));
      }
      await _api.changePassword(request, token);
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkExceptions.getDioException(e));
    } on Exception catch (e) {
      return Left(NetworkFailure(_cleanMessage(e)));
    }
  }

  // ── Password Reset ────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> requestPasswordReset(String email) async {
    try {
      await _api.requestPasswordReset(email);
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkExceptions.getDioException(e));
    } on Exception catch (e) {
      return Left(NetworkFailure(_cleanMessage(e)));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    ResetPasswordRequest request,
  ) async {
    try {
      await _api.resetPassword(request);
      return const Right(null);
    } on DioException catch (e) {
      return Left(NetworkExceptions.getDioException(e));
    } on Exception catch (e) {
      return Left(NetworkFailure(_cleanMessage(e)));
    }
  }

  // ── Refresh Token ─────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, AuthResponse>> refreshToken() async {
    try {
      final storedRefresh = await _localDatasource.getRefreshToken();
      if (storedRefresh == null || storedRefresh.isEmpty) {
        return const Left(NetworkFailure('No refresh token found'));
      }

      final data = await _api.refreshToken(storedRefresh);
      final newAccessToken = data['access_token'] as String;

      // Persist the new access token.
      await _localDatasource.saveAuthToken(newAccessToken);

      final authResponse = AuthResponse(
        token: newAccessToken,
        refreshToken: storedRefresh,
      );

      return Right(authResponse);
    } on DioException catch (e) {
      return Left(NetworkExceptions.getDioException(e));
    } on Exception catch (e) {
      return Left(NetworkFailure(_cleanMessage(e)));
    }
  }

  // ── Auth State Check ──────────────────────────────────────────────────────

  @override
  Future<bool> isAuthenticated() async {
    try {
      final token = await _localDatasource.getAuthToken();
      final loggedIn = await _localDatasource.isLoggedIn();
      return token != null && token.isNotEmpty && loggedIn;
    } catch (_) {
      return false;
    }
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  /// Shared flow after sign-in or sign-up: persist tokens, fetch user, persist user.
  Future<Either<Failure, AuthResponse>> _completeAuthFlow(
    Map<String, dynamic> tokenData,
  ) async {
    final accessToken = tokenData['access_token'] as String;
    final refreshTokenValue = tokenData['refresh_token'] as String?;

    // 1. Persist tokens.
    await _localDatasource.saveAuthToken(accessToken);
    if (refreshTokenValue != null && refreshTokenValue.isNotEmpty) {
      await _localDatasource.saveRefreshToken(refreshTokenValue);
    }

    // 2. Fetch full user profile.
    User? user;
    try {
      final userData = await _api.getCurrentUser(accessToken);
      user = User.fromJson(userData);
      await _localDatasource.saveUser(user);
    } catch (e) {
      debugPrint('[AuthRepositoryImpl] getCurrentUser after auth failed: $e');
      // Non-fatal: tokens are valid even if profile fetch fails.
    }

    // 3. Mark logged in.
    await _localDatasource.setLoggedIn(true);

    final authResponse = AuthResponse(
      token: accessToken,
      refreshToken: refreshTokenValue,
      userId: tokenData['user_id'] as String?,
    ).withUser(
      user ??
          User(
            id: tokenData['user_id'] as String? ?? '',
            email: '',
            username: '',
          ),
    );

    return Right(authResponse);
  }

  String _cleanMessage(Exception e) =>
      e.toString().replaceFirst('Exception: ', '');
}
