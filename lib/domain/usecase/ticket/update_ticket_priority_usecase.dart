import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

class UpdateTicketPriorityParams {
  final String ticketId;
  final TicketPriority newPriority;

  UpdateTicketPriorityParams({
    required this.ticketId,
    required this.newPriority,
  });
}

class UpdateTicketPriorityUseCase
    extends UseCase<Ticket, UpdateTicketPriorityParams> {
  final TicketRepository _repository;

  UpdateTicketPriorityUseCase(this._repository);

  @override
  Future<Ticket> call({required UpdateTicketPriorityParams params}) {
    return _repository.updatePriority(
      ticketId: params.ticketId,
      priority: params.newPriority,
    );
  }
}
