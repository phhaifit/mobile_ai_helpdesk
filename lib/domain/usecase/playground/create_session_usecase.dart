import 'dart:async';

import '/core/domain/usecase/use_case.dart';
import '/domain/entity/playground/playground_session.dart';
import '/domain/repository/playground/playground_repository.dart';

class CreateSessionParams {
  final PlaygroundContextType contextType;
  final String? agentId;

  const CreateSessionParams({required this.contextType, this.agentId});
}

class CreateSessionUseCase extends UseCase<PlaygroundSession, CreateSessionParams> {
  final PlaygroundRepository _repository;
  CreateSessionUseCase(this._repository);

  @override
  Future<PlaygroundSession> call({required CreateSessionParams params}) =>
      _repository.createSession(params.contextType, params.agentId);
}
