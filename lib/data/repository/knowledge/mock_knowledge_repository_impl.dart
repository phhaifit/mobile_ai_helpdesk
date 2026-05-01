import 'dart:async';
import 'dart:io';

import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

/// In-memory mock for offline development / unit tests.
class MockKnowledgeRepositoryImpl implements KnowledgeRepository {
  final List<KnowledgeSource> _sources;

  MockKnowledgeRepositoryImpl() : _sources = _seed();

  static List<KnowledgeSource> _seed() {
    final now = DateTime.now();
    return [
      KnowledgeSource(
        id: 'KS-001',
        name: 'Trang chủ Jarvis',
        type: KnowledgeSourceType.wholeSite,
        status: KnowledgeSourceStatus.completed,
        interval: CrawlInterval.daily,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(hours: 4)),
        config: const {'url': 'https://jarvis.cx'},
      ),
      KnowledgeSource(
        id: 'KS-002',
        name: 'FAQ sản phẩm.docx',
        type: KnowledgeSourceType.localFile,
        status: KnowledgeSourceStatus.processing,
        interval: CrawlInterval.once,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now,
        progress: 0.45,
        config: const {'fileName': 'FAQ sản phẩm.docx', 'fileSize': 204800},
      ),
      KnowledgeSource(
        id: 'KS-003',
        name: 'Chính sách bảo hành',
        type: KnowledgeSourceType.web,
        status: KnowledgeSourceStatus.completed,
        interval: CrawlInterval.weekly,
        createdAt: now.subtract(const Duration(days: 14)),
        updatedAt: now.subtract(const Duration(hours: 22)),
        config: const {'url': 'https://jarvis.cx/warranty'},
      ),
      KnowledgeSource(
        id: 'KS-004',
        name: 'Tài liệu nội bộ Drive',
        type: KnowledgeSourceType.googleDrive,
        status: KnowledgeSourceStatus.failed,
        interval: CrawlInterval.daily,
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        errorMessage: 'Token hết hạn — cần đăng nhập lại Google Drive.',
        config: const {
          'includePaths': ['/Reports/2024', '/Docs/FAQ'],
        },
      ),
      KnowledgeSource(
        id: 'KS-005',
        name: 'Database khách hàng',
        type: KnowledgeSourceType.databaseQuery,
        status: KnowledgeSourceStatus.completed,
        interval: CrawlInterval.daily,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(hours: 6)),
        config: const {
          'uri': 'postgresql://readonly@db.jarvis.cx:5432/helpdesk_prod',
          'query': 'SELECT id, title FROM faq',
          'dialect': 'postgresql',
        },
      ),
    ];
  }

  @override
  Future<List<KnowledgeSource>> getSources({
    List<String>? ids,
    String? query,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return _sources
        .where((s) =>
            (ids == null || ids.contains(s.id)) &&
            (query == null ||
                s.name.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }

  @override
  Future<List<KnowledgeSource>> getSourcesByType(
    KnowledgeSourceType type,
  ) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _sources.where((s) => s.type == type).toList();
  }

  @override
  Future<Map<String, KnowledgeSourceStatus>> pollSourceStatus(
    List<String> ids,
  ) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return {
      for (final s in _sources.where((s) => ids.contains(s.id)))
        s.id: s.status,
    };
  }

  @override
  Stream<Map<String, KnowledgeSourceStatus>> watchSourceStatuses() =>
      const Stream.empty();

  @override
  Future<void> updateSourceStatus(
    String id,
    KnowledgeSourceStatus status,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final i = _sources.indexWhere((s) => s.id == id);
    if (i == -1) throw Exception('Source not found');
    _sources[i] = _sources[i].copyWith(status: status, updatedAt: DateTime.now());
  }

  @override
  Future<void> updateSourceInterval(String id, CrawlInterval interval) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final i = _sources.indexWhere((s) => s.id == id);
    if (i == -1) throw Exception('Source not found');
    _sources[i] =
        _sources[i].copyWith(interval: interval, updatedAt: DateTime.now());
  }

  @override
  Future<void> deleteSource(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _sources.removeWhere((s) => s.id == id);
  }

  @override
  Future<void> reindexSource(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final i = _sources.indexWhere((s) => s.id == id);
    if (i == -1) throw Exception('Source not found');
    _sources[i] = _sources[i].copyWith(
      status: KnowledgeSourceStatus.processing,
      updatedAt: DateTime.now(),
      clearErrorMessage: true,
    );
  }

  @override
  Future<KnowledgeSource> importWebSource({
    required String url,
    required KnowledgeSourceType type,
    required CrawlInterval interval,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final s = _make(name: url, type: type, interval: interval, config: {
      'url': url,
    });
    _sources.add(s);
    return s;
  }

  @override
  Future<KnowledgeSource> importLocalFile({
    required File file,
    required String fileName,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final size = await file.length();
    onSendProgress?.call(size, size);
    final s = _make(
      name: fileName,
      type: KnowledgeSourceType.localFile,
      interval: CrawlInterval.once,
      config: {'fileName': fileName, 'fileSize': size},
    );
    _sources.add(s);
    return s;
  }

  @override
  Future<KnowledgeSource> importGoogleDrive({
    required String name,
    required List<String> includePaths,
    required String customerSupportId,
    required GoogleDriveCredentials credentials,
    required CrawlInterval interval,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final s = _make(
      name: name,
      type: KnowledgeSourceType.googleDrive,
      interval: interval,
      config: {'includePaths': includePaths},
    );
    _sources.add(s);
    return s;
  }

  @override
  Future<KnowledgeSource> importDatabaseQuery({
    required String name,
    required String query,
    required String uri,
    required CrawlInterval interval,
    DatabaseDialect dialect = DatabaseDialect.postgresql,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final s = _make(
      name: name,
      type: KnowledgeSourceType.databaseQuery,
      interval: interval,
      config: {'query': query, 'uri': uri, 'dialect': dialect.name},
    );
    _sources.add(s);
    return s;
  }

  @override
  Future<void> updateDatabaseQuery({
    required String id,
    required String query,
    required String uri,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final i = _sources.indexWhere((s) => s.id == id);
    if (i == -1) throw Exception('Source not found');
    final cfg = Map<String, dynamic>.from(_sources[i].config);
    cfg['query'] = query;
    cfg['uri'] = uri;
    _sources[i] = _sources[i].copyWith(config: cfg, updatedAt: DateTime.now());
  }

  @override
  Future<DatabaseQueryPreview> testDatabaseQuery({
    required String query,
    required String uri,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (uri.isEmpty || !uri.contains('://')) {
      throw Exception('URI không hợp lệ.');
    }
    return const DatabaseQueryPreview(
      rows: [
        {'id': 1, 'title': 'Sample row 1'},
        {'id': 2, 'title': 'Sample row 2'},
      ],
      columns: ['id', 'title'],
      message: 'Connection succeeded — preview shows 2 rows.',
    );
  }

  KnowledgeSource _make({
    required String name,
    required KnowledgeSourceType type,
    required CrawlInterval interval,
    required Map<String, dynamic> config,
  }) {
    final now = DateTime.now();
    return KnowledgeSource(
      id: 'KS-${(_sources.length + 1).toString().padLeft(3, '0')}',
      name: name,
      type: type,
      status: KnowledgeSourceStatus.processing,
      interval: interval,
      createdAt: now,
      updatedAt: now,
      config: config,
    );
  }
}
