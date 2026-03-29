import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class UpdateSourceCrawlIntervalParams {
  final String id;
  final CrawlInterval crawlInterval;

  const UpdateSourceCrawlIntervalParams({
    required this.id,
    required this.crawlInterval,
  });
}

class UpdateSourceCrawlIntervalUseCase
    extends UseCase<KnowledgeSource, UpdateSourceCrawlIntervalParams> {
  final KnowledgeRepository _repository;

  UpdateSourceCrawlIntervalUseCase(this._repository);

  @override
  Future<KnowledgeSource> call({
    required UpdateSourceCrawlIntervalParams params,
  }) {
    return _repository.updateSourceCrawlInterval(
      params.id,
      params.crawlInterval,
    );
  }
}
