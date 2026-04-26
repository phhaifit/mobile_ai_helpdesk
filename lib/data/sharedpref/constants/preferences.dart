class Preferences {
  Preferences._();

  // Authentication
  static const String isLoggedIn = 'isLoggedIn';
  static const String authToken = 'authToken';
  static const String authRefreshToken = 'authRefreshToken';
  static const String accountJson = 'accountJson';
  static const String tenantId = 'tenantId';
  static const String isDarkMode = 'is_dark_mode';
  static const String currentLanguage = 'current_language';

  // Tenant
  static const String tenantId = 'tenantId';

  // Analytics - First Launch & Installation
  static const String isAppFirstOpen = 'is_app_first_open';
  static const String firstLaunchTime = 'first_launch_time';
  static const String installationId = 'installation_id';
  static const String installSource = 'install_source';
}
