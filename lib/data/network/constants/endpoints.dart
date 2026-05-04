import '/constants/env.dart';

class Endpoints {
  Endpoints._();

  // Helpdesk host (tenant-scoped endpoints).
  static String get baseUrl => EnvConfig.instance.helpdeskApiBaseUrl;
  static String get helpdeskBaseUrl => EnvConfig.instance.helpdeskApiBaseUrl;

  // Stack Auth host (token issuance / refresh / revoke).
  static String get authBaseUrl => EnvConfig.instance.authApiBaseUrl;

  // AI-Services host (NestJS) — knowledge base, AI agents, response templates,
  // media. Separate from BE Helpdesk.
  static String get aiServiceBaseUrl => EnvConfig.instance.aiServiceApiBaseUrl;

  static int get receiveTimeout => EnvConfig.instance.receiveTimeout;
  static int get connectionTimeout => EnvConfig.instance.connectionTimeout;

  // ---- Stack Auth ---------------------------------------------------------
  static const String authSendSignInCode = '/api/v1/auth/otp/send-sign-in-code';
  static const String authOtpSignIn = '/api/v1/auth/otp/sign-in';
  static const String authRefreshSession =
      '/api/v1/auth/sessions/current/refresh';
  static const String authCurrentSession = '/api/v1/auth/sessions/current';
  static const String authOauthAuthorizeGoogle =
      '/api/v1/auth/oauth/authorize/google';
  static const String authOauthToken = '/api/v1/auth/oauth/token';

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
  // Marketing/Broadcasting endpoints (Phase A contract baseline)
  // Templates
  static String marketingTemplates() => '/api/marketing/templates';
  static String marketingTemplate(String id) => '/api/marketing/templates/$id';
  static String marketingTemplateSearch() => '/api/marketing/templates/search';

  // Marketing/Broadcasting endpoints (Phase C backend aligned)
  static String marketingV1BroadcastTemplates() =>
      '/api/v1/marketing/templates';
  static String marketingV1BroadcastTemplate(String id) =>
      '/api/v1/marketing/templates/$id';

  static String marketingV1Broadcasts() => '/api/v1/marketing/broadcasts';
  static String marketingV1Broadcast(String id) =>
      '/api/v1/marketing/broadcasts/$id';
  static String marketingV1BroadcastExecute(String id) =>
      '/api/v1/marketing/broadcasts/$id/execute';
  static String marketingV1BroadcastStop(String id) =>
      '/api/v1/marketing/broadcasts/$id/stop';
  static String marketingV1BroadcastResume(String id) =>
      '/api/v1/marketing/broadcasts/$id/resume';
  static String marketingV1BroadcastRecipients() =>
      '/api/v1/marketing/broadcasts/recipients';
  static String marketingV1BroadcastReceipts(String id) =>
      '/api/v1/marketing/broadcasts/$id/receipts';
  static String marketingV1BroadcastStatusTimeline(String id) =>
      '/api/v1/marketing/broadcasts/$id/status-timeline';
  static String marketingV1BroadcastStatusSse(String id) =>
      '/api/v1/marketing/broadcasts/$id/events';

  static String marketingV1FacebookAdminAccounts() =>
      '/api/v1/marketing/ad-accounts';
  static String marketingV1FacebookAdminAccountsFetch() =>
      '/api/v1/marketing/ad-accounts/fetch';
  static String marketingV1FacebookAdminAccount(String id) =>
      '/api/v1/marketing/facebook-admin/accounts/$id';
  static String marketingV1FacebookAdminDisconnect(String id) =>
      '/api/v1/marketing/facebook-admin/accounts/$id/disconnect';
  static String marketingV1FacebookAdminReauth(String id) =>
      '/api/v1/marketing/facebook-admin/accounts/$id/reauth';
  static String marketingV1FacebookAdminPages(String id) =>
      '/api/v1/marketing/facebook-admin/accounts/$id/pages';
  static String marketingV1FacebookAdminSelectPage(String id) =>
      '/api/v1/marketing/facebook-admin/accounts/$id/select-page';

  // Campaigns
  static String marketingCampaigns() => '/api/marketing/campaigns';
  static String marketingCampaign(String id) => '/api/marketing/campaigns/$id';
  static String marketingCampaignStart(String id) =>
      '/api/marketing/campaigns/$id/start';
  static String marketingCampaignStop(String id) =>
      '/api/marketing/campaigns/$id/stop';
  static String marketingCampaignResume(String id) =>
      '/api/marketing/campaigns/$id/resume';

  // Audience / recipient resolution
  static String marketingAudienceEstimate() =>
      '/api/marketing/audience/estimate';
  static String marketingAudienceResolve() => '/api/marketing/audience/resolve';

  // Facebook admin
  static String marketingFacebookConnect() =>
      '/api/marketing/facebook-admin/connect';
  static String marketingFacebookDisconnect() =>
      '/api/marketing/facebook-admin/disconnect';
  static String marketingFacebookReauth() =>
      '/api/marketing/facebook-admin/reauth';
  static String marketingFacebookPages() =>
      '/api/marketing/facebook-admin/pages';
  static String marketingFacebookSelectPage() =>
      '/api/marketing/facebook-admin/select-page';

  // Delivery receipts / status timeline
  static String marketingDeliveryReceipts(String campaignId) =>
      '/api/marketing/campaigns/$campaignId/receipts';
  static String marketingCampaignStatusTimeline(String campaignId) =>
      '/api/marketing/campaigns/$campaignId/status-timeline';

