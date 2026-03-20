import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

class AssignAgentParams {
  final String ticketId;
  final String? agentId;

  AssignAgentParams({required this.ticketId, required this.agentId});
}

class AssignAgentUseCase extends UseCase<Ticket, AssignAgentParams> {
  final TicketRepository _repository;

  AssignAgentUseCase(this._repository);

  @override
  Future<Ticket> call({required AssignAgentParams params}) {
    return _repository.assignAgent(
      ticketId: params.ticketId,
      agentId: params.agentId,
    );
  }
}
