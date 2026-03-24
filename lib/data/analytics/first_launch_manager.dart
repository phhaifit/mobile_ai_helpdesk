import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/domain/analytics/analytics_service.dart';
import '/data/sharedpref/shared_preference_helper.dart';

/// Data class for first launch detection results.
class FirstLaunchData {
  final bool isFirstLaunch;
  final String installationId;
  final String installSource;
  final String? firstLaunchTime;

  const FirstLaunchData({
    required this.isFirstLaunch,
    required this.installationId,
    required this.installSource,
    this.firstLaunchTime,
  });

  @override
  String toString() =>
      'FirstLaunchData('
      'isFirstLaunch: $isFirstLaunch, '
      'installationId: $installationId, '
      'installSource: $installSource, '
      'firstLaunchTime: $firstLaunchTime)';
}

/// Manager for detecting and tracking first app launch.
///
/// Responsibilities:
/// - Detect if this is the first time the app is being opened
/// - Generate and store a unique installation ID
/// - Track the first launch timestamp
/// - Detect installation source (organic, paid, referral)
/// - Report metrics to AnalyticsService
///
/// Usage:
/// ```dart
/// final data = await FirstLaunchManager.checkAndTrackFirstLaunch(
///   analyticsService: getIt<AnalyticsService>(),
///   sharedPreferenceHelper: getIt<SharedPreferenceHelper>(),
/// );
///
/// if (data.isFirstLaunch) {
///   debugPrint('First app open! Installation ID: ${data.installationId}');
/// }
/// ```
class FirstLaunchManager {
  /// Checks if this is the first app launch and tracks installation data.
  ///
  /// This method should be called early in app initialization (after Firebase init).
  ///
  /// Parameters:
  /// - [analyticsService]: AnalyticsService instance for tracking events
  /// - [sharedPreferenceHelper]: SharedPreferenceHelper for persistence
  ///
  /// Returns:
  /// - [FirstLaunchData] with launch status and installation info
  static Future<FirstLaunchData> checkAndTrackFirstLaunch({
    required AnalyticsService analyticsService,
    required SharedPreferenceHelper sharedPreferenceHelper,
  }) async {
    try {
      // Check if app has been opened before
      final isFirstOpen =
          !(sharedPreferenceHelper.getIsAppFirstOpen() ?? false);

      if (isFirstOpen) {
        debugPrint('[Analytics] First app open detected');

        // Generate installation ID
        const uuid = Uuid();
        final installationId = uuid.v4();

        // Get current timestamp
        final now = DateTime.now();
        final firstLaunchTime = now.toIso8601String();

        // Detect installation source
        final installSource = await _detectInstallSource();

        // Store data in SharedPreferences
        await sharedPreferenceHelper.setIsAppFirstOpen(true);
        await sharedPreferenceHelper.setFirstLaunchTime(firstLaunchTime);
        await sharedPreferenceHelper.setInstallationId(installationId);
        await sharedPreferenceHelper.setInstallSource(installSource);
        // Get app version for tracking
        final packageInfo = await PackageInfo.fromPlatform();

        // Track first app open with analytics
        await analyticsService.trackAppOpen(
          installSource: installSource,
          sessionId: installationId,
        );

        // Set user properties for segmentation
        await analyticsService.setUserProperties(
          installationId,
          userProperties: {
            'install_source': installSource,
            'app_version': packageInfo.version,
            'build_number': packageInfo.buildNumber,
            'first_launch_time': firstLaunchTime,
          },
        );

        debugPrint(
          '[Analytics] Installation tracked:'
          '\n  - Installation ID: $installationId'
          '\n  - Install Source: $installSource'
          '\n  - First Launch Time: $firstLaunchTime'
          '\n  - App Version: ${packageInfo.version}',
        );

        return FirstLaunchData(
          isFirstLaunch: true,
          installationId: installationId,
          installSource: installSource,
          firstLaunchTime: firstLaunchTime,
        );
      } else {
        // App has been opened before - retrieve existing data
        final installationId = sharedPreferenceHelper.getInstallationId();
        final installSource = sharedPreferenceHelper.getInstallSource();
        final firstLaunchTime = sharedPreferenceHelper.getFirstLaunchTime();

        debugPrint(
          '[Analytics] Existing installation:'
          '\n  - Installation ID: $installationId'
          '\n  - Install Source: $installSource'
          '\n  - First Launch Time: $firstLaunchTime',
        );

        return FirstLaunchData(
          isFirstLaunch: false,
          installationId: installationId ?? 'unknown',
          installSource: installSource ?? 'unknown',
          firstLaunchTime: firstLaunchTime,
        );
      }
    } catch (e) {
      debugPrint('[Analytics Error] First launch detection failed: $e');

      // Graceful degradation - generate a temporary ID if everything fails
      const uuid = Uuid();
      final fallbackId = uuid.v4();

      return FirstLaunchData(
        isFirstLaunch: true,
        installationId: fallbackId,
        installSource: 'unknown',
      );
    }
  }

  /// Detects the installation source (where the app was installed from).
  ///
  /// Currently returns 'organic' by default.
  /// Can be enhanced in the future to detect:
  /// - Google Play Store (Android)
  /// - App Store (iOS)
  /// - Paid campaigns (via deep links)
  /// - Referral programs
  ///
  /// Returns:
  /// - 'organic' (default)
  /// - 'google_play' (if installed from Play Store)
  /// - 'app_store' (if installed from Apple App Store)
  /// - 'paid' (if from paid campaign)
  /// - 'referral' (if from referral program)
  static Future<String> _detectInstallSource() async {
    try {
      // TODO: Enhance this in Phase 2
      // For now, default to 'organic'
      // Future enhancements:
      // 1. Android: Use InstallReferrer API to check if from Play Store
      // 2. iOS: App Store installs are implicit
      // 3. Deep links: Check for utm_source in initial deep link

      return 'organic';
    } catch (e) {
      debugPrint('[Analytics] Install source detection failed: $e');
      return 'unknown';
    }
  }
}