  // Realtime
  static String marketingCampaignStatusSse(String campaignId) =>
      '/api/marketing/campaigns/$campaignId/events';

  static Uri marketingV1BroadcastStatusWsUri(String broadcastId) {
    final base = Uri.parse(baseUrl);
    final wsScheme = base.scheme == 'https' ? 'wss' : 'ws';
    return base.replace(
      scheme: wsScheme,
      path: '/ws/v1/marketing/broadcasts/$broadcastId/status',
      query: '',
    );
  }

  static Uri marketingCampaignStatusWsUri(String campaignId) {
    final base = Uri.parse(baseUrl);
    final wsScheme = base.scheme == 'https' ? 'wss' : 'ws';
    return base.replace(
      scheme: wsScheme,
      path: '/ws/marketing/campaigns/$campaignId/status',
      query: '',
    );
  }

  // Omnichannel: Messenger endpoints
  static String messengerCustomers() => '/api/messenger/messenger-customers';
  static String verifyMessengerAuthCode() => '/api/messenger/verify-auth-code';
  static String updateMessengerPageConfig() =>
      '/api/messenger/update-page-config';
  static String messengerPages() => '/api/messenger/pages';
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

  // Tag Management
  static String get tags => '/api/v1/tags';
  static String tag(String id) => '/api/v1/tags/$id';

  static String assignZaloCs() => '/api/v1/zalo/assign-cs';

  // Customer Management
  static String customerList() => '/api/customer';
  static String customerDetail(String id) => '/api/customer/$id';
  static String checkValidEmail() => '/api/customer/check-valid-email';
  static String createCustomer() => '/api/customer';
  static String updateCustomer(String id) =>
      '/api/customer/update-customer/$id';
  static String addCustomerTag(String id) => '/api/customer/$id/tags';
  static String removeCustomerTag(String customerId, String tagId) =>
      '/api/customer/$customerId/tags/$tagId';
  static String mergeCustomers() => '/api/customer/merge';
  static String addCustomerContact(String id) =>
      '/api/customer/add-customer-contact/$id';
  static String deleteCustomerContact() =>
      '/api/customer/delete-customer-contact';
  static String findAndDeleteContact() => '/api/customer/find-delete-contact';

  // Ticket endpoints
  static const String ticketAll = '/api/ticket/all';
  static const String ticketMy = '/api/ticket/my-ticket';
  static const String ticketMyByStatus = '/api/ticket/mine-by-status';
  static const String ticketUnassigned = '/api/ticket/unassigned';
  static String ticketDetail(String ticketId) => '/api/ticket/$ticketId';
  static const String ticketUpdateStatus = '/api/ticket/update-status';
  static const String ticketCreate = '/api/ticket/new';
  static String ticketUpdateDetail(String ticketId) =>
      '/api/ticket/my-ticket/$ticketId/detail';
  static const String ticketCustomerHistory = '/api/ticket/customer-ticket';
  static String ticketComments(String ticketId) =>
      '/api/ticket/comment/get-comment/$ticketId';
  static const String ticketAddComment = '/api/ticket/comment/add-comment';
  static String ticketDeleteComment(String commentId) =>
      '/api/ticket/comment/$commentId';

  // ---- Knowledge Base ------------------------------------------------------
  static String knowledgeSources(String tenantId) =>
      '/api/v1/knowledges/$tenantId/sources';
  static String knowledgeSourcesByType(String tenantId, String apiType) =>
      '/api/v1/knowledges/$tenantId/sources/$apiType';

  /// PATCH (status) and DELETE both use this path; method disambiguates.
  static String knowledgeSource(String tenantId, String sourceId) =>
      '/api/v1/knowledges/$tenantId/sources/$sourceId';

  static String knowledgeReindex(String tenantId, String sourceId) =>
      '/api/v1/knowledges/$tenantId/sources/$sourceId/reindex';
  static String knowledgeInterval(String tenantId, String sourceId) =>
      '/api/v1/knowledges/$tenantId/sources/$sourceId/interval';

  static String knowledgeImportWeb(String tenantId) =>
      '/api/v1/knowledges/$tenantId/web';
  static String knowledgeImportLocalFile(String tenantId) =>
      '/api/v1/knowledges/$tenantId/local-file';
  static String knowledgeImportGoogleDrive(String tenantId) =>
      '/api/v1/knowledges/$tenantId/google-drive';
  static String knowledgeImportDatabaseQuery(String tenantId) =>
      '/api/v1/knowledges/$tenantId/database-query';
  static String knowledgeUpdateDatabaseQuery(
    String tenantId,
    String sourceId,
  ) => '/api/v1/knowledges/$tenantId/database-query/$sourceId';

  static const String knowledgeTestDatabaseQuery =
      '/api/v1/knowledges/test-database-query';
  static const String knowledgePollStatus =
      '/api/v1/knowledges/sources/poll-status';

  static String knowledgeStatusSse(String tenantId) =>
      '/api/v1/knowledges/$tenantId/status-sse';

  // WebSocket
  static String ticketWebSocket(String ticketId) {
    final wsBase = baseUrl
        .replaceFirst('https://', 'wss://')
        .replaceFirst('http://', 'ws://');
    return '$wsBase/ws/ticket/$ticketId';
  }
}
