import 'package:ai_helpdesk/core/di/module/analytics_module.dart';

class CoreLayerInjection {
  static Future<void> configureCoreLayerInjection() async {
    await AnalyticsModule.configureAnalyticsModuleInjection();
  }
}
