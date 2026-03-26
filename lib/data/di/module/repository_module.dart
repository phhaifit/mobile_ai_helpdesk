import 'dart:async';

import 'package:ai_helpdesk/data/repository/setting/setting_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/ticket/mock_ticket_repository_impl.dart';
import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/data/local/auth/auth_local_datasource.dart';
import 'package:ai_helpdesk/data/local/ticket/mock_ticket_local_datasource.dart';
import 'package:ai_helpdesk/data/network/apis/auth/auth_api.dart';
import 'package:ai_helpdesk/data/repository/auth/auth_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/monetization/mock_monetization_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/omnichannel/mock_omnichannel_repository_impl.dart';
import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';
import 'package:ai_helpdesk/domain/repository/monetization/monetization_repository.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';
import 'package:ai_helpdesk/domain/repository/setting/setting_repository.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';
import 'package:get_it/get_it.dart';

// Import Interfaces (Domain)
import '../../../domain/repository/ai_agent/ai_agent_repository.dart';
import '../../../domain/repository/chat/chat_repository.dart';
import '../../../domain/repository/chat/chat_room_repository.dart';
// import '../../../domain/repository/customer_management/customer_repository.dart';
import '../../../domain/repository/playground/playground_repository.dart';
// Import DataSources
import '../../local/datasources/ai_agent/ai_agent_datasource.dart';
import '../../local/datasources/chat/chat_datasource.dart';
import '../../local/datasources/chat/chat_room_datasource.dart';
// import '../../local/datasources/customer_management/customer_datasource.dart';
import '../../local/datasources/playground/playground_datasource.dart';
// Import Implementations (Data)
import '../../repository/ai_agent/mock_ai_agent_repository_impl.dart';
import '../../repository/chat/chat_repository_impl.dart';
import '../../repository/chat/chat_room_repository_impl.dart';
// import '../../repository/customer_management/customer_repository_impl.dart';
import '../../repository/playground/playground_repository_impl.dart';

class RepositoryModule {
  static Future<void> configureRepositoryModuleInjection() async {
    final getIt = GetIt.instance;

    // --- AI Agent Repository ---
    getIt.registerSingleton<AiAgentRepository>(
      MockAiAgentRepositoryImpl(getIt<AiAgentDataSource>()),
    );

    // --- Playground Repository ---
    getIt.registerSingleton<PlaygroundRepository>(
      PlaygroundRepositoryImpl(getIt<PlaygroundDataSource>()),
    );

    // Auth API:----------------------------------------------------------------
    getIt.registerSingleton<AuthApi>(AuthApi());

    // Auth Local Datasource:---------------------------------------------------
    getIt.registerSingleton<AuthLocalDatasource>(
      AuthLocalDatasource(getIt<SharedPreferenceHelper>()),
    );

    // Auth Repository:----------------------------------------------------------
    getIt.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(getIt<AuthApi>(), getIt<AuthLocalDatasource>()),
    );

    // --- Ticket Data Source & Repository ---
    getIt.registerSingleton<MockTicketLocalDataSource>(
      MockTicketLocalDataSource(),
    );

    getIt.registerSingleton<TicketRepository>(
      MockTicketRepositoryImpl(getIt<MockTicketLocalDataSource>()),
    );

    // --- Chat Repositories ---
    getIt.registerSingleton<ChatRepository>(
      ChatRepositoryImpl(getIt<ChatDataSource>()),
    );

    getIt.registerSingleton<OmnichannelRepository>(
      MockOmnichannelRepositoryImpl(),
    );

    getIt.registerSingleton<ChatRoomRepository>(
      ChatRoomRepositoryImpl(getIt<ChatRoomDataSource>()),
    );
    // Ticket repository already registered above with its datasource.

    // --- Monetization Repository ---

    // --- Setting Repository ---
    getIt.registerLazySingleton<SettingRepository>(
      () => SettingRepositoryImpl(getIt<SharedPreferenceHelper>()),
    );

    getIt.registerSingleton<MonetizationRepository>(
      MockMonetizationRepositoryImpl(),
    );
  }
}
