import 'package:ai_helpdesk/core/domain/error/failure.dart';

/// Auth-specific [Failure] subclasses. The `code` is the machine-readable
/// key used by the repository's localizer; the `message` is a safe fallback
/// in case localization is unavailable.
abstract class AuthFailure extends Failure {
  final String code;
  const AuthFailure({required this.code, required String message}) : super(message);
}

/// OTP was already consumed (backend: `VERIFICATION_CODE_ALREADY_USED`).
class OtpAlreadyUsedFailure extends AuthFailure {
  const OtpAlreadyUsedFailure([
    String message = 'The verification code has already been used.',
  ]) : super(code: 'auth_error_otp_used', message: message);
}

/// OTP does not exist or has expired (backend: `VERIFICATION_CODE_NOT_FOUND`).
class OtpNotFoundFailure extends AuthFailure {
  const OtpNotFoundFailure([
    String message = 'The verification code is invalid or expired.',
  ]) : super(code: 'auth_error_otp_not_found', message: message);
}

/// Code+nonce concatenation did not match expected length (45) — backend
/// replies with `SCHEMA_ERROR`. Usually means the user mistyped the OTP.
class InvalidOtpFormatFailure extends AuthFailure {
  const InvalidOtpFormatFailure([
    String message = 'Please enter the full 6-character code.',
  ]) : super(code: 'auth_error_otp_invalid', message: message);
}

/// Refresh token revoked or expired (backend:
/// `REFRESH_TOKEN_NOT_FOUND_OR_EXPIRED`). Force sign-out.
class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure([
    String message = 'Your session has expired. Please sign in again.',
  ]) : super(code: 'auth_error_session_expired', message: message);
}

/// 401 without a recognised auth code — should only surface if refresh fails.
class UnauthorizedFailure extends AuthFailure {
  const UnauthorizedFailure([
    String message = 'You are not signed in.',
  ]) : super(code: 'auth_error_unauthorized', message: message);
}

/// 429 Too Many Requests.
class RateLimitFailure extends AuthFailure {
  const RateLimitFailure([
    String message = 'Too many attempts. Please wait a moment and try again.',
  ]) : super(code: 'auth_error_rate_limit', message: message);
}

/// Input-side validation (e.g., malformed email).
class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure([
    String message = 'Please enter a valid email address.',
  ]) : super(code: 'auth_error_invalid_email', message: message);
}

/// User dismissed the in-app browser before completing the OAuth flow
/// (e.g., tapped Cancel on the iOS modal or pressed back on Android).
/// Treat as a benign no-op — UI should clear loading state without showing
/// a scary error.
class OAuthCancelledFailure extends AuthFailure {
  const OAuthCancelledFailure([
    String message = 'Sign-in was cancelled.',
  ]) : super(code: 'auth_error_oauth_cancelled', message: message);
}

/// OAuth flow failed in a way that is not a clean cancellation: state
/// mismatch (CSRF), missing `code` in callback, or the in-app browser
/// returned an unexpected URL.
class OAuthFailedFailure extends AuthFailure {
  const OAuthFailedFailure([
    String message = "Couldn't sign in with Google. Please try again.",
  ]) : super(code: 'auth_error_oauth_failed', message: message);
}
