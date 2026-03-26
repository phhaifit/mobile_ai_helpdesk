import 'dart:async';

import 'package:ai_helpdesk/core/stores/error/error_store.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';
// import 'package:ai_helpdesk/domain/repository/customer_management/customer_repository.dart';
import 'package:ai_helpdesk/domain/repository/prompt/prompt_repository.dart';
import 'package:ai_helpdesk/domain/repository/setting/setting_repository.dart';
import 'package:ai_helpdesk/domain/usecase/auth/change_password_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/get_current_user_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/login_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/logout_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/register_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/reset_password_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/monetization/get_monetization_overview_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/monetization/simulate_upgrade_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/connect_messenger_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/connect_zalo_from_qr_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/disconnect_messenger_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/disconnect_zalo_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/get_omnichannel_overview_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/retry_zalo_sync_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/sync_messenger_data_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/update_messenger_settings_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/update_zalo_assignments_usecase.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:ai_helpdesk/presentation/chat/store/chat_room_store.dart';
import 'package:ai_helpdesk/presentation/chat/store/chat_store.dart';
// import 'package:ai_helpdesk/presentation/customer_management/store/customer_store.dart';
import 'package:ai_helpdesk/presentation/home/store/language/language_store.dart';
import 'package:ai_helpdesk/presentation/home/store/theme/theme_store.dart';
import 'package:ai_helpdesk/presentation/monetization/store/monetization_store.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:ai_helpdesk/presentation/prompt/store/prompt_store.dart';
import 'package:get_it/get_it.dart';
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
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:ai_helpdesk/presentation/chat/store/chat_room_store.dart';
import 'package:ai_helpdesk/presentation/chat/store/chat_store.dart';
import 'package:ai_helpdesk/presentation/home/store/language/language_store.dart';
import 'package:ai_helpdesk/presentation/home/store/theme/theme_store.dart';
import 'package:ai_helpdesk/presentation/monetization/store/monetization_store.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:ai_helpdesk/presentation/stores/session_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/create_ticket_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/customer_history_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/edit_ticket_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_detail_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_tab_store.dart';
import 'package:get_it/get_it.dart';

import '../../ai_agent/store/ai_agent_store.dart';
import '../../chat/store/chat_store.dart';
import '../../chat/store/chat_room_store.dart';
// import '../../customer_management/store/customer_store.dart';
import '../../playground/store/playground_store.dart';

import '../../../domain/repository/chat/chat_repository.dart';
import '../../../domain/repository/chat/chat_room_repository.dart';
// import '../../../domain/repository/customer_management/customer_repository.dart';
import '../../../domain/usecase/ai_agent/create_agent_usecase.dart';
import '../../../domain/usecase/ai_agent/delete_agent_usecase.dart';
import '../../../domain/usecase/ai_agent/get_agent_usecase.dart';
import '../../../domain/usecase/ai_agent/get_agents_usecase.dart';
import '../../../domain/usecase/ai_agent/update_agent_usecase.dart';
import '../../../domain/usecase/playground/create_session_usecase.dart';
import '../../../domain/usecase/playground/get_sessions_usecase.dart';
import '../../../domain/usecase/playground/send_playground_message_usecase.dart';
import '../../../di/service_locator.dart';
import '../../../domain/analytics/analytics_service.dart';
import '../../login/store/login_store.dart';

class StoreModule {
  static Future<void> configureStoreModuleInjection() async {
    final getIt = GetIt.instance;

    // factories:---------------------------------------------------------------
    getIt.registerFactory(() => ErrorStore());

    // --- Login Store ---
    // getIt.registerFactory<LoginStore>(
    //   () => LoginStore(analyticsService: getIt<AnalyticsService>()),
    // );

    // --- Auth Store ---
    getIt.registerFactory<AuthStore>(
      () => AuthStore(
        getIt<LoginUseCase>(),
        getIt<RegisterUseCase>(),
        getIt<LogoutUseCase>(),
        getIt<GetCurrentUserUseCase>(),
        getIt<ChangePasswordUseCase>(),
        getIt<ResetPasswordUseCase>(),
      ),
    );

    // --- Ticket Stores ---
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
      () =>
          EditTicketStore(getIt<UpdateTicketUseCase>(), getIt<SessionStore>()),
    );
    getIt.registerFactory(
      () => CustomerHistoryStore(getIt<GetCustomerHistoryUseCase>()),
    );

    // --- Chat Stores ---
    getIt.registerSingleton<ChatStore>(ChatStore(getIt<ChatRepository>()));
    getIt.registerSingleton<ChatRoomStore>(
      ChatRoomStore(getIt<ChatRoomRepository>()),
    );

    // --- Theme & Language ---
    getIt.registerSingleton<ThemeStore>(
      ThemeStore(getIt<SettingRepository>(), getIt<ErrorStore>()),
    );
    getIt.registerSingleton<LanguageStore>(
      LanguageStore(getIt<SettingRepository>(), getIt<ErrorStore>()),
    );

    // --- Omnichannel Store ---
    getIt.registerFactory<OmnichannelStore>(
      () => OmnichannelStore(
        getIt<GetOmnichannelOverviewUseCase>(),
        getIt<ConnectMessengerUseCase>(),
        getIt<DisconnectMessengerUseCase>(),
        getIt<SyncMessengerDataUseCase>(),
        getIt<UpdateMessengerSettingsUseCase>(),
        getIt<ConnectZaloFromQrUseCase>(),
        getIt<DisconnectZaloUseCase>(),
        getIt<RetryZaloSyncUseCase>(),
        getIt<UpdateZaloAssignmentsUseCase>(),
      ),
    );

    getIt.registerFactory(
      () => MonetizationStore(
        getIt<GetMonetizationOverviewUseCase>(),
        getIt<SimulateUpgradeUseCase>(),
      ),
    );

    // --- AI Agent Store ---
    getIt.registerLazySingleton<AiAgentStore>(
      () => AiAgentStore(
        getIt<GetAgentsUseCase>(),
        getIt<GetAgentUseCase>(),
        getIt<CreateAgentUseCase>(),
        getIt<UpdateAgentUseCase>(),
        getIt<DeleteAgentUseCase>(),
        getIt<ErrorStore>(),
      ),
    );

    // --- Playground Store ---
    getIt.registerLazySingleton<PlaygroundStore>(
      () => PlaygroundStore(
        getIt<GetSessionsUseCase>(),
        getIt<CreateSessionUseCase>(),
        getIt<SendPlaygroundMessageUseCase>(),
        getIt<ErrorStore>(),
      ),
    );
    getIt.registerLazySingleton<PromptStore>(
      () => PromptStore(getIt<PromptRepository>()),
    );
  }
}
