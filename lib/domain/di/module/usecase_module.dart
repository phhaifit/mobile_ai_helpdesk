import 'dart:async';

import 'package:ai_helpdesk/domain/repository/monetization/monetization_repository.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';
import 'package:ai_helpdesk/domain/usecase/monetization/get_monetization_overview_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/monetization/simulate_upgrade_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_tickets_usecase.dart';
import '/domain/repository/ticket/ticket_repository.dart';
import '/domain/usecase/ticket/get_tickets_usecase.dart';

import '../../../di/service_locator.dart';

class UseCaseModule {
  static Future<void> configureUseCaseModuleInjection() async {
    // use cases:---------------------------------------------------------------
    getIt.registerSingleton<GetTicketsUseCase>(
      GetTicketsUseCase(getIt<TicketRepository>()),
    );

    getIt.registerSingleton<GetMonetizationOverviewUseCase>(
      GetMonetizationOverviewUseCase(getIt<MonetizationRepository>()),
    );

    getIt.registerSingleton<SimulateUpgradeUseCase>(
      SimulateUpgradeUseCase(getIt<MonetizationRepository>()),
    );
  }
}
