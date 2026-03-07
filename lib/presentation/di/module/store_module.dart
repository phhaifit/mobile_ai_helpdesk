import 'dart:async';

class StoreModule {
  static Future<void> configureStoreModuleInjection() async {
    // factories:---------------------------------------------------------------
    // Register error store and other factories here.
    // Example:
    // getIt.registerFactory(() => ErrorStore());

    // stores:------------------------------------------------------------------
    // Register MobX stores here as features are added.
    // Example:
    // getIt.registerFactory(() => FeatureStore(getIt<GetFeatureUseCase>()));
  }
}
