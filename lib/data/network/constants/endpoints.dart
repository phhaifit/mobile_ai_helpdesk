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
}
