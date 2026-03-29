import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/add_knowledge_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/delete_knowledge_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/get_knowledge_sources_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/reindex_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/test_db_connection_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/update_source_crawl_interval_usecase.dart';
import 'package:mobx/mobx.dart';

part 'knowledge_store.g.dart';

class KnowledgeStore = _KnowledgeStore with _$KnowledgeStore;

abstract class _KnowledgeStore with Store {
  final GetKnowledgeSourcesUseCase _getSources;
  final AddKnowledgeSourceUseCase _addSource;
  final DeleteKnowledgeSourceUseCase _deleteSource;
  final ReindexSourceUseCase _reindexSource;
  final TestDbConnectionUseCase _testDbConnection;
  final UpdateSourceCrawlIntervalUseCase _updateSourceCrawlInterval;

  _KnowledgeStore(
    this._getSources,
    this._addSource,
    this._deleteSource,
    this._reindexSource,
    this._testDbConnection,
    this._updateSourceCrawlInterval,
  );

  // ---------------------------------------------------------------------------
  // Observables
  // ---------------------------------------------------------------------------

  @observable
  ObservableList<KnowledgeSource> sources = ObservableList();

  // null = Tất cả, 'file', 'web', 'drive', 'db'
  @observable
  String? selectedCategory;

  @observable
  bool isLoading = false;

  @observable
  bool isTesting = false;

  @observable
  bool? connectionTestSuccess;

  @observable
  String? errorMessage;

  // ---------------------------------------------------------------------------
  // Computed
  // ---------------------------------------------------------------------------

  @computed
  List<KnowledgeSource> get filteredSources {
    if (selectedCategory == null) return sources.toList();
    return sources.where((s) {
      switch (selectedCategory) {
        case 'file':
          return s.type == KnowledgeSourceType.localFile;
        case 'web':
          return s.type == KnowledgeSourceType.webSingle ||
              s.type == KnowledgeSourceType.webFull;
        case 'drive':
          return s.type == KnowledgeSourceType.googleDrive;
        case 'db':
          return s.type == KnowledgeSourceType.postgresql ||
              s.type == KnowledgeSourceType.sqlServer;
        default:
          return true;
      }
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  @action
  Future<void> loadSources() async {
    isLoading = true;
    errorMessage = null;
    try {
      final result = await _getSources.call(params: null);
      sources = ObservableList.of(result);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  void filterByCategory(String? category) {
    selectedCategory = category;
  }

  @action
  Future<void> addSource(KnowledgeSource source) async {
    isLoading = true;
    errorMessage = null;
    try {
      final added = await _addSource.call(params: source);
      sources.add(added);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> deleteSource(String id) async {
    isLoading = true;
    errorMessage = null;
    try {
      await _deleteSource.call(params: id);
      sources.removeWhere((s) => s.id == id);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> reindexSource(String id) async {
    errorMessage = null;
    try {
      final updated = await _reindexSource.call(params: id);
      final index = sources.indexWhere((s) => s.id == id);
      if (index != -1) sources[index] = updated;
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> updateSourceCrawlInterval(
    String id,
    CrawlInterval crawlInterval,
  ) async {
    errorMessage = null;
    try {
      final updated = await _updateSourceCrawlInterval.call(
        params: UpdateSourceCrawlIntervalParams(
          id: id,
          crawlInterval: crawlInterval,
        ),
      );
      final index = sources.indexWhere((s) => s.id == id);
      if (index != -1) {
        sources[index] = updated;
      }
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> testConnection(Map<String, dynamic> config) async {
    isTesting = true;
    connectionTestSuccess = null;
    try {
      connectionTestSuccess = await _testDbConnection.call(params: config);
    } catch (e) {
      connectionTestSuccess = false;
      errorMessage = e.toString();
    } finally {
      isTesting = false;
    }
  }

  @action
  void resetConnectionTest() {
    connectionTestSuccess = null;
  }

  void dispose() {}
}
