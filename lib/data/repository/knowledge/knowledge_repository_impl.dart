import 'package:ai_helpdesk/data/network/apis/knowledge/knowledge_api.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';
import 'package:ai_helpdesk/presentation/tenant/store/tenant_store.dart';

/// Real implementation of [KnowledgeRepository].
///
/// Sub-task A implements:
///   - getSources, deleteSource, reindexSource, updateSourceCrawlInterval,
///     addSource (web types), watchSourceStatuses.
///
/// Sub-task B will fill in:
///   - addSource for localFile / googleDrive / postgresql / sqlServer.
///   - testDbConnection.
class KnowledgeRepositoryImpl implements KnowledgeRepository {
  final KnowledgeApi _api;

  KnowledgeRepositoryImpl(this._api);

  /// Resolves the active tenant ID at call time (lazy — avoids DI ordering issues).
  String get _tenantId =>
      getIt<TenantStore>().currentTenant?.id ?? '';

  // ---------------------------------------------------------------------------
  // getSources
  // ---------------------------------------------------------------------------

  @override
  Future<List<KnowledgeSource>> getSources() async {
    final rawList = await _api.getSources(_tenantId);
    return rawList.map(_mapSourceFromApi).toList();
  }

  // ---------------------------------------------------------------------------
  // getSourcesByCategory — maps UI category → one or more API type strings
  // ---------------------------------------------------------------------------

  @override
  Future<List<KnowledgeSource>> getSourcesByCategory(String category) async {
    switch (category) {
      case 'web':
        // Web covers both single_url ('web') and whole_site.
        final results = await Future.wait([
          _api.getSourcesByType(_tenantId, 'web'),
          _api.getSourcesByType(_tenantId, 'whole_site'),
        ]);
        return [...results[0], ...results[1]].map(_mapSourceFromApi).toList();
      case 'file':
        final raw = await _api.getSourcesByType(_tenantId, 'local_file');
        return raw.map(_mapSourceFromApi).toList();
      case 'drive':
        final raw = await _api.getSourcesByType(_tenantId, 'google_drive');
        return raw.map(_mapSourceFromApi).toList();
      case 'db':
        final raw = await _api.getSourcesByType(_tenantId, 'database_query');
        return raw.map(_mapSourceFromApi).toList();
      default:
        return getSources();
    }
  }

  // ---------------------------------------------------------------------------
  // updateSourceStatus
  // ---------------------------------------------------------------------------

