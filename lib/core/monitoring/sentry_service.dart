import 'package:sentry_flutter/sentry_flutter.dart';

import '../../domain/entity/auth/user.dart';

/// Centralizes Sentry user context, breadcrumbs, and manual error capture.
class SentryService {
  SentryService._();

  // ---------------------------------------------------------------------------
  // User context
  // ---------------------------------------------------------------------------

  /// Call after successful login / user fetch.
  static Future<void> setUser(User user, {String? tenantId}) async {
    await Sentry.configureScope((scope) {
      scope.setUser(SentryUser(
        id: user.id,
        email: user.email,
        username: user.username,
        data: {
          if (tenantId != null) 'tenant_id': tenantId,
        },
      ));
    });
  }

  /// Call on logout to clear user context.
  static Future<void> clearUser() async {
    await Sentry.configureScope((scope) => scope.setUser(null));
  }

  // ---------------------------------------------------------------------------
  // Screen tracking
  // ---------------------------------------------------------------------------

  /// Add a breadcrumb when the user navigates to a new screen.
  static Future<void> setCurrentScreen(String screenName) async {
    await Sentry.configureScope((scope) {
      scope.setTag('screen', screenName);
    });
    await addBreadcrumb(
      message: 'Navigated to $screenName',
      category: 'navigation',
      data: {'screen': screenName},
    );
  }

  // ---------------------------------------------------------------------------
  // Breadcrumbs
  // ---------------------------------------------------------------------------

  static Future<void> addBreadcrumb({
    required String message,
    String category = 'app',
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? data,
  }) async {
    await Sentry.addBreadcrumb(Breadcrumb(
      message: message,
      category: category,
      level: level,
      data: data,
    ));
  }

  // ---------------------------------------------------------------------------
  // Error capture
  // ---------------------------------------------------------------------------

  /// Capture a handled exception with optional context.
  static Future<void> captureException(
    Object exception, {
    StackTrace? stackTrace,
    String? screenName,
    Map<String, dynamic>? extras,
  }) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        if (screenName != null) scope.setTag('screen', screenName);
        if (extras != null) {
          extras.forEach((key, value) => scope.setExtra(key, value));
        }
      },
    );
  }

  /// Capture a message (non-exception event).
  static Future<void> captureMessage(
    String message, {
    SentryLevel level = SentryLevel.info,
  }) async {
    await Sentry.captureMessage(message, level: level);
  }
}
