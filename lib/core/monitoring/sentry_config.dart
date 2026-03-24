import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryConfig {
  SentryConfig._();

  static const _dsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: 'https://0a778f968deafdce72474b24e0760a84@o4511054553612288.ingest.de.sentry.io/4511091859652688',
  );

  static Future<void> init(AppRunner appRunner) async {
    await SentryFlutter.init(
      (options) {
        options.dsn = _dsn;
        options.environment = kDebugMode ? 'dev' : 'prod';
        options.tracesSampleRate = 1.0;
        options.enableAutoSessionTracking = true;
        options.attachScreenshot = true;
        options.enableAutoNativeBreadcrumbs = true;
        options.debug = kDebugMode;
      },
      appRunner: appRunner,
    );
  }
}
