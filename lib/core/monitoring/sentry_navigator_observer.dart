import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'sentry_service.dart';

/// Wraps [SentryNavigatorObserver] and additionally updates the Sentry scope
/// tag so every event carries the current screen name.
class AppSentryNavigatorObserver extends RouteObserver<PageRoute<dynamic>> {
  final SentryNavigatorObserver _sentryObserver = SentryNavigatorObserver();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _sentryObserver.didPush(route, previousRoute);
    _trackRoute(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _sentryObserver.didPop(route, previousRoute);
    if (previousRoute != null) _trackRoute(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _sentryObserver.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _trackRoute(newRoute);
  }

  void _trackRoute(Route<dynamic> route) {
    final name = route.settings.name ?? route.runtimeType.toString();
    SentryService.setCurrentScreen(name);
  }
}
