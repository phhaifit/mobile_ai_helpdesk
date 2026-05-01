import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class GetKnowledgeSourcesParams {
  final List<String>? ids;
  final String? query;
  const GetKnowledgeSourcesParams({this.ids, this.query});
}

class GetKnowledgeSourcesUseCase
    extends UseCase<List<KnowledgeSource>, GetKnowledgeSourcesParams?> {
  final KnowledgeRepository _repository;

  GetKnowledgeSourcesUseCase(this._repository);

  @override
  Future<List<KnowledgeSource>> call({
    required GetKnowledgeSourcesParams? params,
  }) {
    return _repository.getSources(
      ids: params?.ids,
      query: params?.query,
    );
  }
}
