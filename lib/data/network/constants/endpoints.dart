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
  static String playgroundSession(String id) =>
      '/api/playground/sessions/$id';
  static String playgroundMessages(String sessionId) =>
      '/api/playground/sessions/$sessionId/messages';

  // Tenant endpoints
  static String tenants() => '/api/tenants';
  static String tenant(String tenantId) => '/api/tenants/$tenantId';
  static String switchTenant(String tenantId) => '/api/tenants/$tenantId/switch';
  static String tenantSettings(String tenantId) =>
      '/api/tenants/$tenantId/settings';

  // Team member endpoints
  static String tenantMembers(String tenantId) => '/api/tenants/$tenantId/members';
  static String tenantMember(String tenantId, String memberId) =>
      '/api/tenants/$tenantId/members/$memberId';
  static String tenantMemberPermissions(String tenantId, String memberId) =>
      '/api/tenants/$tenantId/members/$memberId/permissions';

  // Invitation endpoints
  static String tenantInvitations(String tenantId) =>
      '/api/tenants/$tenantId/invitations';
  static String resendInvitation(String invitationId) =>
      '/api/invitations/$invitationId/resend';
  static String acceptInvitation(String invitationId) =>
      '/api/invitations/$invitationId/accept';
  static String declineInvitation(String invitationId) =>
      '/api/invitations/$invitationId/decline';
}
