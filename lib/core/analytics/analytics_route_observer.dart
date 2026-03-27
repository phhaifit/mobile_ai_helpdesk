import 'dart:async';

import 'package:ai_helpdesk/core/analytics/analytics_screen.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';

/// NavigatorObserver that logs a screen_view to Firebase Analytics when routes
/// change (push or replace — e.g. login → home uses [didReplace]).
class AnalyticsRouteObserver extends NavigatorObserver {
  static String _screenNameFromRoute(String? routeName) {
    if (routeName == null || routeName.isEmpty) return 'unknown';
    switch (routeName) {
      case Routes.login:
        return AnalyticsScreen.login;
      case Routes.register:
        return AnalyticsScreen.register;
      case Routes.forgotPassword:
        return AnalyticsScreen.forgotPassword;
      case Routes.resetPassword:
        return AnalyticsScreen.resetPassword;
      case Routes.home:
        return AnalyticsScreen.home;
      case Routes.profile:
        return AnalyticsScreen.profile;
      case Routes.changePassword:
        return AnalyticsScreen.changePassword;
      case Routes.omnichannelHub:
        return AnalyticsScreen.omnichannelHub;
      case Routes.messengerDashboard:
        return AnalyticsScreen.messengerDashboard;
      case Routes.messengerOauthStatus:
        return AnalyticsScreen.messengerOauthStatus;
      case Routes.messengerCustomerSync:
        return AnalyticsScreen.messengerCustomerSync;
      case Routes.messengerSettings:
        return AnalyticsScreen.messengerSettings;
      case Routes.zaloOverview:
        return AnalyticsScreen.zaloOverview;
      case Routes.zaloConnectQr:
        return AnalyticsScreen.zaloConnectQr;
      case Routes.zaloOauthManagement:
        return AnalyticsScreen.zaloOauthManagement;
      case Routes.zaloSyncStatus:
        return AnalyticsScreen.zaloSyncStatus;
      case Routes.zaloAccountAssignment:
        return AnalyticsScreen.zaloAccountAssignment;
      case Routes.zaloPersonalMessage:
        return AnalyticsScreen.zaloPersonalMessage;
      case Routes.monetization:
        return AnalyticsScreen.monetization;
      case Routes.upgradePayment:
        return AnalyticsScreen.upgradePayment;
      case Routes.upgradeConfirmation:
        return AnalyticsScreen.upgradeConfirmation;
      default:
        return routeName;
    }
  }

  void _logRoute(Route<dynamic>? route) {
    if (route == null) return;
    final name = route.settings.name;
    final screenName = _screenNameFromRoute(name);
    unawaited(
      getIt<AnalyticsService>().trackScreenView(
        screenName,
        screenClass: screenName,
      ),
    );
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logRoute(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logRoute(newRoute);
  }
}
