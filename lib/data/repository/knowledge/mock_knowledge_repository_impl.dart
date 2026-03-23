import 'dart:async';

import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class MockKnowledgeRepositoryImpl implements KnowledgeRepository {
  final List<KnowledgeSource> _sources = [
    KnowledgeSource(
      id: 'KS-001',
      name: 'Trang chủ Jarvis',
      type: KnowledgeSourceType.webFull,
      status: KnowledgeSourceStatus.active,
      lastSyncAt: DateTime(2026, 3, 23, 11, 11, 25),
      crawlInterval: CrawlInterval.daily,
      config: {'url': 'https://jarvis.cx', 'fullSite': true},
    ),
    KnowledgeSource(
      id: 'KS-002',
      name: 'FAQ sản phẩm.docx',
      type: KnowledgeSourceType.localFile,
      status: KnowledgeSourceStatus.indexing,
      lastSyncAt: DateTime(2026, 3, 23, 11, 11, 25),
      crawlInterval: CrawlInterval.manual,
      config: {'fileName': 'FAQ sản phẩm.docx', 'fileSize': 204800},
    ),
    KnowledgeSource(
      id: 'KS-003',
      name: 'Chính sách bảo hành',
      type: KnowledgeSourceType.webSingle,
      status: KnowledgeSourceStatus.active,
      lastSyncAt: DateTime(2026, 3, 22, 8, 30),
      crawlInterval: CrawlInterval.weekly,
      config: {'url': 'https://jarvis.cx/warranty', 'fullSite': false},
    ),
    KnowledgeSource(
      id: 'KS-004',
      name: 'Tài liệu nội bộ Drive',
      type: KnowledgeSourceType.googleDrive,
      status: KnowledgeSourceStatus.error,
      lastSyncAt: DateTime(2026, 3, 20, 14, 0),
      crawlInterval: CrawlInterval.hourly,
      config: {'folderId': '1abc_drive_folder_id', 'folderName': 'Helpdesk Docs'},
    ),
    KnowledgeSource(
      id: 'KS-005',
      name: 'Database khách hàng',
      type: KnowledgeSourceType.postgresql,
      status: KnowledgeSourceStatus.active,
      lastSyncAt: DateTime(2026, 3, 21, 6, 0),
      crawlInterval: CrawlInterval.daily,
      config: {
        'host': 'db.jarvis.cx',
        'port': '5432',
        'database': 'helpdesk_prod',
        'username': 'readonly_user',
      },
    ),
  ];

  @override
  Future<List<KnowledgeSource>> getSources() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_sources);
  }

  @override
  Future<KnowledgeSource> addSource(KnowledgeSource source) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final newSource = source.copyWith(
      id: 'KS-${(_sources.length + 1).toString().padLeft(3, '0')}',
      status: KnowledgeSourceStatus.indexing,
      lastSyncAt: DateTime.now(),
    );
    _sources.add(newSource);
    return newSource;
  }

  @override
  Future<void> deleteSource(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _sources.removeWhere((s) => s.id == id);
  }

  @override
  Future<KnowledgeSource> reindexSource(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _sources.indexWhere((s) => s.id == id);
    if (index == -1) throw Exception('Source not found');
    final updated = _sources[index].copyWith(
      status: KnowledgeSourceStatus.indexing,
      lastSyncAt: DateTime.now(),
    );
    _sources[index] = updated;
    return updated;
  }

  @override
  Future<bool> testDbConnection(Map<String, dynamic> connectionConfig) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock: returns success if host is non-empty
    final host = connectionConfig['host'] as String? ?? '';
    return host.isNotEmpty;
  }
}
