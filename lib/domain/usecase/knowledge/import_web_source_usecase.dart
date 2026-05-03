import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class ImportWebSourceParams {
  final String url;
  final KnowledgeSourceType type;
  final CrawlInterval interval;

  const ImportWebSourceParams({
    required this.url,
    required this.type,
    required this.interval,
  });
}

class ImportWebSourceUseCase
    extends UseCase<KnowledgeSource, ImportWebSourceParams> {
  final KnowledgeRepository _repository;

  ImportWebSourceUseCase(this._repository);

  @override
  Future<KnowledgeSource> call({required ImportWebSourceParams params}) {
    return _repository.importWebSource(
      url: params.url,
      type: params.type,
      interval: params.interval,
    );
  }
}
