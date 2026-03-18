import 'dart:async';

import '/domain/repository/ticket/ticket_repository.dart';
import '/domain/usecase/ticket/get_tickets_usecase.dart';

import '../../../di/service_locator.dart';

class UseCaseModule {
  static Future<void> configureUseCaseModuleInjection() async {
    // use cases:---------------------------------------------------------------
    getIt.registerSingleton<GetTicketsUseCase>(
      GetTicketsUseCase(getIt<TicketRepository>()),
    );
  }
}
