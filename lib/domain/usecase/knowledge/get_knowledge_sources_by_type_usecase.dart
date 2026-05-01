import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class GetKnowledgeSourcesByTypeUseCase
    extends UseCase<List<KnowledgeSource>, KnowledgeSourceType> {
  final KnowledgeRepository _repository;

  GetKnowledgeSourcesByTypeUseCase(this._repository);

  @override
  Future<List<KnowledgeSource>> call({required KnowledgeSourceType params}) {
    return _repository.getSourcesByType(params);
  }
}
