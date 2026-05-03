import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class UpdateSourceCrawlIntervalParams {
  final String id;
  final CrawlInterval interval;

  const UpdateSourceCrawlIntervalParams({
    required this.id,
    required this.interval,
  });
}

class UpdateSourceCrawlIntervalUseCase
    extends UseCase<void, UpdateSourceCrawlIntervalParams> {
  final KnowledgeRepository _repository;

  UpdateSourceCrawlIntervalUseCase(this._repository);

  @override
  Future<void> call({required UpdateSourceCrawlIntervalParams params}) {
    return _repository.updateSourceInterval(params.id, params.interval);
  }
}
