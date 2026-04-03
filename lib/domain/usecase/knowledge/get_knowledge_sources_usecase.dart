import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class GetKnowledgeSourcesUseCase extends UseCase<List<KnowledgeSource>, void> {
  final KnowledgeRepository _repository;

  GetKnowledgeSourcesUseCase(this._repository);

  @override
  Future<List<KnowledgeSource>> call({required void params}) {
    return _repository.getSources();
  }
}
