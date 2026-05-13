import 'dart:async';
import 'dart:io';

import 'package:ai_helpdesk/data/repository/knowledge/knowledge_exception.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/delete_knowledge_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/get_knowledge_sources_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/import_database_query_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/import_google_drive_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/import_local_file_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/import_web_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/poll_source_status_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/reindex_source_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/test_database_query_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/update_database_query_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/update_source_crawl_interval_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/update_source_status_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/knowledge/watch_source_statuses_usecase.dart';
import 'package:mobx/mobx.dart';

part 'knowledge_store.g.dart';

class KnowledgeStore = _KnowledgeStore with _$KnowledgeStore;

/// SSE health.  When `disconnected`, the store falls back to polling for
/// in-flight sources every [_KnowledgeStore._pollInterval].
enum LiveStatusMode { connected, disconnected, polling }

abstract class _KnowledgeStore with Store {
  _KnowledgeStore(
    this._getSources,
    this._reindex,
    this._deleteSource,
    this._updateInterval,
    this._updateStatus,
    this._importWeb,
    this._importLocalFile,
    this._importGoogleDrive,
    this._importDatabaseQuery,
    this._updateDatabaseQuery,
    this._testDatabaseQuery,
    this._pollStatus,
    this._watchStatuses,
  );

  final GetKnowledgeSourcesUseCase _getSources;
  final ReindexSourceUseCase _reindex;
  final DeleteKnowledgeSourceUseCase _deleteSource;
  final UpdateSourceCrawlIntervalUseCase _updateInterval;
  final UpdateSourceStatusUseCase _updateStatus;
  final ImportWebSourceUseCase _importWeb;
  final ImportLocalFileUseCase _importLocalFile;
  final ImportGoogleDriveUseCase _importGoogleDrive;
  final ImportDatabaseQueryUseCase _importDatabaseQuery;
  final UpdateDatabaseQueryUseCase _updateDatabaseQuery;
  final TestDatabaseQueryUseCase _testDatabaseQuery;
  final PollSourceStatusUseCase _pollStatus;
  final WatchSourceStatusesUseCase _watchStatuses;

  // ---------------------------------------------------------------------------
  // Live state
  // ---------------------------------------------------------------------------

  @observable
  ObservableList<KnowledgeSource> sources = ObservableList();

  @observable
  KnowledgeSourceType? typeFilter;

  @observable
  ObservableFuture<void>? loadFuture;

  @observable
  String? errorMessage;

  /// True when the last load failed because the user has no tenant assigned.
  /// UI shows a dedicated empty state with a "Đặt Tenant ID" action instead
  /// of the generic error banner.
  @observable
  bool tenantMissing = false;

  /// Per-source action in flight (reindex / delete / update interval / update
  /// status / update db query).  Used by the card to show inline spinners.
  @observable
  ObservableSet<String> busySourceIds = ObservableSet();

  // Test DB query
  @observable
  bool isTestingDb = false;

  @observable
  DatabaseQueryPreview? lastDbPreview;

  @observable
  String? dbTestError;

  // File upload
  @observable
  double? uploadProgress; // 0..1, null when no upload in flight

  // SSE / polling
  @observable
  LiveStatusMode liveStatusMode = LiveStatusMode.disconnected;

  StreamSubscription<Map<String, KnowledgeSourceStatus>>? _sseSub;
  Timer? _pollTimer;

  static const _pollInterval = Duration(seconds: 6);
  static const _maxSseRetries = 3;
  int _sseRetries = 0;

  // ---------------------------------------------------------------------------
  // Computed
  // ---------------------------------------------------------------------------

  @computed
  bool get isLoading =>
      loadFuture != null && loadFuture!.status == FutureStatus.pending;

  @computed
  List<KnowledgeSource> get visibleSources =>
      typeFilter == null
          ? sources.toList()
          : sources.where((s) => s.type == typeFilter).toList();

  @computed
  bool get hasInFlightSources => sources.any((s) => s.status.isInFlight);

