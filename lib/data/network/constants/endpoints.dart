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

  // ---- Tenants -------------------------------------------------------------
  static String tenant(String id) => '/api/v1/tenants/$id';

  static String assignZaloCs() => '/api/v1/zalo/assign-cs';

  // Customer Management
  static String customerList() => '/api/customer';
  static String customerDetail(String id) => '/api/customer/$id';
  static String checkValidEmail() => '/api/customer/check-valid-email';
  static String createCustomer() => '/api/customer';
  static String updateCustomer(String id) => '/api/customer/update-customer/$id';
  static String addCustomerTag(String id) => '/api/customer/$id/tags';
  static String removeCustomerTag(String customerId, String tagId) => '/api/customer/$customerId/tags/$tagId';
  static String mergeCustomers() => '/api/customer/merge';
  static String addCustomerContact(String id) => '/api/customer/add-customer-contact/$id';
  static String deleteCustomerContact() => '/api/customer/delete-customer-contact';
  static String findAndDeleteContact() => '/api/customer/find-delete-contact';
}
