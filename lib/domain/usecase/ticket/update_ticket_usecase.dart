import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

class UpdateTicketUseCase extends UseCase<Ticket, Ticket> {
  final TicketRepository _repository;

  UpdateTicketUseCase(this._repository);

  @override
  Future<Ticket> call({required Ticket params}) {
    return _repository.updateTicket(params);
  }
}
