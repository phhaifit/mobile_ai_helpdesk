import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

class GetTicketsUseCase extends UseCase<List<Ticket>, void> {
  final TicketRepository _repository;

  GetTicketsUseCase(this._repository);

  @override
  Future<List<Ticket>> call({required void params}) {
    return _repository.getTickets();
  }
}
