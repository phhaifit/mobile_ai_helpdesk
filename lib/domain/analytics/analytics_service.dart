/// Analytics service interface for tracking user acquisition, events, and screen views.
///
/// Defines the contract for analytics operations without any platform-specific
/// implementation details. Current implementation uses Firebase Analytics.
///
/// Usage:
/// ```dart
/// final analyticsService = getIt<AnalyticsService>();
/// await analyticsService.trackEvent('user_login', {'success': true});
/// await analyticsService.trackScreenView('home_screen');
/// ```
abstract class AnalyticsService {
  /// Tracks the app opening event (first-time open or session open).
  ///
  /// Parameters:
  /// - [installSource]: Where the app was installed from (organic, paid, referral, direct)
  /// - [utmParams]: Optional UTM tracking parameters from deep link
  /// - [sessionId]: Optional unique session identifier
  Future<void> trackAppOpen({
    required String installSource,
    Map<String, String>? utmParams,
    String? sessionId,
  });

  /// Tracks a generic event with optional parameters.
  ///
  /// Parameters:
  /// - [eventName]: Name of the event (e.g., 'user_login', 'ticket_created')
  /// - [parameters]: Optional map of event-specific parameters
  ///
  /// Example:
  /// ```dart
  /// await analyticsService.trackEvent(
  ///   'ticket_created',
  ///   {'priority': 'high', 'category': 'billing'},
  /// );
  /// ```
  Future<void> trackEvent(String eventName, {Map<String, String>? parameters});

  /// Tracks a screen view for navigation analytics.
  ///
  /// Parameters:
  /// - [screenName]: Name of the screen (e.g., 'home', 'ticket_detail')
  /// - [screenClass]: Optional class name or module (e.g., 'HomeScreen')
  /// - [utmParams]: Optional UTM parameters from deep link
  ///
  /// Example:
  /// ```dart
  /// await analyticsService.trackScreenView(
  ///   'ticket_detail',
  ///   screenClass: 'TicketDetailScreen',
  /// );
  /// ```
  Future<void> trackScreenView(
    String screenName, {
    String? screenClass,
    Map<String, String>? utmParams,
  });

  /// Sets user properties for segmentation and analysis.
  ///
  /// Parameters:
  /// - [userId]: Unique user identifier (anonymized)
  /// - [userProperties]: Map of user property keys and values
  ///
  /// Example:
  /// ```dart
  /// await analyticsService.setUserProperties(
  ///   'user_123',
  ///   {
  ///     'user_role': 'agent',
  ///     'install_source': 'organic',
  ///     'app_version': '0.1.0',
  ///   },
  /// );
  /// ```
  Future<void> setUserProperties(
    String userId, {
    required Map<String, String> userProperties,
  });

  /// Enables or disables analytics collection.
  ///
  /// Useful for respecting user privacy preferences.
  ///
  /// Parameters:
  /// - [enabled]: Whether to enable analytics collection
  Future<void> setAnalyticsCollectionEnabled(bool enabled);

  /// Sets a user property specific to analytics.
  ///
  /// Parameters:
  /// - [name]: Name of the user property
  /// - [value]: Value of the user property
  Future<void> setUserProperty(String name, String value);
}
