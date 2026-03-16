import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

class AssignAgentParams {
  final String ticketId;
  final String agentId;

  AssignAgentParams({required this.ticketId, required this.agentId});
}

class AssignAgentUseCase extends UseCase<Ticket, AssignAgentParams> {
  final TicketRepository _repository;

  AssignAgentUseCase(this._repository);

  @override
  Future<Ticket> call({required AssignAgentParams params}) async {
    // Get the ticket
    final ticket = await _repository.getTicketById(params.ticketId);
    if (ticket == null) {
      throw Exception('Ticket not found');
    }

    // Update ticket with new agent
    final updatedTicket = ticket.copyWith(assignedAgentId: params.agentId);
    return _repository.updateTicket(updatedTicket);
  }
}
