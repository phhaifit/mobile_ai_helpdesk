import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/agent/agent.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

class GetAvailableAgentsUseCase extends UseCase<List<Agent>, void> {
  final TicketRepository _repository;

  GetAvailableAgentsUseCase(this._repository);

  @override
  Future<List<Agent>> call({required void params}) {
    return _repository.getAvailableAgents();
  }
}
