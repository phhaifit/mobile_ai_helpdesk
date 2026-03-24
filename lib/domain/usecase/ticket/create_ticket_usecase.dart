import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

class CreateTicketUseCase extends UseCase<Ticket, Ticket> {
  final TicketRepository _repository;

  CreateTicketUseCase(this._repository);

  @override
  Future<Ticket> call({required Ticket params}) {
    return _repository.createTicket(params);
  }
}
