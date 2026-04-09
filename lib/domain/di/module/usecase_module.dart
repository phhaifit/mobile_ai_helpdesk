import 'dart:async';

import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';
import 'package:ai_helpdesk/domain/repository/monetization/monetization_repository.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';
import 'package:ai_helpdesk/domain/usecase/auth/change_password_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/get_current_user_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/login_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/logout_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/register_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/request_password_reset_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/reset_password_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/add_knowledge_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/delete_knowledge_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/get_knowledge_sources_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/reindex_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/test_db_connection_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/update_source_crawl_interval_usecase.dart';
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
import 'package:ai_helpdesk/domain/usecase/ticket/add_comment_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/assign_agent_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/create_ticket_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/delete_ticket_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_available_agents_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_comments_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_customer_history_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_ticket_by_id_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_tickets_usecase.dart';

// AI Agent
import '/domain/repository/ai_agent/ai_agent_repository.dart';
import '/domain/usecase/ai_agent/create_agent_usecase.dart';
import '/domain/usecase/ai_agent/delete_agent_usecase.dart';
import '/domain/usecase/ai_agent/get_agent_usecase.dart';
import '/domain/usecase/ai_agent/get_agents_usecase.dart';
import '/domain/usecase/ai_agent/update_agent_usecase.dart';
// Playground
import '/domain/repository/playground/playground_repository.dart';
import '/domain/usecase/playground/create_session_usecase.dart';
import '/domain/usecase/playground/get_sessions_usecase.dart';
import '/domain/usecase/playground/send_playground_message_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_comments_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_ticket_history_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_tickets_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/update_ticket_status_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/update_ticket_usecase.dart';

import '../../../di/service_locator.dart';

