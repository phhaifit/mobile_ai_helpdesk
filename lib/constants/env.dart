/// Application environment configuration.
///
/// Usage:
///   flutter run --dart-define=ENV=dev        (default)
///   flutter run --dart-define=ENV=staging
///   flutter run --dart-define=ENV=prod
enum Environment { dev, staging, prod }

enum EnvConfig {
  dev._(
    environment: Environment.dev,
    baseUrl: 'https://mock.apidog.com/m1/1256275-1253679-default',
    receiveTimeout: 15000,
    connectionTimeout: 30000,
    enableLogging: true,
    enableAnalytics: true,
    enableAnalyticsDebug: true,
  ),
  staging._(
    environment: Environment.staging,
    baseUrl: 'https://staging-api.jarvis-helpdesk.com',
    receiveTimeout: 15000,
    connectionTimeout: 30000,
    enableLogging: true,
    enableAnalytics: true,
    enableAnalyticsDebug: false,
  ),
  prod._(
    environment: Environment.prod,
    baseUrl: 'https://api.jarvis-helpdesk.com',
    receiveTimeout: 15000,
    connectionTimeout: 30000,
    enableLogging: false,
    enableAnalytics: true,
    enableAnalyticsDebug: false,
  );

  final Environment environment;
  final String baseUrl;
  final int receiveTimeout;
  final int connectionTimeout;
  final bool enableLogging;
  final bool enableAnalytics;
  final bool enableAnalyticsDebug;

  const EnvConfig._({
    required this.environment,
    required this.baseUrl,
    required this.receiveTimeout,
    required this.connectionTimeout,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.enableAnalyticsDebug,
  });

  static const _envName = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const _sentryDsnDev = String.fromEnvironment(
    'SENTRY_DSN_DEV',
    defaultValue: '',
  );
  static const _sentryDsnProd = String.fromEnvironment(
    'SENTRY_DSN_PROD',
    defaultValue: '',
  );

  static final EnvConfig instance = _fromName(_envName);

  static EnvConfig _fromName(String name) {
    switch (name) {
      case 'prod':
        return EnvConfig.prod;
      case 'staging':
        return EnvConfig.staging;
      case 'dev':
      default:
        return EnvConfig.dev;
    }
  }

  bool get isDev => environment == Environment.dev;
  bool get isStaging => environment == Environment.staging;
  bool get isProd => environment == Environment.prod;

  String get sentryDsn {
    switch (environment) {
      case Environment.prod:
        return _sentryDsnProd;
      case Environment.staging:
      case Environment.dev:
        return _sentryDsnDev;
    }
  }

  String get sentryEnvironment {
    switch (environment) {
      case Environment.prod:
        return 'production';
      case Environment.staging:
        return 'staging';
      case Environment.dev:
        return 'development';
    }
  }

  bool get isSentryEnabled => sentryDsn.isNotEmpty;
}
