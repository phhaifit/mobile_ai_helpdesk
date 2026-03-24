import 'dart:async';

import 'package:ai_helpdesk/core/stores/error/error_store.dart';
import 'package:ai_helpdesk/domain/repository/setting/setting_repository.dart';
import 'package:ai_helpdesk/domain/usecase/auth/change_password_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/get_current_user_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/login_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/logout_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/register_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/reset_password_usecase.dart';
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
import 'package:ai_helpdesk/presentation/home/store/language/language_store.dart';
import 'package:ai_helpdesk/presentation/home/store/theme/theme_store.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:ai_helpdesk/domain/usecase/monetization/get_monetization_overview_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/monetization/simulate_upgrade_usecase.dart';
import 'package:ai_helpdesk/presentation/monetization/store/monetization_store.dart';
import 'package:get_it/get_it.dart';

import '../../ai_agent/store/ai_agent_store.dart';
import '../../chat/store/chat_store.dart';
import '../../chat/store/chat_room_store.dart';
import '../../customer_management/store/customer_store.dart';
import '../../playground/store/playground_store.dart';

import '../../../domain/repository/chat/chat_repository.dart';
import '../../../domain/repository/chat/chat_room_repository.dart';
import '../../../domain/repository/customer_management/customer_repository.dart';
import '../../../domain/usecase/ai_agent/create_agent_usecase.dart';
import '../../../domain/usecase/ai_agent/delete_agent_usecase.dart';
import '../../../domain/usecase/ai_agent/get_agent_usecase.dart';
import '../../../domain/usecase/ai_agent/get_agents_usecase.dart';
import '../../../domain/usecase/ai_agent/update_agent_usecase.dart';
import '../../../domain/usecase/playground/create_session_usecase.dart';
import '../../../domain/usecase/playground/get_sessions_usecase.dart';
import '../../../domain/usecase/playground/send_playground_message_usecase.dart';

class StoreModule {
  static Future<void> configureStoreModuleInjection() async {
    final getIt = GetIt.instance;

    // factories:---------------------------------------------------------------
    getIt.registerFactory(() => ErrorStore());

    // Auth Store:--------------------------------------------------------------
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

    // --- Chat Stores ---
    getIt.registerSingleton<ChatStore>(ChatStore(getIt<ChatRepository>()));

    getIt.registerSingleton<ChatRoomStore>(
      ChatRoomStore(getIt<ChatRoomRepository>()),
    );

    // --- Customer Management Stores ---
    getIt.registerSingleton<CustomerStore>(
      CustomerStore(getIt<CustomerRepository>()),
    );

    // --- Theme & Language Stores ---
    getIt.registerSingleton<ThemeStore>(
      ThemeStore(getIt<SettingRepository>(), getIt<ErrorStore>()),
    );

    getIt.registerSingleton<LanguageStore>(
      LanguageStore(getIt<SettingRepository>(), getIt<ErrorStore>()),
    );

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

    getIt.registerFactory<MonetizationStore>(
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
  }
}
