/// Constants for the Stack Auth API provider.
///
/// These headers are required by auth-api.jarvis.cx for all auth operations.
/// When switching auth providers, only this file needs to change.
class AuthApiConstants {
  AuthApiConstants._();

  /// Base URL for the authentication API (separate from main API).
  static const String authBaseUrl = 'https://auth-api.jarvis.cx';

  /// Base URL for the main Jarvis API (user profile, etc.).
  static const String apiBaseUrl = 'https://api.jarvis.cx';

  // Stack Auth headers -------------------------------------------------------

  static const String stackAccessType = 'client';
  static const String stackProjectId = 'a914f06b-5e46-4966-8693-80e4b9f4f409';
  static const String stackPublishableClientKey =
      'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr';

  /// Default X-Stack headers required on every auth request.
  static Map<String, String> get stackHeaders => {
        'X-Stack-Access-Type': stackAccessType,
        'X-Stack-Project-Id': stackProjectId,
        'X-Stack-Publishable-Client-Key': stackPublishableClientKey,
      };

  /// Email verification callback URL required by the sign-up endpoint.
  static const String verificationCallbackUrl =
      'https://auth.jarvis.cx/handler/email-verification'
      '?after_auth_return_to=%2Fauth%2Fsignin'
      '%3Fclient_id%3Djarvis_chat'
      '%26redirect%3Dhttps%253A%252F%252Fchat.jarvis.cx'
      '%252Fauth%252Foauth%252Fsuccess';
}
