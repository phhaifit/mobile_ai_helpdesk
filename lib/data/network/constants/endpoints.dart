import '/constants/env.dart';

class Endpoints {
  Endpoints._();

  // base url — sourced from EnvConfig
  static String get baseUrl => EnvConfig.instance.baseUrl;

  // receiveTimeout — sourced from EnvConfig
  static int get receiveTimeout => EnvConfig.instance.receiveTimeout;

  // connectTimeout — sourced from EnvConfig
  static int get connectionTimeout => EnvConfig.instance.connectionTimeout;

  // Post endpoints (legacy)
  static const String getPosts = '/posts';

  // ── Auth endpoints (auth-api.jarvis.cx) ──────────────────────────────────
  static const String signUp = '/api/v1/auth/password/sign-up';
  static const String signIn = '/api/v1/auth/password/sign-in';
  static const String refreshToken = '/api/v1/auth/sessions/current/refresh';
  static const String logout = '/api/v1/auth/sessions/current';

  // ── User endpoints (api.jarvis.cx) ───────────────────────────────────────
  static const String getCurrentUser = '/api/v1/auth/me';
  static const String updateProfile = '/api/v1/users/me';
  static const String uploadAvatar = '/api/v1/users/me/avatar';

  // ── Password endpoints (api.jarvis.cx — mock until real API) ─────────────
  static const String forgotPassword = '/api/v1/auth/forgot-password';
  static const String resetPassword = '/api/v1/auth/reset-password';
  static const String changePassword = '/api/v1/auth/change-password';

  // AI Agent endpoints (stubs — mock data served locally)
  static String agents() => '/api/agents';
  static String agent(String id) => '/api/agents/$id';

  // Playground endpoints (stubs — mock data served locally)
  static String playgroundSessions() => '/api/playground/sessions';
  static String playgroundSession(String id) =>
      '/api/playground/sessions/$id';
  static String playgroundMessages(String sessionId) =>
      '/api/playground/sessions/$sessionId/messages';
}
