import 'dart:async';

import '/core/domain/usecase/use_case.dart';
import '/domain/entity/ai_agent/ai_agent.dart';
import '/domain/repository/ai_agent/ai_agent_repository.dart';

class GetAgentUseCase extends UseCase<AiAgent?, String> {
  final AiAgentRepository _repository;
  GetAgentUseCase(this._repository);

  @override
  Future<AiAgent?> call({required String params}) =>
      _repository.getAgentById(params);
}
