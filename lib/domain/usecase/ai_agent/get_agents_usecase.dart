import 'dart:async';

import '/core/domain/usecase/use_case.dart';
import '/domain/entity/ai_agent/ai_agent.dart';
import '/domain/repository/ai_agent/ai_agent_repository.dart';

class GetAgentsUseCase extends UseCase<List<AiAgent>, void> {
  final AiAgentRepository _repository;
  GetAgentsUseCase(this._repository);

  @override
  Future<List<AiAgent>> call({required void params}) =>
      _repository.getAgents();
}
