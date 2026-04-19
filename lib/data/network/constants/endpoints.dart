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
}
