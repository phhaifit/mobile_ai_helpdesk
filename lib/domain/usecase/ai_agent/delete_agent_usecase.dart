import 'dart:async';

import '/core/domain/usecase/use_case.dart';
import '/domain/repository/ai_agent/ai_agent_repository.dart';

class DeleteAgentUseCase extends UseCase<void, String> {
  final AiAgentRepository _repository;
  DeleteAgentUseCase(this._repository);

  @override
  Future<void> call({required String params}) =>
      _repository.deleteAgent(params);
}
