import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class PollSourceStatusUseCase
    extends UseCase<Map<String, KnowledgeSourceStatus>, List<String>> {
  final KnowledgeRepository _repository;

  PollSourceStatusUseCase(this._repository);

  @override
  Future<Map<String, KnowledgeSourceStatus>> call({
    required List<String> params,
  }) {
    return _repository.pollSourceStatus(params);
  }
}
