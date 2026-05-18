import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

class UpdateTicketStatusParams {
  final String ticketId;
  final TicketStatus newStatus;

  UpdateTicketStatusParams({required this.ticketId, required this.newStatus});
}

class UpdateTicketStatusUseCase
    extends UseCase<Ticket, UpdateTicketStatusParams> {
  final TicketRepository _repository;

  UpdateTicketStatusUseCase(this._repository);

  @override
  Future<Ticket> call({required UpdateTicketStatusParams params}) {
    // Single POST `{ticketID, status}` — repository handles the BE call and
    // refetches the canonical ticket. Web mirror.
    return _repository.updateStatus(
      ticketId: params.ticketId,
      status: params.newStatus,
    );
  }
}
