import 'dart:async';

import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/add_knowledge_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/delete_knowledge_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/get_knowledge_sources_by_type_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/get_knowledge_sources_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/reindex_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/test_db_connection_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/update_source_crawl_interval_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/update_source_status_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/watch_source_statuses_usecase.dart';
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
  final WatchSourceStatusesUseCase _watchSourceStatuses;
  final GetKnowledgeSourcesByTypeUseCase _getSourcesByType;
  final UpdateSourceStatusUseCase _updateSourceStatus;

  _KnowledgeStore(
    this._getSources,
    this._addSource,
    this._deleteSource,
    this._reindexSource,
    this._testDbConnection,
    this._updateSourceCrawlInterval,
    this._watchSourceStatuses,
    this._getSourcesByType,
    this._updateSourceStatus,
  );

  // ---------------------------------------------------------------------------
  // Observables
  // ---------------------------------------------------------------------------

  @observable
  ObservableList<KnowledgeSource> sources = ObservableList();

  /// Holds results from the "filter by type" API call.
  /// Null means no active API filter (show all from [sources]).
  @observable
  ObservableList<KnowledgeSource>? apiFilteredSources;

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
  // SSE subscription
  // ---------------------------------------------------------------------------

  StreamSubscription<Map<String, KnowledgeSourceStatus>>? _sseSub;

  // ---------------------------------------------------------------------------
  // Computed
  // ---------------------------------------------------------------------------

  @computed
  List<KnowledgeSource> get filteredSources {
    if (selectedCategory == null || apiFilteredSources == null) {
      return sources.toList();
    }
    return apiFilteredSources!.toList();
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
      // Start SSE after the initial load so we have source IDs available.
      startStatusSse();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> filterByCategory(String? category) async {
    selectedCategory = category;
    if (category == null) {
      apiFilteredSources = null;
      return;
    }
    isLoading = true;
    errorMessage = null;
    try {
      final result = await _getSourcesByType.call(params: category);
      apiFilteredSources = ObservableList.of(result);
    } catch (e) {
      errorMessage = e.toString();
      apiFilteredSources = null;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> updateSourceStatus(
    String id,
    KnowledgeSourceStatus status,
  ) async {
    errorMessage = null;
    try {
      final updated = await _updateSourceStatus.call(
        params: UpdateSourceStatusParams(id: id, status: status),
      );
      // Update in both lists.
      final idx = sources.indexWhere((s) => s.id == id);
      if (idx != -1) sources[idx] = updated;
      final filteredIdx = apiFilteredSources?.indexWhere((s) => s.id == id);
      if (filteredIdx != null && filteredIdx != -1) {
        apiFilteredSources![filteredIdx] = updated;
      }
    } catch (e) {
      errorMessage = e.toString();
    }
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
      if (index != -1) sources[index] = updated;
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

  // ---------------------------------------------------------------------------
  // SSE lifecycle
  // ---------------------------------------------------------------------------

  /// Opens an SSE connection and patches individual source statuses as they
  /// arrive from the backend.  Safe to call multiple times — cancels any
  /// existing subscription first.
  void startStatusSse() {
    _sseSub?.cancel();
    _sseSub = _watchSourceStatuses.call().listen(
      (statusMap) {
        runInAction(() {
          for (final entry in statusMap.entries) {
            final idx = sources.indexWhere((s) => s.id == entry.key);
            if (idx != -1 && sources[idx].status != entry.value) {
              sources[idx] = sources[idx].copyWith(status: entry.value);
            }
          }
        });
      },
      onError: (Object e) {
        // SSE error — surface as a non-blocking message; list stays intact.
        runInAction(() => errorMessage = 'SSE disconnected: $e');
      },
      cancelOnError: true,
    );
  }

  /// Cancels the SSE subscription.  Call this from the screen's [dispose].
  void stopStatusSse() {
    _sseSub?.cancel();
    _sseSub = null;
  }

  void dispose() {
    stopStatusSse();
  }
}
