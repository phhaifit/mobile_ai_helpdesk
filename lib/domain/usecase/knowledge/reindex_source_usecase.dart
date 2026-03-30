import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class ReindexSourceUseCase extends UseCase<KnowledgeSource, String> {
  final KnowledgeRepository _repository;

  ReindexSourceUseCase(this._repository);

  @override
  Future<KnowledgeSource> call({required String params}) {
    return _repository.reindexSource(params);
  }
}
