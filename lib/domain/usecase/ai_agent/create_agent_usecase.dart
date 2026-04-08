import 'dart:async';

import '/core/domain/usecase/use_case.dart';
import '/domain/entity/ai_agent/ai_agent.dart';
import '/domain/repository/ai_agent/ai_agent_repository.dart';

class CreateAgentUseCase extends UseCase<AiAgent, AiAgent> {
  final AiAgentRepository _repository;
  CreateAgentUseCase(this._repository);

  @override
  Future<AiAgent> call({required AiAgent params}) =>
      _repository.createAgent(params);
}