  // ---------------------------------------------------------------------------
  // Loading
  // ---------------------------------------------------------------------------

  @action
  Future<void> loadSources({String? query}) async {
    final future = ObservableFuture(_loadSources(query: query));
    loadFuture = future;
    try {
      await future;
    } catch (_) {
      // already mapped to errorMessage in _loadSources
    }
  }

  Future<void> _loadSources({String? query}) async {
    errorMessage = null;
    tenantMissing = false;
    try {
      // Always pull the full list via `GET /sources` and filter client-side via
      // [visibleSources].  The `GET /sources/{type}` endpoint is currently
      // unstable on the BE (returns 400/500 for some type strings); since the
      // list response already carries `type` per source, server-side filtering
      // brings no benefit and breaks the UX.
      final list = await _getSources(
        params: GetKnowledgeSourcesParams(query: query),
      );
      runInAction(() {
        sources = ObservableList.of(list);
      });
      _ensureLiveStatus();
    } catch (e) {
      runInAction(() {
        if (e is KnowledgeException &&
            e.code == KnowledgeErrorCode.tenantMissing) {
          tenantMissing = true;
          errorMessage = null;
        } else {
          errorMessage = _toMessage(e);
        }
      });
      rethrow;
    }
  }

  /// Re-fetches the current account from `/api/account/sso-validate` so the
  /// `tenantID` field is refreshed from BE, then re-runs `loadSources`.
  ///
  /// Use case: the logged-in account has no tenant yet because the admin
  /// assigned it after sign-in.  Calling this after the admin grants access
  /// pulls the new `tenantID` into local cache + headers without forcing the
  /// user to sign out.
  @action
  Future<void> refreshTenantFromAccount() async {
    final ok = await getIt<AuthStore>().refreshAccount();
    if (!ok) {
      // Refresh itself failed (network etc.) — keep the existing flag so the
      // empty state stays put, surface a hint via errorMessage.
      runInAction(() {
        errorMessage =
            'Không tải lại được hồ sơ tài khoản. Kiểm tra kết nối và thử lại.';
      });
      return;
    }
    runInAction(() {
      tenantMissing = false;
    });
    await loadSources();
  }

  @action
  void setTypeFilter(KnowledgeSourceType? type) {
    if (typeFilter == type) return;
    typeFilter = type;
    // No network round-trip — [visibleSources] filters in memory.
  }

  // ---------------------------------------------------------------------------
  // Per-source actions
  // ---------------------------------------------------------------------------

  @action
  Future<void> reindex(String id) async {
    await _withBusyId(id, () async {
      await _reindex(params: id);
      _patchSource(id, (s) => s.copyWith(
            status: KnowledgeSourceStatus.processing,
            updatedAt: DateTime.now(),
            clearErrorMessage: true,
          ));
      _ensureLiveStatus();
    });
  }

  @action
  Future<void> deleteSource(String id) async {
    await _withBusyId(id, () async {
      await _deleteSource(params: id);
      runInAction(() {
        sources.removeWhere((s) => s.id == id);
      });
    });
  }

  @action
  Future<void> updateInterval(String id, CrawlInterval interval) async {
    await _withBusyId(id, () async {
      await _updateInterval(
        params: UpdateSourceCrawlIntervalParams(id: id, interval: interval),
      );
      _patchSource(id, (s) => s.copyWith(interval: interval));
    });
  }

  @action
  Future<void> updateStatus(String id, KnowledgeSourceStatus status) async {
    await _withBusyId(id, () async {
      await _updateStatus(
        params: UpdateSourceStatusParams(id: id, status: status),
      );
      _patchSource(id, (s) => s.copyWith(status: status));
    });
  }

