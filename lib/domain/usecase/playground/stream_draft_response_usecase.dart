import '/core/domain/usecase/use_case.dart';
import '/domain/repository/playground/playground_repository.dart';

class StreamDraftResponseUseCase
    extends UseCase<Stream<String>, DraftResponseParams> {
  final PlaygroundRepository _repository;

  StreamDraftResponseUseCase(this._repository);

  @override
  Stream<String> call({required DraftResponseParams params}) =>
      _repository.streamDraftResponse(params);
}
