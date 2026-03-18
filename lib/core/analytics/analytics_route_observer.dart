import 'package:ai_helpdesk/core/analytics/analytics_screen.dart';
import 'package:ai_helpdesk/core/analytics/analytics_service.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';

/// NavigatorObserver that logs a screen_view to Firebase Analytics when a route is pushed.
class AnalyticsRouteObserver extends NavigatorObserver {
  static String _screenNameFromRoute(String? routeName) {
    if (routeName == null || routeName.isEmpty) return 'unknown';
    switch (routeName) {
      case Routes.login:
        return AnalyticsScreen.login;
      case Routes.home:
        return AnalyticsScreen.home;
      default:
        return routeName;
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final name = route.settings.name;
    final screenName = _screenNameFromRoute(name);
    getIt<AnalyticsService>().logScreen(screenName);
  }
}
