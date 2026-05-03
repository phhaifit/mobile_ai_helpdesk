import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class ImportDatabaseQueryParams {
  final String name;
  final String query;
  final String uri;
  final CrawlInterval interval;
  final DatabaseDialect dialect;

  const ImportDatabaseQueryParams({
    required this.name,
    required this.query,
    required this.uri,
    required this.interval,
    this.dialect = DatabaseDialect.postgresql,
  });
}

class ImportDatabaseQueryUseCase
    extends UseCase<KnowledgeSource, ImportDatabaseQueryParams> {
  final KnowledgeRepository _repository;

  ImportDatabaseQueryUseCase(this._repository);

  @override
  Future<KnowledgeSource> call({required ImportDatabaseQueryParams params}) {
    return _repository.importDatabaseQuery(
      name: params.name,
      query: params.query,
      uri: params.uri,
      interval: params.interval,
      dialect: params.dialect,
    );
  }
}
