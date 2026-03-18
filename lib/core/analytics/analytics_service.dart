import 'package:firebase_analytics/firebase_analytics.dart';

import 'analytics_event.dart';
import 'analytics_screen.dart';
import 'analytics_user_property.dart';

/// Wrapper around [FirebaseAnalytics] for app-wide event and screen tracking.
/// Use this instead of calling [FirebaseAnalytics.instance] directly so all
/// events go through a single taxonomy (see ANALYTICS.md).
class AnalyticsService {
  AnalyticsService() : _analytics = FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  FirebaseAnalytics get instance => _analytics;

  /// Enable analytics collection (e.g. respect user consent).
  Future<void> setAnalyticsCollectionEnabled(bool enabled) {
    return _analytics.setAnalyticsCollectionEnabled(enabled);
  }

  /// Log a screen view. Call when a major screen is shown.
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) {
    return _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
  }

  /// Log login attempt/success.
  Future<void> logLogin({String? method, bool success = true}) {
    return _analytics.logLogin(loginMethod: method);
  }

  /// Log custom login event with optional parameters (for consistency with taxonomy).
  Future<void> logLoginEvent({String? method, bool success = true}) {
    final params = <String, Object>{
      AnalyticsEvent.paramSuccess: success,
      if (method != null) AnalyticsEvent.paramMethod: method,
    };
    return _analytics.logEvent(
      name: AnalyticsEvent.login,
      parameters: params,
    );
  }

  /// Log ticket created.
  Future<void> logTicketCreated({
    String? ticketId,
    String? channel,
  }) {
    final params = <String, Object>{
      if (ticketId != null) AnalyticsEvent.paramTicketId: ticketId,
      if (channel != null) AnalyticsEvent.paramChannel: channel,
    };
    return _analytics.logEvent(
      name: AnalyticsEvent.ticketCreated,
      parameters: params.isNotEmpty ? params : null,
    );
  }

  /// Log when user used an agent (e.g. chatbot, human handoff).
  Future<void> logAgentUsed({
    String? ticketId,
    String? agentType,
  }) {
    final params = <String, Object>{
      if (ticketId != null) AnalyticsEvent.paramTicketId: ticketId,
      if (agentType != null) AnalyticsEvent.paramAgentType: agentType,
    };
    return _analytics.logEvent(
      name: AnalyticsEvent.agentUsed,
      parameters: params.isNotEmpty ? params : null,
    );
  }

  /// Log logout.
  Future<void> logLogout() {
    return _analytics.logEvent(name: AnalyticsEvent.logout);
  }

  /// Set user properties for segmentation (tenant, role, plan). Call after login.
  Future<void> setUserProperties({
    String? tenantId,
    String? role,
    String? planType,
  }) async {
    if (tenantId != null) {
      await _analytics.setUserProperty(
        name: AnalyticsUserProperty.tenantId,
        value: tenantId,
      );
    }
    if (role != null) {
      await _analytics.setUserProperty(
        name: AnalyticsUserProperty.role,
        value: role,
      );
    }
    if (planType != null) {
      await _analytics.setUserProperty(
        name: AnalyticsUserProperty.planType,
        value: planType,
      );
    }
  }

  /// Clear user properties (e.g. on logout). Sets each to empty string so Firebase stops segmenting.
  Future<void> clearUserProperties() async {
    await _analytics.setUserProperty(name: AnalyticsUserProperty.tenantId, value: null);
    await _analytics.setUserProperty(name: AnalyticsUserProperty.role, value: null);
    await _analytics.setUserProperty(name: AnalyticsUserProperty.planType, value: null);
  }

  /// Convenience: log screen by [AnalyticsScreen] constant.
  Future<void> logScreen(String screenName) {
    return logScreenView(screenName: screenName);
  }
}
