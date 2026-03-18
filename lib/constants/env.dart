/// Application environment configuration.
///
/// Usage:
///   flutter run --dart-define=ENV=dev        (default)
///   flutter run --dart-define=ENV=staging
///   flutter run --dart-define=ENV=prod
enum Environment { dev, staging, prod }

class EnvConfig {
  final Environment environment;
  final String baseUrl;
  final int receiveTimeout;
  final int connectionTimeout;
  final bool enableLogging;

  const EnvConfig._({
    required this.environment,
    required this.baseUrl,
    required this.receiveTimeout,
    required this.connectionTimeout,
    required this.enableLogging,
  });

  static const _envName = String.fromEnvironment('ENV', defaultValue: 'dev');

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

  static const EnvConfig dev = EnvConfig._(
    environment: Environment.dev,
    baseUrl: 'https://dev-api.jarvis-helpdesk.com',
    receiveTimeout: 15000,
    connectionTimeout: 30000,
    enableLogging: true,
  );

  static const EnvConfig staging = EnvConfig._(
    environment: Environment.staging,
    baseUrl: 'https://staging-api.jarvis-helpdesk.com',
    receiveTimeout: 15000,
    connectionTimeout: 30000,
    enableLogging: true,
  );

  static const EnvConfig prod = EnvConfig._(
    environment: Environment.prod,
    baseUrl: 'https://api.jarvis-helpdesk.com',
    receiveTimeout: 15000,
    connectionTimeout: 30000,
    enableLogging: false,
  );

  bool get isDev => environment == Environment.dev;
  bool get isStaging => environment == Environment.staging;
  bool get isProd => environment == Environment.prod;
}
