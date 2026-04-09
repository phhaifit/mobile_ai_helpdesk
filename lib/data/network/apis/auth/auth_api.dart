import 'package:ai_helpdesk/data/models/auth/change_password_request.dart';
import 'package:ai_helpdesk/data/models/auth/login_request.dart';
import 'package:ai_helpdesk/data/models/auth/register_request.dart';
import 'package:ai_helpdesk/data/models/auth/reset_password_request.dart';

/// Contract for all authentication API operations.
///
/// Implementations:
///  - [RealAuthApi]  — calls real endpoints + mocks missing ones.
///  - [MockAuthApi]  — fully in-memory (offline testing / CI).
///
/// When the 5 stub endpoints become real, update [RealAuthApi] only.
abstract class AuthApi {
  /// Sign in with email + password → raw token map.
  Future<Map<String, dynamic>> login(LoginRequest request);

  /// Register a new account → raw token map.
  Future<Map<String, dynamic>> register(RegisterRequest request);

  /// Fetch the currently authenticated user profile.
  Future<Map<String, dynamic>> getCurrentUser(String accessToken);

  /// Invalidate the current session.
  Future<void> logout(String accessToken, String refreshToken);

  /// Refresh the access token using a refresh token.
  Future<Map<String, dynamic>> refreshToken(String refreshToken);

  /// Change password for the currently authenticated user.
  Future<void> changePassword(
    ChangePasswordRequest request,
    String accessToken,
  );

  /// Request a password-reset email.
  Future<void> requestPasswordReset(String email);

  /// Reset password with a reset token.
  Future<void> resetPassword(ResetPasswordRequest request);

  /// Update user profile fields.
  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> fields,
    String accessToken,
  );

  /// Upload a new avatar image.
  Future<Map<String, dynamic>> uploadAvatar(
    String filePath,
    String accessToken,
  );
}