  @action
  Future<void> updateDatabaseQuery({
    required String id,
    required String query,
    required String uri,
  }) async {
    await _withBusyId(id, () async {
      await _updateDatabaseQuery(
        params: UpdateDatabaseQueryParams(id: id, query: query, uri: uri),
      );
      _patchSource(id, (s) {
        final cfg = Map<String, dynamic>.from(s.config);
        cfg['query'] = query;
        cfg['uri'] = uri;
        return s.copyWith(config: cfg);
      });
    });
  }

  // ---------------------------------------------------------------------------
  // Imports
  // ---------------------------------------------------------------------------

  @action
  Future<KnowledgeSource?> importWeb({
    required String url,
    required KnowledgeSourceType type,
    required CrawlInterval interval,
  }) async {
    return _withGlobalAction(() async {
      final s = await _importWeb(
        params: ImportWebSourceParams(url: url, type: type, interval: interval),
      );
      _addOrUpdate(s);
      _ensureLiveStatus();
      return s;
    });
  }

  @action
  Future<KnowledgeSource?> importLocalFile({
    required File file,
    required String fileName,
  }) async {
    uploadProgress = 0.0;
    return _withGlobalAction(() async {
      try {
        final s = await _importLocalFile(
          params: ImportLocalFileParams(
            file: file,
            fileName: fileName,
            onSendProgress: (sent, total) {
              if (total <= 0) return;
              runInAction(() {
                uploadProgress = (sent / total).clamp(0.0, 1.0);
              });
            },
          ),
        );
        _addOrUpdate(s);
        _ensureLiveStatus();
        return s;
      } finally {
        runInAction(() {
          uploadProgress = null;
        });
      }
    });
  }

  @action
  Future<KnowledgeSource?> importGoogleDrive({
    required String name,
    required List<String> includePaths,
    required String customerSupportId,
    required GoogleDriveCredentials credentials,
    required CrawlInterval interval,
  }) async {
    return _withGlobalAction(() async {
      final s = await _importGoogleDrive(
        params: ImportGoogleDriveParams(
          name: name,
          includePaths: includePaths,
          customerSupportId: customerSupportId,
          credentials: credentials,
          interval: interval,
        ),
      );
      _addOrUpdate(s);
      _ensureLiveStatus();
      return s;
    });
  }

  @action
  Future<KnowledgeSource?> importDatabaseQuery({
    required String name,
    required String query,
    required String uri,
    required CrawlInterval interval,
    DatabaseDialect dialect = DatabaseDialect.postgresql,
  }) async {
    return _withGlobalAction(() async {
      final s = await _importDatabaseQuery(
        params: ImportDatabaseQueryParams(
          name: name,
          query: query,
          uri: uri,
          interval: interval,
          dialect: dialect,
        ),
      );
      _addOrUpdate(s);
      _ensureLiveStatus();
      return s;
    });
  }

  // ---------------------------------------------------------------------------
  // Test DB connection
  // ---------------------------------------------------------------------------

  @action
  Future<void> testDatabaseQuery({
    required String query,
    required String uri,
  }) async {
    isTestingDb = true;
    dbTestError = null;
    lastDbPreview = null;
    try {
      lastDbPreview = await _testDatabaseQuery(
        params: TestDatabaseQueryParams(query: query, uri: uri),
      );
    } catch (e) {
      dbTestError = _toMessage(e);
    } finally {
      runInAction(() {
        isTestingDb = false;
      });
    }
  }

  @action
  void resetDbTest() {
    lastDbPreview = null;
    dbTestError = null;
  }

  // ---------------------------------------------------------------------------
  // Live status — SSE preferred, polling fallback
  // ---------------------------------------------------------------------------

  @action
  void startLiveStatus() {
    if (_sseSub != null || _pollTimer != null) return;
    _sseRetries = 0;
    _connectSse();
  }

  @action
  void stopLiveStatus() {
    _sseSub?.cancel();
    _sseSub = null;
    _pollTimer?.cancel();
    _pollTimer = null;
    liveStatusMode = LiveStatusMode.disconnected;
  }

