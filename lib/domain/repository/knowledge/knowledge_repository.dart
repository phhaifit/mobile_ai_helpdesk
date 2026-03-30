import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';

abstract class KnowledgeRepository {
  Future<List<KnowledgeSource>> getSources();

  Future<KnowledgeSource> addSource(KnowledgeSource source);

  Future<KnowledgeSource> updateSourceCrawlInterval(
    String id,
    CrawlInterval crawlInterval,
  );

  Future<void> deleteSource(String id);

  Future<KnowledgeSource> reindexSource(String id);

  Future<bool> testDbConnection(Map<String, dynamic> connectionConfig);
}
