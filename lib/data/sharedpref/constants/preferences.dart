class Preferences {
  Preferences._();

  static const String isLoggedIn = 'isLoggedIn';
  static const String authToken = 'authToken';
  static const String authRefreshToken = 'authRefreshToken';
  static const String userData = 'userData';
  static const String isDarkMode = 'is_dark_mode';
  static const String currentLanguage = 'current_language';

  /// User properties for analytics (set after login).
  static const String tenantId = 'tenant_id';
  static const String userRole = 'user_role';
  static const String planType = 'plan_type';

  /// First launch / install tracking (analytics).
  static const String isAppFirstOpen = 'is_app_first_open';
  static const String firstLaunchTime = 'first_launch_time';
  static const String installationId = 'installation_id';
  static const String installSource = 'install_source';
}
