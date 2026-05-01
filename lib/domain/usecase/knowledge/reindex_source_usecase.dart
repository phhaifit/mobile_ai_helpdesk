import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class ReindexSourceUseCase extends UseCase<void, String> {
  final KnowledgeRepository _repository;

  ReindexSourceUseCase(this._repository);

  @override
  Future<void> call({required String params}) {
    return _repository.reindexSource(params);
  }
}
