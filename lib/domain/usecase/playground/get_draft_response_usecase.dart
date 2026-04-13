import 'dart:async';

import '/core/domain/usecase/use_case.dart';
import '/domain/repository/playground/playground_repository.dart';

class GetDraftResponseUseCase extends UseCase<String, DraftResponseParams> {
  final PlaygroundRepository _repository;

  GetDraftResponseUseCase(this._repository);

  @override
  Future<String> call({required DraftResponseParams params}) =>
      _repository.getDraftResponse(params);
}