class UseCaseModule {
  static Future<void> configureUseCaseModuleInjection() async {
    // Auth Use Cases:-----------------------------------------------------------
    getIt.registerSingleton<LoginUseCase>(
      LoginUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<RegisterUseCase>(
      RegisterUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<LogoutUseCase>(
      LogoutUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<GetCurrentUserUseCase>(
      GetCurrentUserUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<ChangePasswordUseCase>(
      ChangePasswordUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<ResetPasswordUseCase>(
      ResetPasswordUseCase(getIt<AuthRepository>()),
    );

    getIt.registerSingleton<RequestPasswordResetUseCase>(
      RequestPasswordResetUseCase(getIt<AuthRepository>()),
    );

    // Ticket Use Cases:--------------------------------------------------------
    getIt.registerSingleton<GetTicketsUseCase>(
      GetTicketsUseCase(getIt<TicketRepository>()),
    );

    getIt.registerSingleton<GetTicketByIdUseCase>(
      GetTicketByIdUseCase(getIt<TicketRepository>()),
    );

    getIt.registerSingleton<CreateTicketUseCase>(
      CreateTicketUseCase(getIt<TicketRepository>()),
    );

    getIt.registerSingleton<UpdateTicketUseCase>(
      UpdateTicketUseCase(getIt<TicketRepository>()),
    );

    getIt.registerSingleton<DeleteTicketUseCase>(
      DeleteTicketUseCase(getIt<TicketRepository>()),
    );

    getIt.registerSingleton<GetAvailableAgentsUseCase>(
      GetAvailableAgentsUseCase(getIt<TicketRepository>()),
    );

    getIt.registerSingleton<AssignAgentUseCase>(
      AssignAgentUseCase(getIt<TicketRepository>()),
    );

    getIt.registerSingleton<AddCommentUseCase>(
      AddCommentUseCase(getIt<TicketRepository>()),
    );

    getIt.registerSingleton<GetCustomerHistoryUseCase>(
      GetCustomerHistoryUseCase(getIt<TicketRepository>()),
    );

    getIt.registerSingleton<UpdateTicketStatusUseCase>(
      UpdateTicketStatusUseCase(getIt<TicketRepository>()),
    );

    getIt.registerSingleton<GetCommentsUseCase>(
      GetCommentsUseCase(getIt<TicketRepository>()),
    );

    getIt.registerSingleton<GetTicketHistoryUseCase>(
      GetTicketHistoryUseCase(getIt<TicketRepository>()),
    );

    // Omnichannel Use Cases:---------------------------------------------------
    getIt.registerSingleton<GetOmnichannelOverviewUseCase>(
      GetOmnichannelOverviewUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<ConnectMessengerUseCase>(
      ConnectMessengerUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<DisconnectMessengerUseCase>(
      DisconnectMessengerUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<SyncMessengerDataUseCase>(
      SyncMessengerDataUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<UpdateMessengerSettingsUseCase>(
      UpdateMessengerSettingsUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<ConnectZaloFromQrUseCase>(
      ConnectZaloFromQrUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<DisconnectZaloUseCase>(
      DisconnectZaloUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<RetryZaloSyncUseCase>(
      RetryZaloSyncUseCase(getIt<OmnichannelRepository>()),
    );
    getIt.registerSingleton<UpdateZaloAssignmentsUseCase>(
      UpdateZaloAssignmentsUseCase(getIt<OmnichannelRepository>()),
    );

    // Monetization Use Cases:--------------------------------------------------
    getIt.registerSingleton<GetMonetizationOverviewUseCase>(
      GetMonetizationOverviewUseCase(getIt<MonetizationRepository>()),
    );

    getIt.registerSingleton<SimulateUpgradeUseCase>(
      SimulateUpgradeUseCase(getIt<MonetizationRepository>()),
    );

    // --- AI Agent Use Cases ---
    getIt.registerSingleton<GetAgentsUseCase>(
      GetAgentsUseCase(getIt<AiAgentRepository>()),
    );
    getIt.registerSingleton<GetAgentUseCase>(
      GetAgentUseCase(getIt<AiAgentRepository>()),
    );
    getIt.registerSingleton<CreateAgentUseCase>(
      CreateAgentUseCase(getIt<AiAgentRepository>()),
    );
    getIt.registerSingleton<UpdateAgentUseCase>(
      UpdateAgentUseCase(getIt<AiAgentRepository>()),
    );
    getIt.registerSingleton<DeleteAgentUseCase>(
      DeleteAgentUseCase(getIt<AiAgentRepository>()),
    );

    // --- Playground Use Cases ---
    getIt.registerSingleton<GetSessionsUseCase>(
      GetSessionsUseCase(getIt<PlaygroundRepository>()),
    );
    getIt.registerSingleton<CreateSessionUseCase>(
      CreateSessionUseCase(getIt<PlaygroundRepository>()),
    );
    getIt.registerSingleton<SendPlaygroundMessageUseCase>(
      SendPlaygroundMessageUseCase(getIt<PlaygroundRepository>()),
    );
    // Knowledge Use Cases:-----------------------------------------------------
    getIt.registerSingleton<GetKnowledgeSourcesUseCase>(
      GetKnowledgeSourcesUseCase(getIt<KnowledgeRepository>()),
    );
    getIt.registerSingleton<AddKnowledgeSourceUseCase>(
      AddKnowledgeSourceUseCase(getIt<KnowledgeRepository>()),
    );
    getIt.registerSingleton<DeleteKnowledgeSourceUseCase>(
      DeleteKnowledgeSourceUseCase(getIt<KnowledgeRepository>()),
    );
    getIt.registerSingleton<ReindexSourceUseCase>(
      ReindexSourceUseCase(getIt<KnowledgeRepository>()),
    );
    getIt.registerSingleton<TestDbConnectionUseCase>(
      TestDbConnectionUseCase(getIt<KnowledgeRepository>()),
    );
    getIt.registerSingleton<UpdateSourceCrawlIntervalUseCase>(
      UpdateSourceCrawlIntervalUseCase(getIt<KnowledgeRepository>()),
    );
  }
}
