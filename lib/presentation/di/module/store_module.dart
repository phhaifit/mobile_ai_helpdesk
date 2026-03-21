import 'dart:async';

import 'package:ai_helpdesk/core/stores/error/error_store.dart';
import 'package:ai_helpdesk/domain/repository/setting/setting_repository.dart';
import 'package:ai_helpdesk/presentation/home/store/language/language_store.dart';
import 'package:ai_helpdesk/presentation/home/store/theme/theme_store.dart';
import 'package:ai_helpdesk/presentation/stores/session_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/create_ticket_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_tab_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_column_visibility_store.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/assign_agent_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/create_ticket_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_tickets_usecase.dart';

import '../../../di/service_locator.dart';

class StoreModule {
  static Future<void> configureStoreModuleInjection() async {
    // factories:---------------------------------------------------------------
    getIt.registerFactory(() => ErrorStore());
    getIt.registerFactory(
      () => TicketTabStore(
        getIt<SessionStore>(),
        getIt<GetTicketsUseCase>(),
        getIt<AssignAgentUseCase>(),
      ),
    );
    getIt.registerFactory(
      () => CreateTicketStore(
        getIt<CreateTicketUseCase>(),
        getIt<SessionStore>(),
      ),
    );

    // singletons:--------------------------------------------------------------
    getIt.registerSingleton<TicketColumnVisibilityStore>(
      TicketColumnVisibilityStore(),
    );

    getIt.registerSingleton<SessionStore>(
      SessionStore(),
    );

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
  }
}
