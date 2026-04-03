import 'dart:async';

import '/core/domain/usecase/use_case.dart';
import '/domain/entity/playground/playground_session.dart';
import '/domain/repository/playground/playground_repository.dart';

class GetSessionsUseCase extends UseCase<List<PlaygroundSession>, void> {
  final PlaygroundRepository _repository;
  GetSessionsUseCase(this._repository);

  @override
  Future<List<PlaygroundSession>> call({void params}) =>
      _repository.getSessions();
}
