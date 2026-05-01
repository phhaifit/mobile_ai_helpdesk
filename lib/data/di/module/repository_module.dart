import 'package:ai_helpdesk/constants/env.dart';
import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/local/auth/auth_local_datasource.dart';
import 'package:ai_helpdesk/data/local/datasources/ai_agent/ai_agent_datasource.dart';
import 'package:ai_helpdesk/data/local/datasources/chat/chat_datasource.dart';
import 'package:ai_helpdesk/data/local/datasources/chat/chat_room_datasource.dart';
import 'package:ai_helpdesk/data/network/apis/customer/customer_api.dart';
import 'package:ai_helpdesk/data/network/apis/tag/tag_api.dart';
import 'package:ai_helpdesk/data/local/datasources/tag/mock_tag_datasource.dart';
import 'package:ai_helpdesk/domain/repository/tag/tag_repository.dart';
import 'package:ai_helpdesk/data/repository/tag/tag_repository_impl.dart';
import 'package:ai_helpdesk/data/local/datasources/playground/playground_datasource.dart';
import 'package:ai_helpdesk/data/local/ticket/mock_ticket_local_datasource.dart';
import 'package:ai_helpdesk/data/network/apis/account/account_api.dart';
import 'package:ai_helpdesk/data/network/apis/auth/stack_auth_api.dart';
import 'package:ai_helpdesk/data/network/apis/marketing/marketing_broadcast_api.dart';
import 'package:ai_helpdesk/data/network/apis/omnichannel/omnichannel_api.dart';
import 'package:ai_helpdesk/data/network/realtime/mock_broadcast_realtime_simulator.dart';
import 'package:ai_helpdesk/data/repository/account/account_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/ai_agent/mock_ai_agent_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/auth/auth_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/chat/chat_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/chat/chat_room_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/customer/customer_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/invitation/mock_invitation_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/knowledge/mock_knowledge_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/marketing/marketing_broadcast_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/marketing/marketing_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/marketing/mock_marketing_broadcast_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/marketing/mock_marketing_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/monetization/mock_monetization_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/omnichannel/mock_omnichannel_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/omnichannel/omnichannel_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/playground/playground_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/prompt/mock_prompt_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/setting/setting_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/team/mock_team_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/tenant/mock_tenant_repository_impl.dart';
import 'package:ai_helpdesk/data/repository/ticket/mock_ticket_repository_impl.dart';
import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/domain/repository/account/account_repository.dart';
import 'package:ai_helpdesk/domain/repository/ai_agent/ai_agent_repository.dart';
import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';
import 'package:ai_helpdesk/domain/repository/customer/customer_repository.dart';
import 'package:ai_helpdesk/domain/repository/invitation/invitation_repository.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_repository.dart';
import 'package:ai_helpdesk/domain/repository/monetization/monetization_repository.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';
import 'package:ai_helpdesk/domain/repository/playground/playground_repository.dart';
import 'package:ai_helpdesk/domain/repository/prompt/prompt_repository.dart';
import 'package:ai_helpdesk/domain/repository/setting/setting_repository.dart';
import 'package:ai_helpdesk/domain/repository/team/team_repository.dart';
import 'package:ai_helpdesk/domain/repository/tenant/tenant_repository.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
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

    // --- Auth (Stack Auth OTP flow) ---
    getIt.registerSingleton<AuthLocalDatasource>(
      AuthLocalDatasource(getIt<SharedPreferenceHelper>()),
    );
    getIt.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(
        getIt<StackAuthApi>(),
        getIt<AuthLocalDatasource>(),
        EnvConfig.instance,
      ),
    );

    // --- Account (Helpdesk) ---
    getIt.registerSingleton<AccountRepository>(
      AccountRepositoryImpl(
        getIt<AccountApi>(),
        getIt<AuthLocalDatasource>(),
      ),
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

    // --- Customer Repositories ---
    getIt.registerSingleton<CustomerRepository>(
      CustomerRepositoryImpl(getIt<CustomerApi>(), getIt<TagApi>()),
    );
    
    getIt.registerSingleton<MockTagDataSource>(MockTagDataSource());
    getIt.registerSingleton<TagRepository>(
      TagRepositoryImpl(getIt<TagApi>()),
    );

    getIt.registerSingleton<OmnichannelApi>(OmnichannelApi(getIt<DioClient>()));

    if (EnvConfig.instance.useRealOmnichannel) {
      getIt.registerSingleton<OmnichannelRepository>(
        OmnichannelRepositoryImpl(getIt<OmnichannelApi>()),
      );
    } else {
      getIt.registerSingleton<OmnichannelRepository>(
        MockOmnichannelRepositoryImpl(),
      );
    }

    getIt.registerSingleton<ChatRoomRepository>(
      ChatRoomRepositoryImpl(getIt<ChatRoomDataSource>()),
    );

    // --- Setting Repository ---
    getIt.registerLazySingleton<SettingRepository>(
      () => SettingRepositoryImpl(getIt<SharedPreferenceHelper>()),
    );

    // --- Tenant Repository ---
    getIt.registerSingleton<TenantRepository>(MockTenantRepositoryImpl());

    // --- Team Repository ---
    getIt.registerSingleton<TeamRepository>(MockTeamRepositoryImpl());

    // --- Invitation Repository ---
    getIt.registerSingleton<InvitationRepository>(
      MockInvitationRepositoryImpl(getIt<TeamRepository>()),
    );

    getIt.registerSingleton<MonetizationRepository>(
      MockMonetizationRepositoryImpl(),
    );

    // Toggle to swap between in-memory mocks and real backend impls.
    // Flip to false once backend ships /broadcasts/recipients filters,
    // /broadcasts/{id}/receipts, and the realtime channel.
    const bool kUseMarketingMock = true;

    if (kUseMarketingMock) {
      getIt.registerSingleton<MockBroadcastRealtimeSimulator>(
        MockBroadcastRealtimeSimulator(getIt<EventBus>()),
      );
      getIt.registerSingleton<MarketingBroadcastRepository>(
        MockMarketingBroadcastRepositoryImpl(
          simulator: getIt<MockBroadcastRealtimeSimulator>(),
        ),
      );
      getIt.registerSingleton<MarketingRepository>(
        MockMarketingRepositoryImpl(),
      );
    } else { // ignore: dead_code
      getIt.registerSingleton<MarketingBroadcastApi>(
        MarketingBroadcastApi(getIt<DioClient>()),
      );
      getIt.registerSingleton<MarketingBroadcastRepository>(
        MarketingBroadcastRepositoryImpl(getIt<MarketingBroadcastApi>()),
      );
      getIt.registerSingleton<MarketingRepository>(
        MarketingRepositoryImpl(
          getIt<MarketingBroadcastRepository>(),
          getIt<DioClient>(),
        ),
      );
    }

    // --- Prompt Repository ---
    getIt.registerSingleton<PromptRepository>(MockPromptRepositoryImpl());

    getIt.registerSingleton<KnowledgeRepository>(MockKnowledgeRepositoryImpl());
  }
}
