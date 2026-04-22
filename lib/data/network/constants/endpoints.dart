import '/constants/env.dart';

class Endpoints {
  Endpoints._();

  // Helpdesk host (tenant-scoped endpoints).
  static String get baseUrl => EnvConfig.instance.helpdeskApiBaseUrl;
  static String get helpdeskBaseUrl => EnvConfig.instance.helpdeskApiBaseUrl;

  // Stack Auth host (token issuance / refresh / revoke).
  static String get authBaseUrl => EnvConfig.instance.authApiBaseUrl;

  static int get receiveTimeout => EnvConfig.instance.receiveTimeout;
  static int get connectionTimeout => EnvConfig.instance.connectionTimeout;

  // ---- Stack Auth ---------------------------------------------------------
  static const String authSendSignInCode = '/api/v1/auth/otp/send-sign-in-code';
  static const String authOtpSignIn = '/api/v1/auth/otp/sign-in';
  static const String authRefreshSession =
      '/api/v1/auth/sessions/current/refresh';
  static const String authCurrentSession = '/api/v1/auth/sessions/current';

  // ---- Helpdesk Account ---------------------------------------------------
  static const String accountSsoValidate = '/api/account/sso-validate';
  static const String accountMe = '/api/account/me';
  static const String accountAvatar = '/api/account/me/avatar';

  // Post endpoints (legacy)
  static const String getPosts = '/posts';

  // AI Agent endpoints (stubs — mock data served locally)
  static String agents() => '/api/agents';
  static String agent(String id) => '/api/agents/$id';

  // Playground endpoints (stubs — mock data served locally)
  static String playgroundSessions() => '/api/playground/sessions';
  static String playgroundSession(String id) => '/api/playground/sessions/$id';
  static String playgroundMessages(String sessionId) =>
      '/api/playground/sessions/$sessionId/messages';

  // Omnichannel: Messenger endpoints
  static String messengerCustomers() => '/api/messenger/messenger-customers';
  static String verifyMessengerAuthCode() => '/api/messenger/verify-auth-code';
  static String updateMessengerPageConfig() =>
      '/api/messenger/update-page-config';
  static String messengerPages() => '/api/messenger/pages';
  static String connectMessengerPage() => '/api/messenger/connect-page';
  static String deleteMessengerPage(String channelId) =>
      '/api/messenger/page/$channelId';
  static String resyncMessengerPage() => '/api/messenger/resync-page';
}
