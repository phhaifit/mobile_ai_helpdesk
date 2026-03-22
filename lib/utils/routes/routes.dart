import 'package:mobile_ai_helpdesk/presentation/main_screen.dart';

import '/presentation/home/home.dart';
import '/presentation/login/login_screen.dart';
import '/utils/deep_linking/utm_param_parser.dart';
import '/domain/analytics/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Routes {
  Routes._();

  // route constants -----------------------------------------------------------
  static const String login = '/login';
  static const String home = '/home';

  // route generator -----------------------------------------------------------
  /// Generates routes with integrated UTM parameter parsing and analytics tracking.
  ///
  /// This method:
  /// 1. Extracts the route name from settings
  /// 2. Parses any UTM parameters from the route path
  /// 3. Tracks screen view with analytics
  /// 4. Returns the appropriate widget
  ///
  /// Example routes:
  /// - '/home' (no UTM params)
  /// - '/home?utm_source=google&utm_campaign=promo' (with UTM params)
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Extract route name (without query parameters)
    final routePath = settings.name ?? '';
    final screenName = _extractRouteName(routePath);

    // Parse UTM parameters if present
    final utmData = UTMParamParser.parseRoutePath(routePath);

    // Track screen view with analytics asynchronously
    _trackScreenView(screenName, utmData);

    // Generate the appropriate route
    switch (screenName) {
      case login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MainScreen(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for $screenName')),
          ),
        );
    }
  }

  /// Extracts the route name from a full route path (removes query parameters).
  ///
  /// Example:
  /// - '/home?utm_source=google' → '/home'
  /// - '/login' → '/login'
  static String _extractRouteName(String routePath) {
    if (routePath.contains('?')) {
      return routePath.split('?')[0];
    }
    return routePath;
  }

  /// Tracks a screen view with UTM parameters via analytics service.
  ///
  /// This method is called asynchronously to avoid blocking navigation.
  /// If analytics service is not available, the error is silently ignored
  /// to ensure navigation continues regardless of analytics availability.
  static void _trackScreenView(String screenName, UTMData utmData) {
    // Run analytics tracking asynchronously (non-blocking)
    Future.microtask(() async {
      try {
        final getIt = GetIt.instance;
        final analyticsService = getIt<AnalyticsService>();

        // Track screen view with UTM parameters if available
        if (utmData.hasAnyParams) {
          await analyticsService.trackScreenView(
            screenName,
            screenClass: 'Screen',
            utmParams: utmData.toMap(),
          );
          debugPrint(
            '[Routes] Screen view tracked: $screenName with UTM params: ${utmData.toMap()}',
          );
        } else {
          await analyticsService.trackScreenView(
            screenName,
            screenClass: 'Screen',
          );
          debugPrint('[Routes] Screen view tracked: $screenName');
        }
      } catch (e) {
        debugPrint('[Routes] Failed to track screen view: $e');
        // Silently fail - don't block navigation if analytics fails
      }
    });
  }
}
