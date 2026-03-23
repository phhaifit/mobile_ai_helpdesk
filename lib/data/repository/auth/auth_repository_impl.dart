import 'package:dartz/dartz.dart';

import 'package:mobile_ai_helpdesk/core/data/network/exceptions/network_exceptions.dart';
import 'package:mobile_ai_helpdesk/core/domain/error/failure.dart';
import 'package:mobile_ai_helpdesk/data/local/auth/auth_local_datasource.dart';
import 'package:mobile_ai_helpdesk/data/models/auth/change_password_request.dart';
import 'package:mobile_ai_helpdesk/data/models/auth/login_request.dart';
import 'package:mobile_ai_helpdesk/data/models/auth/register_request.dart';
import 'package:mobile_ai_helpdesk/data/models/auth/reset_password_request.dart';
import 'package:mobile_ai_helpdesk/data/network/apis/auth/auth_api.dart';
import 'package:mobile_ai_helpdesk/domain/entity/auth/auth_response.dart';
import 'package:mobile_ai_helpdesk/domain/entity/auth/user.dart';
import 'package:mobile_ai_helpdesk/domain/repository/auth/auth_repository.dart';

/// Auth Repository Implementation - combines API + Local storage
class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _api;
  final AuthLocalDatasource _localDatasource;

  AuthRepositoryImpl(this._api, this._localDatasource);

  @override
  Future<Either<Failure, AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await _api.login(request);
      final authResponse = AuthResponse.fromJson(response);

      // Save token and user locally
      await _localDatasource.saveAuthToken(authResponse.token);
      await _localDatasource.saveUser(authResponse.user);
      await _localDatasource.setLoggedIn(true);

      return Right(authResponse);
    } on Exception catch (e) {
      return Left(NetworkFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> register(
    RegisterRequest request,
  ) async {
    try {
      final response = await _api.register(request);
      final authResponse = AuthResponse.fromJson(response);

      // Save token and user locally
      await _localDatasource.saveAuthToken(authResponse.token);
      await _localDatasource.saveUser(authResponse.user);
      await _localDatasource.setLoggedIn(true);

      return Right(authResponse);
    } on Exception catch (e) {
      return Left(NetworkFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // Get token from local storage
      final token = await _localDatasource.getAuthToken();
      if (token == null) {
        return const Left(NetworkFailure('No auth token found'));
      }

      // Call API to get current user
      final response = await _api.getCurrentUser(token);
      final user = User.fromJson(response);

      // Update local storage
      await _localDatasource.saveUser(user);

      return Right(user);
    } on Exception catch (e) {
      return Left(NetworkFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Get token
      final token = await _localDatasource.getAuthToken();
      if (token != null) {
        await _api.logout(token);
      }

      // Clear local data
      await _localDatasource.clearAllAuthData();

      return const Right(null);
    } on Exception catch (e) {
      return Left(NetworkFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    ChangePasswordRequest request,
  ) async {
    try {
      // Get token from local storage
      final token = await _localDatasource.getAuthToken();
      if (token == null) {
        return const Left(NetworkFailure('No auth token found'));
      }

      await _api.changePassword(request, token);
      return const Right(null);
    } on Exception catch (e) {
      return Left(NetworkFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset(String email) async {
    try {
      await _api.requestPasswordReset(email);
      return const Right(null);
    } on Exception catch (e) {
      return Left(NetworkFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    ResetPasswordRequest request,
  ) async {
    try {
      await _api.resetPassword(request);
      return const Right(null);
    } on Exception catch (e) {
      return Left(NetworkFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> refreshToken() async {
    try {
      // Get token from local storage
      final token = await _localDatasource.getAuthToken();
      if (token == null) {
        return const Left(NetworkFailure('No auth token found'));
      }

      final response = await _api.refreshToken(token);
      final authResponse = AuthResponse.fromJson(response);

      // Update local storage with new token
      await _localDatasource.saveAuthToken(authResponse.token);
      await _localDatasource.saveUser(authResponse.user);

      return Right(authResponse);
    } on Exception catch (e) {
      return Left(NetworkFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final token = await _localDatasource.getAuthToken();
      final isLoggedIn = await _localDatasource.isLoggedIn();
      return token != null && token.isNotEmpty && isLoggedIn;
    } catch (e) {
      return false;
    }
  }
}
