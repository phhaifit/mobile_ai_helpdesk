import 'dart:async';

import '/core/domain/usecase/use_case.dart';
import '/domain/entity/ticket/ticket.dart';
import '/domain/repository/ticket/ticket_repository.dart';

class GetTicketsUseCase extends UseCase<List<Ticket>, void> {
  final TicketRepository _repository;

  GetTicketsUseCase(this._repository);

  @override
  Future<List<Ticket>> call({required void params}) {
    return _repository.getTickets();
  }
}
