import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_session.dart';
import 'package:ai_helpdesk/domain/entity/auth/otp_send_result.dart';
import 'package:dartz/dartz.dart';

/// Stack Auth OTP flow.
abstract class AuthRepository {
  /// Request an OTP to be emailed. Returns the `nonce` used to sign in.
  Future<Either<Failure, OtpSendResult>> sendOtp({required String email});

  /// Exchange the user-entered 6-char code + nonce for an [AuthSession].
  Future<Either<Failure, AuthSession>> signInWithOtp({
    required String code,
    required String nonce,
  });

  /// Run the full Google OAuth (PKCE) flow: open the in-app browser at
  /// Stack Auth's `/oauth/authorize/google` endpoint, wait for the registered
  /// callback URL, then exchange `code + code_verifier` for an [AuthSession].
  /// On success the session is persisted locally just like the OTP flow.
  ///
  /// Set [forceAccountChooser] true to clear cached cookies + force Google's
  /// account chooser; default false preserves the auto-resume UX.
  Future<Either<Failure, AuthSession>> signInWithGoogle({
    bool forceAccountChooser = false,
  });

  /// Rotate the access token using the stored refresh token. Returns the new
  /// access token on success. Called by the refresh interceptor and the
  /// splash guard — must be idempotent and never recurse through itself.
  Future<Either<Failure, String>> refreshAccessToken();

  /// Invalidate the current refresh token on the backend and clear local
  /// session state. Local state is cleared even if the network call fails.
  Future<Either<Failure, void>> signOut();

  /// Load the cached session (access + refresh) from local storage, or null.
  Future<AuthSession?> loadSession();

  /// Whether a non-empty refresh token is present locally.
  Future<bool> isAuthenticated();
}
