import 'package:event_bus/event_bus.dart';

import '/constants/env.dart';
import '/core/data/network/dio/configs/dio_configs.dart';
import '/core/data/network/dio/dio_client.dart';
import '/core/data/network/dio/interceptors/auth_interceptor.dart';
import '/core/data/network/dio/interceptors/logging_interceptor.dart';
import '/core/data/network/dio/interceptors/refresh_token_interceptor.dart';
import '/core/data/network/dio/interceptors/stack_headers_interceptor.dart';
import '/core/data/network/dio/interceptors/tenant_header_interceptor.dart';
import '/core/events/auth_events.dart';
import '/core/monitoring/sentry/sentry_service.dart';
import '/data/analytics/firebase_analytics_service_impl.dart';

import 'package:ai_helpdesk/data/network/apis/customer/customer_api.dart';
import 'package:ai_helpdesk/data/network/apis/tag/tag_api.dart';
import '/data/network/apis/account/account_api.dart';
import '/data/network/apis/auth/stack_auth_api.dart';
import '/data/network/constants/endpoints.dart';
import '/data/network/interceptors/error_interceptor.dart';
import '/data/network/rest_client.dart';
import '/data/sharedpref/shared_preference_helper.dart';
import '/domain/analytics/analytics_service.dart';
import '/domain/repository/auth/auth_repository.dart';
import '../../../di/service_locator.dart';

class NetworkModule {
  static const String authDioName = 'authApi';
  static const String helpdeskDioName = 'helpdeskApi';

  static Future<void> configureNetworkModuleInjection() async {
    final env = EnvConfig.instance;

    // event bus:---------------------------------------------------------------
    getIt.registerSingleton<EventBus>(EventBus());

    // analytics:---------------------------------------------------------------
    getIt.registerSingleton<AnalyticsService>(
      FirebaseAnalyticsServiceImpl(debugMode: env.enableAnalyticsDebug),
    );

    // error monitoring:--------------------------------------------------------
    getIt.registerSingleton<SentryService>(SentryService());

    // interceptors:------------------------------------------------------------
    getIt.registerSingleton<LoggingInterceptor>(LoggingInterceptor());
    getIt.registerSingleton<ErrorInterceptor>(ErrorInterceptor(getIt()));

    getIt.registerSingleton<StackHeadersInterceptor>(
      StackHeadersInterceptor(
        projectId: env.stackProjectId,
        publishableClientKey: env.stackPublishableClientKey,
      ),
    );
    getIt.registerSingleton<AuthInterceptor>(
      AuthInterceptor(
        accessToken: () async => getIt<SharedPreferenceHelper>().authToken,
      ),
    );
    getIt.registerSingleton<TenantHeaderInterceptor>(
      TenantHeaderInterceptor(
        tenantId: () async => getIt<SharedPreferenceHelper>().tenantId,
      ),
    );
    getIt.registerSingleton<RefreshTokenInterceptor>(
      RefreshTokenInterceptor(
        refresh: () async {
          final result = await getIt<AuthRepository>().refreshAccessToken();
          return result.fold((_) => null, (token) => token);
        },
        onRefreshFailed: () {
          getIt<EventBus>().fire(const AuthUnauthorizedEvent());
        },
        dio: () =>
            getIt<DioClient>(instanceName: helpdeskDioName).dio,
      ),
    );

    // rest client:-------------------------------------------------------------
    getIt.registerSingleton(RestClient());

    // dio clients:-------------------------------------------------------------
    final authDio = DioClient(
      dioConfigs: DioConfigs(
        baseUrl: env.authApiBaseUrl,
        connectionTimeout: Endpoints.connectionTimeout,
        receiveTimeout: Endpoints.receiveTimeout,
      ),
    )..addInterceptors([
        getIt<StackHeadersInterceptor>(),
        getIt<LoggingInterceptor>(),
      ]);

    final helpdeskDio = DioClient(
      dioConfigs: DioConfigs(
        baseUrl: env.helpdeskApiBaseUrl,
        connectionTimeout: Endpoints.connectionTimeout,
        receiveTimeout: Endpoints.receiveTimeout,
      ),
    )..addInterceptors([
        getIt<AuthInterceptor>(),
        getIt<TenantHeaderInterceptor>(),
        getIt<RefreshTokenInterceptor>(),
        getIt<ErrorInterceptor>(),
        getIt<LoggingInterceptor>(),
      ]);

    getIt.registerSingleton<DioClient>(authDio, instanceName: authDioName);
    getIt.registerSingleton<DioClient>(
      helpdeskDio,
      instanceName: helpdeskDioName,
    );
    // Backwards-compatible default so existing APIs (OmnichannelApi, PostApi)
    // keep working without per-call instanceName lookups.
    getIt.registerSingleton<DioClient>(helpdeskDio);

    // network APIs:------------------------------------------------------------
    getIt.registerSingleton<StackAuthApi>(
      StackAuthApi(getIt<DioClient>(instanceName: authDioName)),
    );
    getIt.registerSingleton<CustomerApi>(CustomerApi(getIt<DioClient>()));
    getIt.registerSingleton<TagApi>(TagApi(getIt<DioClient>()));
    getIt.registerSingleton<AccountApi>(
      AccountApi(getIt<DioClient>(instanceName: helpdeskDioName)),
    );
  }
}
