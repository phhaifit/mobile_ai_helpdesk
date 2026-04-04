import 'package:event_bus/event_bus.dart';

import '/constants/env.dart';
import '/core/monitoring/sentry/sentry_service.dart';
import '/core/data/network/dio/configs/dio_configs.dart';
import '/core/data/network/dio/dio_client.dart';
import '/core/data/network/dio/interceptors/auth_interceptor.dart';
import '/core/data/network/dio/interceptors/logging_interceptor.dart';
import '/data/analytics/firebase_analytics_service_impl.dart';
import '/data/network/constants/endpoints.dart';
import '/data/network/interceptors/error_interceptor.dart';
import '/data/network/rest_client.dart';
import '/data/sharedpref/shared_preference_helper.dart';
import '/domain/analytics/analytics_service.dart';
import '../../../di/service_locator.dart';

class NetworkModule {
  static Future<void> configureNetworkModuleInjection() async {
    // event bus:---------------------------------------------------------------
    getIt.registerSingleton<EventBus>(EventBus());

    // analytics:---------------------------------------------------------------
    getIt.registerSingleton<AnalyticsService>(
      FirebaseAnalyticsServiceImpl(
        debugMode: EnvConfig.instance.enableAnalyticsDebug,
      ),
    );

    // error monitoring:--------------------------------------------------------
    getIt.registerSingleton<SentryService>(SentryService());

    // interceptors:------------------------------------------------------------
    getIt.registerSingleton<LoggingInterceptor>(LoggingInterceptor());
    getIt.registerSingleton<ErrorInterceptor>(ErrorInterceptor(getIt()));
    getIt.registerSingleton<AuthInterceptor>(
      AuthInterceptor(
        accessToken: () async =>
            await getIt<SharedPreferenceHelper>().authToken,
      ),
    );

    // rest client:-------------------------------------------------------------
    getIt.registerSingleton(RestClient());

    // dio:---------------------------------------------------------------------
    getIt.registerSingleton<DioConfigs>(
      DioConfigs(
        baseUrl: Endpoints.baseUrl,
        connectionTimeout: Endpoints.connectionTimeout,
        receiveTimeout: Endpoints.receiveTimeout,
      ),
    );
    getIt.registerSingleton<DioClient>(
      DioClient(dioConfigs: getIt())..addInterceptors([
        getIt<AuthInterceptor>(),
        getIt<ErrorInterceptor>(),
        getIt<LoggingInterceptor>(),
      ]),
    );
  }
}
