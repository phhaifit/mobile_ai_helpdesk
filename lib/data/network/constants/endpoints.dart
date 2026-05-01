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
  // Omnichannel: Zalo endpoints
  static String zaloGenerateQr() => '/api/v1/zalo/qr/generate';
  static String zaloQrStatus(String code) => '/api/v1/zalo/qr/$code/status';
  static String verifyZaloAuthCode() => '/api/v1/zalo/oauth/verify';
  static String zaloConnect() => '/api/v1/zalo/connect';
  static String zaloDisconnect() => '/api/v1/zalo/disconnect';
  static String zaloConnections() => '/api/v1/zalo/connections';
  static String sendZaloMessage() => '/api/v1/zalo/messages/send';
  static String syncZaloMessages() => '/api/v1/zalo/sync/messages';
  static String syncZaloCustomers() => '/api/v1/zalo/sync/customers';
  static String assignZaloCs() => '/api/v1/zalo/assign-cs';

  // Ticket endpoints
  static const String ticketCustomerHistory = '/api/ticket/customer-ticket';
  static String ticketComments(String ticketId) =>
      '/api/ticket/comment/get-comment/$ticketId';
  static const String ticketAddComment = '/api/ticket/comment/add-comment';
  static String ticketDeleteComment(String commentId) =>
      '/api/ticket/comment/$commentId';

  // Knowledge Base endpoints
  static String knowledgeSources(String tenantId) =>
      '/api/v1/knowledges/$tenantId/sources';
  static String knowledgeSourcesByType(String tenantId, String type) =>
      '/api/v1/knowledges/$tenantId/sources/$type';
  static String knowledgeSource(String tenantId, String sourceId) =>
      '/api/v1/knowledges/$tenantId/sources/$sourceId';
  static String knowledgeReindex(String tenantId, String sourceId) =>
      '/api/v1/knowledges/$tenantId/sources/$sourceId/reindex';
  static String knowledgeInterval(String tenantId, String sourceId) =>
      '/api/v1/knowledges/$tenantId/sources/$sourceId/interval';
  static String knowledgeImportWeb(String tenantId) =>
      '/api/v1/knowledges/$tenantId/web';
  static String knowledgeStatusSse(String tenantId) =>
      '/api/v1/knowledges/$tenantId/status-sse';
  static String knowledgeSourceStatus(String tenantId, String sourceId) =>
      '/api/v1/knowledges/$tenantId/sources/$sourceId/status';
  static const String knowledgePollStatus =
      '/api/v1/knowledges/sources/poll-status';

  // WebSocket
  static String ticketWebSocket(String ticketId) {
    final wsBase = baseUrl
        .replaceFirst('https://', 'wss://')
        .replaceFirst('http://', 'ws://');
    return '$wsBase/ws/ticket/$ticketId';
  }
}
