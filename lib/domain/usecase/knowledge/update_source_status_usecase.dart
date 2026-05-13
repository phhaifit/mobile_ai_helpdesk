import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class UpdateSourceStatusParams {
  final String id;
  final KnowledgeSourceStatus status;

  const UpdateSourceStatusParams({required this.id, required this.status});
}

class UpdateSourceStatusUseCase
    extends UseCase<void, UpdateSourceStatusParams> {
  final KnowledgeRepository _repository;

  UpdateSourceStatusUseCase(this._repository);

  @override
  Future<void> call({required UpdateSourceStatusParams params}) {
    return _repository.updateSourceStatus(params.id, params.status);
  }
}
