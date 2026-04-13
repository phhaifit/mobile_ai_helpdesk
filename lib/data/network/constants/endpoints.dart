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
  static String agentsByTenant(String tenantId) =>
      '/api/v1/ai-agents/tenants/$tenantId';
  static String agentById(String id) => '/api/v1/ai-agents/$id';
  static String agentInfo(String id) => '/api/v1/ai-agents/$id/information';
  static String agentAsk(String id) => '/api/v1/ai-agents/$id/ask';
  static String agentChatComplete(String id) =>
      '/api/v1/ai-agents/$id/chat-complete';
  static String agentDraftResponse(String tenantId) =>
      '/api/v1/ai-agents/$tenantId/draft-response';
  static String agentDraftResponseStream(String tenantId) =>
      '/api/v1/ai-agents/$tenantId/draft-response/stream';
}
