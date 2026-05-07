import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class UpdateDatabaseQueryParams {
  final String id;
  final String query;
  final String uri;

  const UpdateDatabaseQueryParams({
    required this.id,
    required this.query,
    required this.uri,
  });
}

class UpdateDatabaseQueryUseCase
    extends UseCase<void, UpdateDatabaseQueryParams> {
  final KnowledgeRepository _repository;

  UpdateDatabaseQueryUseCase(this._repository);

  @override
  Future<void> call({required UpdateDatabaseQueryParams params}) {
    return _repository.updateDatabaseQuery(
      id: params.id,
      query: params.query,
      uri: params.uri,
    );
  }
}
