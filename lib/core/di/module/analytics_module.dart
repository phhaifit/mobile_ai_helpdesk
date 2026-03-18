import 'package:ai_helpdesk/core/analytics/analytics_service.dart';

import '../../../di/service_locator.dart';

class AnalyticsModule {
  static Future<void> configureAnalyticsModuleInjection() async {
    getIt.registerSingleton<AnalyticsService>(AnalyticsService());
  }
}
