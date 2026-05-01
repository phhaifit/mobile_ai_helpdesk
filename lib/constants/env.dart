import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application environment configuration.
///
/// Usage:
///   flutter run --dart-define=ENV=dev        (default)
///   flutter run --dart-define=ENV=staging
///   flutter run --dart-define=ENV=prod
///
/// Environment variables can be overridden via:
/// 1. .env file in project root (loaded automatically at startup)
/// 2. --dart-define CLI flag
/// 3. Hardcoded defaults in EnvConfig enum
enum Environment { dev, staging, prod }

enum EnvConfig {
  dev._(
    environment: Environment.dev,
    authApiBaseUrl: 'https://auth-api.jarvis.cx',
    helpdeskApiBaseUrl: 'https://helpdesk-api.jarvis.cx',
    otpCallbackUrl: 'https://helpdesk.jarvis.cx/callback',
    stackProjectId: '45a1e2fd-77ee-4872-9fb7-987b8c119633',
    stackPublishableClientKey: 'pck_zdfc9dt5w3ed0kje1xwpmdwt8zjehr15ap3nvnkgnbfcr',
    receiveTimeout: 15000,
    connectionTimeout: 30000,
    enableLogging: true,
    enableAnalytics: true,
    enableAnalyticsDebug: true,
    enableRealOmnichannel: false,
  ),
  staging._(
    environment: Environment.staging,
    authApiBaseUrl: 'https://auth-api.jarvis.cx',
    helpdeskApiBaseUrl: 'https://helpdesk-api.jarvis.cx',
    otpCallbackUrl: 'https://helpdesk.jarvis.cx/callback',
    stackProjectId: '45a1e2fd-77ee-4872-9fb7-987b8c119633',
    stackPublishableClientKey: 'pck_zdfc9dt5w3ed0kje1xwpmdwt8zjehr15ap3nvnkgnbfcr',
    receiveTimeout: 15000,
    connectionTimeout: 30000,
    enableLogging: true,
    enableAnalytics: true,
    enableAnalyticsDebug: false,
    enableRealOmnichannel: true,
  ),
  prod._(
    environment: Environment.prod,
    authApiBaseUrl: 'https://auth-api.jarvis.cx',
    helpdeskApiBaseUrl: 'https://helpdesk-api.jarvis.cx',
    otpCallbackUrl: 'https://helpdesk.jarvis.cx/callback',
    stackProjectId: '45a1e2fd-77ee-4872-9fb7-987b8c119633',
    stackPublishableClientKey: 'pck_zdfc9dt5w3ed0kje1xwpmdwt8zjehr15ap3nvnkgnbfcr',
    receiveTimeout: 15000,
    connectionTimeout: 30000,
    enableLogging: false,
    enableAnalytics: true,
    enableAnalyticsDebug: false,
    enableRealOmnichannel: true,
  );

  final Environment environment;
  final String authApiBaseUrl;
  final String helpdeskApiBaseUrl;
  final String otpCallbackUrl;
  final String stackProjectId;
  final String stackPublishableClientKey;
  final int receiveTimeout;
  final int connectionTimeout;
  final bool enableLogging;
  final bool enableAnalytics;
  final bool enableAnalyticsDebug;
  final bool enableRealOmnichannel;

  const EnvConfig._({
    required this.environment,
    required this.authApiBaseUrl,
    required this.helpdeskApiBaseUrl,
    required this.otpCallbackUrl,
    required this.stackProjectId,
    required this.stackPublishableClientKey,
    required this.receiveTimeout,
    required this.connectionTimeout,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.enableAnalyticsDebug,
    required this.enableRealOmnichannel,
  });

  /// Backwards-compatible alias pointing at the Helpdesk host so legacy code
  /// (OmnichannelApi, PostApi) keeps working while we migrate.
  String get baseUrl => helpdeskApiBaseUrl;

  static const _envName = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const _useRealOmnichannelFromDefine = bool.fromEnvironment(
    'USE_REAL_OMNICHANNEL',
    defaultValue: false,
  );
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

  /// Get the resolved base URL from .env → --dart-define → hardcoded default
  /// Priority: .env > dart-define > hardcoded defaults in enum
  static String getResolvedBaseUrl() {
    String envKey = '';
    switch (instance.environment) {
      case Environment.prod:
        envKey = 'BASE_URL_PROD';
        break;
      case Environment.staging:
        envKey = 'BASE_URL_STAGING';
        break;
      case Environment.dev:
        envKey = 'BASE_URL_DEV';
        break;
    }

    // Priority 1: .env file
    final fromDotEnv = dotenv.env[envKey];
    if (fromDotEnv != null && fromDotEnv.isNotEmpty) {
      return fromDotEnv;
    }

    // Priority 2: --dart-define CLI
    final fromDartDefine = String.fromEnvironment(envKey, defaultValue: '');
    if (fromDartDefine.isNotEmpty) {
      return fromDartDefine;
    }

    // Priority 3: Hardcoded default
    return instance.baseUrl;
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

  // The dart-define flag can force-enable real omnichannel integration.
  bool get useRealOmnichannel =>
      _useRealOmnichannelFromDefine || enableRealOmnichannel;
}