  void _ensureLiveStatus() {
    // Open the live channel only when there's at least one source to track.
    if (sources.isEmpty) {
      stopLiveStatus();
      return;
    }
    if (_sseSub == null && _pollTimer == null) {
      _connectSse();
    } else if (_pollTimer != null && !hasInFlightSources) {
      // Once everything settles, stop the poller.
      _pollTimer?.cancel();
      _pollTimer = null;
      liveStatusMode = LiveStatusMode.disconnected;
    }
  }

  void _connectSse() {
    _sseSub = _watchStatuses().listen(
      (event) {
        runInAction(() {
          liveStatusMode = LiveStatusMode.connected;
          _sseRetries = 0;
          _applyStatusUpdates(event);
        });
      },
      onError: (Object e) {
        _sseSub?.cancel();
        _sseSub = null;
        _sseRetries++;
        if (_sseRetries <= _maxSseRetries) {
          // brief backoff before reconnect
          Future.delayed(Duration(seconds: _sseRetries * 2), () {
            if (sources.isNotEmpty) _connectSse();
          });
        } else {
          // SSE genuinely unavailable — fall back to polling.
          _startPolling();
        }
      },
      onDone: () {
        _sseSub = null;
        // If sources still in flight, keep things up to date via polling.
        if (hasInFlightSources) {
          _startPolling();
        } else {
          liveStatusMode = LiveStatusMode.disconnected;
        }
      },
      cancelOnError: false,
    );
  }

  void _startPolling() {
    _pollTimer?.cancel();
    runInAction(() {
      liveStatusMode = LiveStatusMode.polling;
    });
    _pollTimer = Timer.periodic(_pollInterval, (_) async {
      final inFlight = sources
          .where((s) => s.status.isInFlight)
          .map((s) => s.id)
          .toList();
      if (inFlight.isEmpty) {
        _pollTimer?.cancel();
        _pollTimer = null;
        runInAction(() => liveStatusMode = LiveStatusMode.disconnected);
        return;
      }
      try {
        final result = await _pollStatus(params: inFlight);
        runInAction(() => _applyStatusUpdates(result));
      } catch (_) {
        // transient — keep trying on next tick
      }
    });
  }

  void _applyStatusUpdates(Map<String, KnowledgeSourceStatus> updates) {
    if (updates.isEmpty) return;
    for (final entry in updates.entries) {
      final idx = sources.indexWhere((s) => s.id == entry.key);
      if (idx == -1) continue;
      final current = sources[idx];
      if (current.status == entry.value) continue;
      sources[idx] = current.copyWith(
        status: entry.value,
        updatedAt: DateTime.now(),
        clearErrorMessage: entry.value != KnowledgeSourceStatus.failed,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<T> _withGlobalAction<T>(Future<T> Function() body) async {
    errorMessage = null;
    try {
      return await body();
    } catch (e) {
      runInAction(() {
        errorMessage = _toMessage(e);
      });
      rethrow;
    }
  }

  Future<void> _withBusyId(String id, Future<void> Function() body) async {
    if (busySourceIds.contains(id)) return;
    errorMessage = null;
    busySourceIds.add(id);
    try {
      await body();
    } catch (e) {
      runInAction(() {
        errorMessage = _toMessage(e);
      });
    } finally {
      runInAction(() {
        busySourceIds.remove(id);
      });
    }
  }

  void _patchSource(
    String id,
    KnowledgeSource Function(KnowledgeSource) patch,
  ) {
    runInAction(() {
      final i = sources.indexWhere((s) => s.id == id);
      if (i != -1) sources[i] = patch(sources[i]);
    });
  }

  void _addOrUpdate(KnowledgeSource s) {
    runInAction(() {
      final i = sources.indexWhere((x) => x.id == s.id);
      if (i == -1) {
        sources.insert(0, s);
      } else {
        sources[i] = s;
      }
    });
  }

  String _toMessage(Object e) {
    if (e is KnowledgeException) return e.message;
    return e.toString();
  }

  void dispose() {
    stopLiveStatus();
  }
}
