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

  // AI Agent endpoints
  static String agents() => '/api/agents';
  static String agent(String id) => '/api/agents/$id';

  // Playground endpoints (stubs — mock data served locally)
  static String playgroundSessions() => '/api/playground/sessions';
  static String playgroundSession(String id) =>
      '/api/playground/sessions/$id';
  static String playgroundMessages(String sessionId) =>
      '/api/playground/sessions/$sessionId/messages';

  // 13. Media
  static String uploadFile(String tenantId) =>
      '/api/v1/media/save-file/$tenantId';
  static String previewMedia(String id) => '/api/v1/media/preview/$id';

  // 8. Jarvis Agent (Team AI)
  static String jarvisMessage(String tenantId) =>
      '/api/v1/ai-agents/tenants/$tenantId/jarvis-agent/message';
  static String jarvisMessageStream(String tenantId) =>
      '/api/v1/ai-agents/tenants/$tenantId/jarvis-agent/message/stream';
  static String jarvisConfirm(String tenantId) =>
      '/api/v1/ai-agents/tenants/$tenantId/jarvis-agent/confirm';

  // Apps Integration — Messenger
  static const String messengerPages = '/api/messenger/pages';
  static const String messengerConnectPage = '/api/messenger/connect-page';
  static String messengerDisconnectPage(String channelId) =>
      '/api/messenger/page/$channelId';
  static const String messengerUpdatePageConfig =
      '/api/messenger/update-page-config';
  static const String messengerResyncPage = '/api/messenger/resync-page';
  static const String messengerVerifyAuthCode =
      '/api/messenger/verify-auth-code';
}