  @override
  Future<KnowledgeSource> updateSourceStatus(
    String id,
    KnowledgeSourceStatus status,
  ) async {
    await _api.updateSourceStatus(_tenantId, id, status.toApiStatus());
    // API returns no body — refresh from list to get the updated entity.
    final sources = await getSources();
    return sources.firstWhere(
      (s) => s.id == id,
      orElse: () => KnowledgeSource(
        id: id,
        name: '',
        type: KnowledgeSourceType.webSingle,
        status: status,
        lastSyncAt: DateTime.now(),
        crawlInterval: CrawlInterval.manual,
        config: const {},
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // addSource — Sub-task A handles web types only
  // ---------------------------------------------------------------------------

  @override
  Future<KnowledgeSource> addSource(KnowledgeSource source) async {
    switch (source.type) {
      case KnowledgeSourceType.webSingle:
      case KnowledgeSourceType.webFull:
        return _importWeb(source);

      // Sub-task B will replace these stubs.
      case KnowledgeSourceType.localFile:
      case KnowledgeSourceType.googleDrive:
      case KnowledgeSourceType.postgresql:
      case KnowledgeSourceType.sqlServer:
        throw UnimplementedError(
          'addSource for ${source.type} is handled by Sub-task B.',
        );
    }
  }

  Future<KnowledgeSource> _importWeb(KnowledgeSource source) async {
    final url = source.config['url'] as String? ?? '';
    final importType = source.type.toApiImportType(); // 'single_url' | 'whole_site'
    final apiInterval = source.crawlInterval.toApiInterval();

    final responseJson = await _api.importWeb(
      tenantId: _tenantId,
      webUrl: url,
      apiInterval: apiInterval,
      importType: importType,
    );

    // The API may return the created source or just an ack — handle both.
    if (responseJson.containsKey('id')) {
      return _mapSourceFromApi(responseJson);
    }

    // Fallback: construct optimistic entity with indexing status.
    return source.copyWith(
      id: responseJson['id'] as String? ?? 'pending-${DateTime.now().millisecondsSinceEpoch}',
      status: KnowledgeSourceStatus.indexing,
      lastSyncAt: DateTime.now(),
    );
  }

  // ---------------------------------------------------------------------------
  // deleteSource
  // ---------------------------------------------------------------------------

  @override
  Future<void> deleteSource(String id) async {
    await _api.deleteSource(_tenantId, id);
  }

  // ---------------------------------------------------------------------------
  // reindexSource
  // ---------------------------------------------------------------------------

  @override
  Future<KnowledgeSource> reindexSource(String id) async {
    await _api.reindexSource(_tenantId, id);
    // API returns no body — fetch the updated source from the list.
    final sources = await getSources();
    return sources.firstWhere(
      (s) => s.id == id,
      // Fallback: return a stub with indexing status so the UI updates immediately.
      orElse: () => KnowledgeSource(
        id: id,
        name: '',
        type: KnowledgeSourceType.webSingle,
        status: KnowledgeSourceStatus.indexing,
        lastSyncAt: DateTime.now(),
        crawlInterval: CrawlInterval.manual,
        config: const {},
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // updateSourceCrawlInterval
  // ---------------------------------------------------------------------------

  @override
  Future<KnowledgeSource> updateSourceCrawlInterval(
    String id,
    CrawlInterval crawlInterval,
  ) async {
    await _api.updateInterval(_tenantId, id, crawlInterval.toApiInterval());

    // API returns no body — rebuild the source from the current list.
    final sources = await getSources();
    final existing = sources.firstWhere(
      (s) => s.id == id,
      orElse: () => KnowledgeSource(
        id: id,
        name: '',
        type: KnowledgeSourceType.webSingle,
        status: KnowledgeSourceStatus.active,
        lastSyncAt: DateTime.now(),
        crawlInterval: crawlInterval,
        config: const {},
      ),
    );
    return existing.copyWith(crawlInterval: crawlInterval);
  }

  // ---------------------------------------------------------------------------
  // testDbConnection — Sub-task B
  // ---------------------------------------------------------------------------

  @override
  Future<bool> testDbConnection(Map<String, dynamic> connectionConfig) {
    throw UnimplementedError(
      'testDbConnection is handled by Sub-task B.',
    );
  }

  // ---------------------------------------------------------------------------
  // watchSourceStatuses (SSE)
  // ---------------------------------------------------------------------------

  @override
  Stream<Map<String, KnowledgeSourceStatus>> watchSourceStatuses() {
    return _api.statusSseStream(_tenantId);
  }

  // ---------------------------------------------------------------------------
  // Internal mapping: API JSON → domain KnowledgeSource
  // ---------------------------------------------------------------------------

  KnowledgeSource _mapSourceFromApi(Map<String, dynamic> json) {
    final apiType = json['type'] as String? ?? 'web';
    final apiStatus = json['status'] as String? ?? 'pending';
    final apiInterval = json['interval'] as String? ?? 'ONCE';

    // Use updatedAt as lastSyncAt; fallback to createdAt.
    final syncRaw = json['updatedAt'] as String? ?? json['createdAt'] as String?;
    final lastSyncAt = syncRaw != null ? DateTime.parse(syncRaw) : DateTime.now();

    return KnowledgeSource(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: apiType.toKnowledgeSourceType(),
      status: apiStatus.toKnowledgeSourceStatus(),
      lastSyncAt: lastSyncAt,
      crawlInterval: apiInterval.toCrawlInterval(),
      config: const {}, // List API does not return source config details.
    );
  }
}
