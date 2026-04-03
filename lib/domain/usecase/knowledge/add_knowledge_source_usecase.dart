import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class AddKnowledgeSourceUseCase
    extends UseCase<KnowledgeSource, KnowledgeSource> {
  final KnowledgeRepository _repository;

  AddKnowledgeSourceUseCase(this._repository);

  @override
  Future<KnowledgeSource> call({required KnowledgeSource params}) {
    return _repository.addSource(params);
  }
}
