import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../domain/analytics/analytics_service.dart';

/// A [RouteObserver] that automatically tracks screen views via [AnalyticsService].
///
/// Add this to [MaterialApp.navigatorObservers] to get automatic screen
/// tracking on every push/pop/replace navigation event.
class AnalyticsRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _trackScreenView(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _trackScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _trackScreenView(previousRoute);
    }
  }

  void _trackScreenView(Route<dynamic> route) {
    final screenName = route.settings.name;
    if (screenName == null || screenName.isEmpty) return;

    try {
      final analyticsService = GetIt.instance<AnalyticsService>();
      analyticsService.trackScreenView(
        screenName,
        screenClass: route.settings.name,
      );
    } catch (e) {
      debugPrint('[AnalyticsRouteObserver] Failed to track screen: $e');
    }
  }
}
