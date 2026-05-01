import 'dart:async';

import 'package:ai_helpdesk/core/monitoring/sentry/sentry_service.dart';
import 'package:ai_helpdesk/core/stores/error/error_store.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/domain/repository/account/account_repository.dart';
import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';
import 'package:ai_helpdesk/domain/repository/customer/customer_repository.dart';
import 'package:ai_helpdesk/domain/repository/invitation/invitation_repository.dart';
import 'package:ai_helpdesk/domain/repository/prompt/prompt_repository.dart';
import 'package:ai_helpdesk/domain/repository/setting/setting_repository.dart';
import 'package:ai_helpdesk/domain/repository/team/team_repository.dart';
import 'package:ai_helpdesk/domain/repository/tenant/tenant_repository.dart';
import 'package:ai_helpdesk/domain/usecase/account/get_current_account_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/account/update_account_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/send_otp_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/sign_in_with_google_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/sign_out_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/verify_otp_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/delete_knowledge_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/get_knowledge_sources_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/import_database_query_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/import_google_drive_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/import_local_file_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/import_web_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/poll_source_status_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/reindex_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/test_database_query_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/update_database_query_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/update_source_crawl_interval_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/update_source_status_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/watch_source_statuses_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/connect_facebook_admin_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/create_campaign_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/delete_template_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/disconnect_facebook_admin_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/estimate_audience_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/get_campaigns_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/get_marketing_overview_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/get_templates_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/resume_campaign_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/save_template_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/start_campaign_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/stop_campaign_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/monetization/get_monetization_overview_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/monetization/simulate_upgrade_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/connect_messenger_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/connect_zalo_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/disconnect_messenger_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/disconnect_zalo_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/generate_zalo_qr_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/get_omnichannel_overview_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/get_zalo_qr_status_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/retry_zalo_sync_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/sync_messenger_data_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/update_messenger_settings_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/update_zalo_assignments_usecase.dart';
import 'package:ai_helpdesk/presentation/auth/edit_profile/store/edit_profile_store.dart';
import 'package:ai_helpdesk/presentation/auth/sign_in_email/store/sign_in_email_store.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:ai_helpdesk/presentation/auth/verify_otp/store/verify_otp_store.dart';
import 'package:ai_helpdesk/presentation/chat/store/chat_room_store.dart';
import 'package:ai_helpdesk/presentation/chat/store/chat_store.dart';
import 'package:ai_helpdesk/presentation/home/store/language/language_store.dart';
import 'package:ai_helpdesk/presentation/home/store/theme/theme_store.dart';
import 'package:ai_helpdesk/presentation/marketing/store/marketing_store.dart';
import 'package:ai_helpdesk/presentation/monetization/store/monetization_store.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:ai_helpdesk/presentation/prompt/store/prompt_store.dart';
import 'package:ai_helpdesk/core/services/websocket/ticket_websocket_service.dart';
import 'package:ai_helpdesk/presentation/splash/store/splash_store.dart';
import 'package:ai_helpdesk/presentation/stores/session_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/create_ticket_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/customer_history_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/edit_ticket_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_detail_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_tab_store.dart';
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
import 'package:ai_helpdesk/presentation/tenant/store/tenant_store.dart';
import 'package:ai_helpdesk/presentation/team/store/team_store.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import '../../ai_agent/store/ai_agent_store.dart';
// import '../../customer_management/store/customer_store.dart';
import '../../playground/store/playground_store.dart';

import '../../../domain/usecase/ai_agent/create_agent_usecase.dart';
import '../../../domain/usecase/ai_agent/delete_agent_usecase.dart';
import '../../../domain/usecase/ai_agent/get_agent_usecase.dart';
import '../../../domain/usecase/ai_agent/get_agents_usecase.dart';
import '../../../domain/usecase/ai_agent/update_agent_usecase.dart';
import '../../../domain/usecase/playground/create_session_usecase.dart';
import '../../../domain/usecase/playground/get_sessions_usecase.dart';
import '../../../domain/usecase/playground/send_playground_message_usecase.dart';
import 'package:ai_helpdesk/presentation/customer/store/customer_store.dart';
import 'package:ai_helpdesk/presentation/knowledge/store/knowledge_store.dart';

