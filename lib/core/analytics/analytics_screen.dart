/// Screen names for Firebase Analytics screen_view events.
/// Must match the names used in [AnalyticsService.logScreenView].
class AnalyticsScreen {
  AnalyticsScreen._();

  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot_password';
  static const String resetPassword = 'reset_password';
  static const String home = 'home';
  static const String dashboard = 'home_dashboard';
  static const String tickets = 'home_tickets';
  static const String omnichannelTab = 'home_omnichannel';
  static const String monetizationTab = 'home_monetization';
  static const String profile = 'profile';
  static const String changePassword = 'change_password';
  static const String omnichannelHub = 'omnichannel_hub';
  static const String messengerDashboard = 'messenger_dashboard';
  static const String messengerOauthStatus = 'messenger_oauth_status';
  static const String messengerCustomerSync = 'messenger_customer_sync';
  static const String messengerSettings = 'messenger_settings';
  static const String zaloOverview = 'zalo_overview';
  static const String zaloConnectQr = 'zalo_connect_qr';
  static const String zaloOauthManagement = 'zalo_oauth_management';
  static const String zaloSyncStatus = 'zalo_sync_status';
  static const String zaloAccountAssignment = 'zalo_account_assignment';
  static const String zaloPersonalMessage = 'zalo_personal_message';
  static const String monetization = 'monetization';
  static const String upgradePayment = 'upgrade_payment';
  static const String upgradeConfirmation = 'upgrade_confirmation';
}
