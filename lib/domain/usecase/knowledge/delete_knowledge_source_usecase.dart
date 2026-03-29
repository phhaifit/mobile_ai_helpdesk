import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class DeleteKnowledgeSourceUseCase extends UseCase<void, String> {
  final KnowledgeRepository _repository;

  DeleteKnowledgeSourceUseCase(this._repository);

  @override
  Future<void> call({required String params}) {
    return _repository.deleteSource(params);
  }
}
