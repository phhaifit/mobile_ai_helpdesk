import 'package:ai_helpdesk/constants/env.dart';
import 'package:ai_helpdesk/core/domain/error/failure.dart';
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

  AuthRepositoryImpl(this._api, this._local, this._env);

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
