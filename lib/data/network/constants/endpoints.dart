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
  static String tenants() => '/api/v1/tenants';
    static String createTenantOnFirstLogin() => '/api/v1/tenants/create-first-login';
  static String tenant(String tenantId) => '/api/v1/tenants/$tenantId';
    static String tenantInvitationJoinInfo() => '/api/v1/tenants/invitation';
  static String switchTenant(String tenantId) => '/api/v1/tenants/$tenantId/switch';
  static String tenantSettings(String tenantId) =>
      '/api/v1/tenants/$tenantId/settings';

  // Team member endpoints
  static String tenantMembers(String tenantId) => '/api/v1/tenants/$tenantId/members';
  static String tenantMember(String tenantId, String memberId) =>
      '/api/v1/tenants/$tenantId/members/$memberId';
  static String tenantMemberPermissions(String tenantId, String memberId) =>
      '/api/v1/tenants/$tenantId/members/$memberId/permissions';

  // Invitation endpoints
  static String tenantInvitations(String tenantId) =>
      '/api/v1/tenants/$tenantId/invitations';
  static String resendInvitation(String invitationId) =>
      '/api/v1/invitations/$invitationId/resend';
  static String acceptInvitation(String invitationId) =>
      '/api/v1/invitations/$invitationId/accept';
  static String declineInvitation(String invitationId) =>
      '/api/v1/invitations/$invitationId/decline';
  static String deleteInvitation(String invitationId) =>
      '/api/v1/invitations/$invitationId';
}
