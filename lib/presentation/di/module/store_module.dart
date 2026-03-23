import 'dart:async';

import 'package:ai_helpdesk/core/stores/error/error_store.dart';
import 'package:ai_helpdesk/domain/repository/setting/setting_repository.dart';
import 'package:ai_helpdesk/presentation/home/store/language/language_store.dart';
import 'package:ai_helpdesk/presentation/home/store/theme/theme_store.dart';
import 'package:ai_helpdesk/presentation/stores/session_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/create_ticket_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_tab_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_detail_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/edit_ticket_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/customer_history_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_column_visibility_store.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/add_comment_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/assign_agent_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/create_ticket_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/delete_ticket_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_available_agents_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_comments_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_customer_history_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_ticket_by_id_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_ticket_history_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_tickets_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/update_ticket_status_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/update_ticket_usecase.dart';

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
    getIt.registerFactory(
      () => TicketDetailStore(
        getIt<GetTicketByIdUseCase>(),
        getIt<UpdateTicketUseCase>(),
        getIt<UpdateTicketStatusUseCase>(),
        getIt<AssignAgentUseCase>(),
        getIt<GetAvailableAgentsUseCase>(),
        getIt<DeleteTicketUseCase>(),
        getIt<GetCommentsUseCase>(),
        getIt<AddCommentUseCase>(),
        getIt<GetTicketHistoryUseCase>(),
        getIt<SessionStore>(),
      ),
    );
    getIt.registerFactory(
      () => EditTicketStore(
        getIt<UpdateTicketUseCase>(),
        getIt<SessionStore>(),
      ),
    );
    getIt.registerFactory(
      () => CustomerHistoryStore(
        getIt<GetCustomerHistoryUseCase>(),
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