class StoreModule {
  static Future<void> configureStoreModuleInjection() async {
    final getIt = GetIt.instance;

    // factories:---------------------------------------------------------------
    getIt.registerFactory(() => ErrorStore());

    // --- Auth (session-scoped singleton so splash + profile share state) ---
    getIt.registerSingleton<AuthStore>(
      AuthStore(
        authRepository: getIt<AuthRepository>(),
        accountRepository: getIt<AccountRepository>(),
        signOutUseCase: getIt<SignOutUseCase>(),
        eventBus: getIt<EventBus>(),
        analyticsService: getIt<AnalyticsService>(),
        sentryService: getIt<SentryService>(),
      ),
    );

    getIt.registerFactory<SplashStore>(
      () => SplashStore(
        authRepository: getIt<AuthRepository>(),
        accountRepository: getIt<AccountRepository>(),
        authStore: getIt<AuthStore>(),
      ),
    );

    getIt.registerFactory<SignInEmailStore>(
      () => SignInEmailStore(
        sendOtpUseCase: getIt<SendOtpUseCase>(),
        signInWithGoogleUseCase: getIt<SignInWithGoogleUseCase>(),
        getCurrentAccountUseCase: getIt<GetCurrentAccountUseCase>(),
        authStore: getIt<AuthStore>(),
        analyticsService: getIt<AnalyticsService>(),
      ),
    );

    getIt.registerFactory<VerifyOtpStore>(
      () => VerifyOtpStore(
        verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
        sendOtpUseCase: getIt<SendOtpUseCase>(),
        getCurrentAccountUseCase: getIt<GetCurrentAccountUseCase>(),
        authStore: getIt<AuthStore>(),
        analyticsService: getIt<AnalyticsService>(),
      ),
    );

    getIt.registerFactory<EditProfileStore>(
      () => EditProfileStore(
        updateAccountUseCase: getIt<UpdateAccountUseCase>(),
        authStore: getIt<AuthStore>(),
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
        getIt<AnalyticsService>(),
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
        getIt<AnalyticsService>(),
        getIt<TicketWebSocketService>(),
      ),
    );
    getIt.registerFactory(
      () => EditTicketStore(getIt<UpdateTicketUseCase>()),
    );
    getIt.registerFactory(
      () => CustomerHistoryStore(getIt<GetCustomerHistoryUseCase>()),
    );

    // --- Customer Store ---
    getIt.registerLazySingleton<CustomerStore>(
      () => CustomerStore(getIt<CustomerRepository>()),
    );

    // --- Chat Stores ---
    getIt.registerSingleton<ChatStore>(
      ChatStore(getIt<ChatRepository>(), getIt<AnalyticsService>()),
    );
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
        getIt<DisconnectZaloUseCase>(),
        getIt<RetryZaloSyncUseCase>(),
        getIt<UpdateZaloAssignmentsUseCase>(),
        getIt<GenerateZaloQrUseCase>(),
        getIt<GetZaloQrStatusUseCase>(),
        getIt<ConnectZaloUseCase>(),
      ),
    );
    // --- Monetization Store ---
    getIt.registerFactory(
      () => MonetizationStore(
        getIt<GetMonetizationOverviewUseCase>(),
        getIt<SimulateUpgradeUseCase>(),
      ),
    );

    // --- Tenant Store ---
    getIt.registerSingleton<TenantStore>(
      TenantStore(getIt<TenantRepository>(), getIt<ErrorStore>()),
    );

    // --- Team Store ---
    getIt.registerSingleton<TeamStore>(
      TeamStore(
        getIt<TeamRepository>(),
        getIt<InvitationRepository>(),
        getIt<TenantStore>(),
        getIt<ErrorStore>(),
      ),
    );

    getIt.registerFactory<MarketingStore>(
      () => MarketingStore(
        getIt<GetMarketingOverviewUseCase>(),
        getIt<GetTemplatesUseCase>(),
        getIt<SaveTemplateUseCase>(),
        getIt<DeleteTemplateUseCase>(),
        getIt<GetCampaignsUseCase>(),
        getIt<CreateCampaignUseCase>(),
        getIt<StartCampaignUseCase>(),
        getIt<StopCampaignUseCase>(),
        getIt<ResumeCampaignUseCase>(),
        getIt<EstimateAudienceUseCase>(),
        getIt<ConnectFacebookAdminUseCase>(),
        getIt<DisconnectFacebookAdminUseCase>(),
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

    // --- Prompt Store ---
    getIt.registerLazySingleton<PromptStore>(
      () => PromptStore(getIt<PromptRepository>()),
    );

    // --- Knowledge Store ---
    getIt.registerSingleton<KnowledgeStore>(
      KnowledgeStore(
        getIt<GetKnowledgeSourcesUseCase>(),
        getIt<ReindexSourceUseCase>(),
        getIt<DeleteKnowledgeSourceUseCase>(),
        getIt<UpdateSourceCrawlIntervalUseCase>(),
        getIt<UpdateSourceStatusUseCase>(),
        getIt<ImportWebSourceUseCase>(),
        getIt<ImportLocalFileUseCase>(),
        getIt<ImportGoogleDriveUseCase>(),
        getIt<ImportDatabaseQueryUseCase>(),
        getIt<UpdateDatabaseQueryUseCase>(),
        getIt<TestDatabaseQueryUseCase>(),
        getIt<PollSourceStatusUseCase>(),
        getIt<WatchSourceStatusesUseCase>(),
      ),
    );
  }
}
