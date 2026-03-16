import 'dart:async';

import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/add_comment_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/assign_agent_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/create_ticket_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/delete_ticket_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_available_agents_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_customer_history_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_ticket_by_id_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_tickets_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/update_ticket_status_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/update_ticket_usecase.dart';

import '../../../di/service_locator.dart';

class UseCaseModule {
  static Future<void> configureUseCaseModuleInjection() async {
    // ticket use cases:---------------------------------------------------------------
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
      AddCommentUseCase(),
    );

    getIt.registerSingleton<GetCustomerHistoryUseCase>(
      GetCustomerHistoryUseCase(getIt<TicketRepository>()),
    );

    getIt.registerSingleton<UpdateTicketStatusUseCase>(
      UpdateTicketStatusUseCase(getIt<TicketRepository>()),
    );
  }
}
