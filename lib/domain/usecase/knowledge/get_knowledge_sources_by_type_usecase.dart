import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

/// Returns sources filtered by UI category ('web'|'file'|'drive'|'db').
class GetKnowledgeSourcesByTypeUseCase
    extends UseCase<List<KnowledgeSource>, String> {
  final KnowledgeRepository _repository;

  GetKnowledgeSourcesByTypeUseCase(this._repository);

  @override
  Future<List<KnowledgeSource>> call({required String params}) {
    return _repository.getSourcesByCategory(params);
  }
}
