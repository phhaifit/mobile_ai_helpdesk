import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

/// Configurable fake used by use-case tests.
/// Set [sourcesToReturn], [addSourceResult], etc. before each test.
/// Inspect [capturedXxx] fields to assert what the use case passed to the repo.
class FakeKnowledgeRepository implements KnowledgeRepository {
  // --- configurable return values ---
  List<KnowledgeSource> sourcesToReturn = [];
  KnowledgeSource? addSourceResult;
  KnowledgeSource? reindexResult;
  KnowledgeSource? updateIntervalResult;
  bool testDbConnectionResult = true;
  Stream<Map<String, KnowledgeSourceStatus>> sseStream = Stream.empty();

  // --- captured arguments ---
  String? capturedDeleteId;
  String? capturedReindexId;
  KnowledgeSource? capturedAddSource;
  String? capturedUpdateIntervalId;
  CrawlInterval? capturedUpdateInterval;
  Map<String, dynamic>? capturedDbConfig;

  @override
  Future<List<KnowledgeSource>> getSources() async => sourcesToReturn;

  @override
  Future<KnowledgeSource> addSource(KnowledgeSource source) async {
    capturedAddSource = source;
    return addSourceResult ?? source;
  }

  @override
  Future<void> deleteSource(String id) async {
    capturedDeleteId = id;
  }

  @override
  Future<KnowledgeSource> reindexSource(String id) async {
    capturedReindexId = id;
    return reindexResult ?? sourcesToReturn.firstWhere((s) => s.id == id);
  }

  @override
  Future<KnowledgeSource> updateSourceCrawlInterval(
    String id,
    CrawlInterval crawlInterval,
  ) async {
    capturedUpdateIntervalId = id;
    capturedUpdateInterval = crawlInterval;
    return updateIntervalResult ??
        sourcesToReturn.firstWhere((s) => s.id == id);
  }

  @override
  Future<bool> testDbConnection(Map<String, dynamic> connectionConfig) async {
    capturedDbConfig = connectionConfig;
    return testDbConnectionResult;
  }

  @override
  Future<List<KnowledgeSource>> getSourcesByCategory(String category) async =>
      sourcesToReturn;

  @override
  Future<KnowledgeSource> updateSourceStatus(
    String id,
    KnowledgeSourceStatus status,
  ) async =>
      sourcesToReturn.firstWhere((s) => s.id == id);

  @override
  Stream<Map<String, KnowledgeSourceStatus>> watchSourceStatuses() => sseStream;
}
