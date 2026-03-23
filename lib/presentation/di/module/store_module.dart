import 'dart:async';

import 'package:ai_helpdesk/core/stores/error/error_store.dart';
import 'package:ai_helpdesk/domain/repository/invitation/invitation_repository.dart';
import 'package:ai_helpdesk/domain/repository/setting/setting_repository.dart';
import 'package:ai_helpdesk/domain/repository/team/team_repository.dart';
import 'package:ai_helpdesk/domain/repository/tenant/tenant_repository.dart';
import 'package:ai_helpdesk/presentation/home/store/language/language_store.dart';
import 'package:ai_helpdesk/presentation/home/store/theme/theme_store.dart';
import 'package:ai_helpdesk/presentation/team/store/team_store.dart';
import 'package:ai_helpdesk/presentation/tenant/store/tenant_store.dart';

import '../../../di/service_locator.dart';

class StoreModule {
  static Future<void> configureStoreModuleInjection() async {
    // factories:---------------------------------------------------------------
    getIt.registerFactory(() => ErrorStore());

    // stores:------------------------------------------------------------------
    getIt.registerSingleton<ThemeStore>(
      ThemeStore(
        getIt<SettingRepository>(),
        getIt<ErrorStore>(),
      ),
    );

    getIt.registerSingleton<LanguageStore>(
      LanguageStore(
        getIt<SettingRepository>(),
        getIt<ErrorStore>(),
      ),
    );

    getIt.registerSingleton<TenantStore>(
      TenantStore(
        getIt<TenantRepository>(),
        getIt<ErrorStore>(),
      ),
    );

    getIt.registerSingleton<TeamStore>(
      TeamStore(
        getIt<TeamRepository>(),
        getIt<InvitationRepository>(),
        getIt<TenantStore>(),
        getIt<ErrorStore>(),
      ),
    );
  }
}
