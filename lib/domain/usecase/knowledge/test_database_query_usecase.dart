import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class TestDatabaseQueryParams {
  final String query;
  final String uri;

  const TestDatabaseQueryParams({required this.query, required this.uri});
}

class TestDatabaseQueryUseCase
    extends UseCase<DatabaseQueryPreview, TestDatabaseQueryParams> {
  final KnowledgeRepository _repository;

  TestDatabaseQueryUseCase(this._repository);

  @override
  Future<DatabaseQueryPreview> call({required TestDatabaseQueryParams params}) {
    return _repository.testDatabaseQuery(
      query: params.query,
      uri: params.uri,
    );
  }
}
