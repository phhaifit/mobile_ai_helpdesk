import '/presentation/di/module/store_module.dart';

class PresentationLayerInjection {
  static Future<void> configurePresentationLayerInjection() async {
    // Gọi StoreModule để đăng ký các MobX Store
    await StoreModule.configureStoreModuleInjection();
  }
}
