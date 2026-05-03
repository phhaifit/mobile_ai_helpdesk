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
  Future<Ticket> call({required UpdateTicketStatusParams params}) async {
    final ticket = await _repository.getTicketById(params.ticketId);
    if (ticket == null) {
      throw Exception('Ticket not found');
    }

    final updatedTicket = ticket.copyWith(
      status: params.newStatus,
      resolvedAt:
          params.newStatus == TicketStatus.resolved
              ? DateTime.now()
              : ticket.resolvedAt,
    );
    return _repository.updateTicket(updatedTicket);
  }
}
