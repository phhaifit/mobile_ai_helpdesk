import 'package:dartz/dartz.dart';

import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/data/models/auth/change_password_request.dart';
import 'package:ai_helpdesk/data/models/auth/login_request.dart';
import 'package:ai_helpdesk/data/models/auth/register_request.dart';
import 'package:ai_helpdesk/data/models/auth/reset_password_request.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_response.dart';
import 'package:ai_helpdesk/domain/entity/auth/user.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, AuthResponse>> login(LoginRequest request);

  /// Register a new account
  Future<Either<Failure, AuthResponse>> register(RegisterRequest request);

  /// Get current logged-in user
  Future<Either<Failure, User>> getCurrentUser();

  /// Logout the current user
  Future<Either<Failure, void>> logout();

  /// Change password for current user
  Future<Either<Failure, void>> changePassword(ChangePasswordRequest request);

  /// Request password reset (send reset email)
  Future<Either<Failure, void>> requestPasswordReset(String email);

  /// Reset password with reset token
  Future<Either<Failure, void>> resetPassword(ResetPasswordRequest request);

  /// Refresh authentication token
  Future<Either<Failure, AuthResponse>> refreshToken();

  /// Check if user is authenticated (has valid token)
  Future<bool> isAuthenticated();
}
