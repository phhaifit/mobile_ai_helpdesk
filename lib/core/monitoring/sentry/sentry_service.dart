import 'package:sentry_flutter/sentry_flutter.dart';

class SentryService {
  static const String defaultTenantId = 'default_tenant';

  Future<void> setEnvironmentContext(String environment) async {
    await Sentry.configureScope((scope) {
      scope.setTag('app_environment', environment);
    });
  }

  Future<void> setCurrentScreen(String screenName) async {
    await Sentry.configureScope((scope) {
      scope.setTag('screen_name', screenName);
      scope.setContexts('ui', {'screen_name': screenName});
    });
  }

  Future<void> setUserContext({
    required String userId,
    String? email,
    String tenantId = defaultTenantId,
  }) async {
    await Sentry.configureScope((scope) {
      scope.setUser(
        SentryUser(id: userId, email: email, data: {'tenant_id': tenantId}),
      );
      scope.setTag('tenant_id', tenantId);
    });
  }

  Future<void> clearUserContext() async {
    await Sentry.configureScope((scope) {
      scope.setUser(null);
      scope.removeTag('tenant_id');
    });
  }

  Future<void> addBreadcrumb({
    required String message,
    required String category,
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? data,
    String? type,
  }) async {
    final breadcrumb = Breadcrumb(
      message: message,
      category: category,
      level: level,
      data: data,
      type: type,
      timestamp: DateTime.now(),
    );
    await Sentry.addBreadcrumb(breadcrumb);
  }

  Future<SentryId> captureException(
    dynamic exception, {
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? extras,
  }) async {
    return Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        if (context != null && context.isNotEmpty) {
          scope.setTag('error_context', context);
        }
        extras?.forEach(scope.setExtra);
      },
    );
  }

  Future<SentryId> captureTestException() async {
    try {
      throw StateError('Sentry test exception from debug action');
    } catch (error, stackTrace) {
      return captureException(
        error,
        stackTrace: stackTrace,
        context: 'manual_test',
      );
    }
  }
}
