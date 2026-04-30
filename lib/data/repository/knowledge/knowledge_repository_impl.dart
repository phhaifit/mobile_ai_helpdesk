import 'dart:io';

import 'package:ai_helpdesk/data/local/auth/auth_local_datasource.dart';
import 'package:ai_helpdesk/data/network/apis/knowledge/knowledge_api.dart';
import 'package:ai_helpdesk/data/repository/knowledge/mock_knowledge_repository_impl.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';
import 'package:path/path.dart' as p;

class KnowledgeRepositoryImpl implements KnowledgeRepository {
  final KnowledgeApi _api;
  final AuthLocalDatasource _auth;
  final MockKnowledgeRepositoryImpl _mock;

  KnowledgeRepositoryImpl(this._api, this._auth)
      : _mock = MockKnowledgeRepositoryImpl();

  @override
  Future<KnowledgeSource> uploadLocalFile(File file) async {
    final tenantId = await _auth.getTenantId();
    if (tenantId == null || tenantId.isEmpty) {
      throw Exception('Tenant ID not found — please log in again');
    }

    final result = await _api.importLocalFile(tenantId, file);

    final sourceId =
        result['id'] as String? ??
        result['sourceId'] as String? ??
        result['source_id'] as String? ??
        '';

    if (sourceId.isNotEmpty) {
      await _pollUntilActive(sourceId);
    }

    return KnowledgeSource(
      id: sourceId,
      name: p.basename(file.path),
      type: KnowledgeSourceType.localFile,
      status: KnowledgeSourceStatus.active,
      lastSyncAt: DateTime.now(),
      crawlInterval: CrawlInterval.manual,
      config: <String, dynamic>{'fileName': p.basename(file.path)},
    );
  }

  Future<void> _pollUntilActive(String sourceId) async {
    for (int i = 0; i < 15; i++) {
      await Future.delayed(const Duration(seconds: 3));
      try {
        final status = await _api.pollSourceStatus(<String>[sourceId]);
        final list =
            status['statuses'] as List<dynamic>? ??
            status['data'] as List<dynamic>? ??
            <dynamic>[];
        for (final item in list) {
          if (item is Map && item['id'] == sourceId) {
            final st = item['status'] as String? ?? '';
            if (st == 'active' || st == 'completed' || st == 'done') return;
            if (st == 'error' || st == 'failed') {
              throw Exception('File processing failed');
            }
          }
        }
      } catch (e) {
        if (e.toString().contains('processing failed')) rethrow;
      }
    }
  }

  // Delegate remaining methods to mock
  @override
  Future<List<KnowledgeSource>> getSources() => _mock.getSources();

  @override
  Future<KnowledgeSource> addSource(KnowledgeSource source) =>
      _mock.addSource(source);

  @override
  Future<KnowledgeSource> updateSourceCrawlInterval(
    String id,
    CrawlInterval crawlInterval,
  ) => _mock.updateSourceCrawlInterval(id, crawlInterval);

  @override
  Future<void> deleteSource(String id) => _mock.deleteSource(id);

  @override
  Future<KnowledgeSource> reindexSource(String id) =>
      _mock.reindexSource(id);

  @override
  Future<bool> testDbConnection(Map<String, dynamic> connectionConfig) =>
      _mock.testDbConnection(connectionConfig);
}
