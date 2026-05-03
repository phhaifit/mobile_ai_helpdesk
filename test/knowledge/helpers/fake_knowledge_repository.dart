import 'dart:io';

import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

/// Configurable fake used by use-case tests.
class FakeKnowledgeRepository implements KnowledgeRepository {
  List<KnowledgeSource> sourcesToReturn = [];
  Map<String, KnowledgeSourceStatus> pollResult = {};
  DatabaseQueryPreview testDatabaseQueryResult =
      const DatabaseQueryPreview(rows: [], columns: []);
  KnowledgeSource? importResult;
  Stream<Map<String, KnowledgeSourceStatus>> sseStream = const Stream.empty();

  // captured args
  String? capturedDeleteId;
  String? capturedReindexId;
  String? capturedUpdateIntervalId;
  CrawlInterval? capturedUpdateInterval;
  String? capturedUpdateStatusId;
  KnowledgeSourceStatus? capturedUpdateStatus;
  KnowledgeSourceType? capturedTypeFilter;
  List<String>? capturedPollIds;
  Map<String, dynamic>? capturedImportWebArgs;
  Map<String, dynamic>? capturedImportLocalFileArgs;
  Map<String, dynamic>? capturedImportGoogleDriveArgs;
  Map<String, dynamic>? capturedImportDatabaseQueryArgs;
  Map<String, dynamic>? capturedUpdateDatabaseQueryArgs;
  Map<String, dynamic>? capturedTestDatabaseQueryArgs;
  List<String>? capturedGetSourcesIds;
  String? capturedGetSourcesQuery;

  @override
  Future<List<KnowledgeSource>> getSources({
    List<String>? ids,
    String? query,
  }) async {
    capturedGetSourcesIds = ids;
    capturedGetSourcesQuery = query;
    return sourcesToReturn;
  }

  @override
  Future<List<KnowledgeSource>> getSourcesByType(
    KnowledgeSourceType type,
  ) async {
    capturedTypeFilter = type;
    return sourcesToReturn.where((s) => s.type == type).toList();
  }

  @override
  Future<Map<String, KnowledgeSourceStatus>> pollSourceStatus(
    List<String> ids,
  ) async {
    capturedPollIds = ids;
    return pollResult;
  }

  @override
  Stream<Map<String, KnowledgeSourceStatus>> watchSourceStatuses() => sseStream;

  @override
  Future<void> deleteSource(String id) async {
    capturedDeleteId = id;
  }

  @override
  Future<void> reindexSource(String id) async {
    capturedReindexId = id;
  }

  @override
  Future<void> updateSourceInterval(
    String id,
    CrawlInterval interval,
  ) async {
    capturedUpdateIntervalId = id;
    capturedUpdateInterval = interval;
  }

  @override
  Future<void> updateSourceStatus(
    String id,
    KnowledgeSourceStatus status,
  ) async {
    capturedUpdateStatusId = id;
    capturedUpdateStatus = status;
  }

  @override
  Future<KnowledgeSource> importWebSource({
    required String url,
    required KnowledgeSourceType type,
    required CrawlInterval interval,
  }) async {
    capturedImportWebArgs = {
      'url': url,
      'type': type,
      'interval': interval,
    };
    return importResult ?? _stub(type, interval);
  }

  @override
  Future<KnowledgeSource> importLocalFile({
    required File file,
    required String fileName,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    capturedImportLocalFileArgs = {
      'fileName': fileName,
      'path': file.path,
    };
    onSendProgress?.call(100, 100);
    return importResult ??
        _stub(KnowledgeSourceType.localFile, CrawlInterval.once);
  }

  @override
  Future<KnowledgeSource> importGoogleDrive({
    required String name,
    required List<String> includePaths,
    required String customerSupportId,
    required GoogleDriveCredentials credentials,
    required CrawlInterval interval,
  }) async {
    capturedImportGoogleDriveArgs = {
      'name': name,
      'includePaths': includePaths,
      'customerSupportId': customerSupportId,
      'credentials': credentials.raw,
      'interval': interval,
    };
    return importResult ??
        _stub(KnowledgeSourceType.googleDrive, interval);
  }

  @override
  Future<KnowledgeSource> importDatabaseQuery({
    required String name,
    required String query,
    required String uri,
    required CrawlInterval interval,
    DatabaseDialect dialect = DatabaseDialect.postgresql,
  }) async {
    capturedImportDatabaseQueryArgs = {
      'name': name,
      'query': query,
      'uri': uri,
      'interval': interval,
      'dialect': dialect,
    };
    return importResult ??
        _stub(KnowledgeSourceType.databaseQuery, interval);
  }

  @override
  Future<void> updateDatabaseQuery({
    required String id,
    required String query,
    required String uri,
  }) async {
    capturedUpdateDatabaseQueryArgs = {
      'id': id,
      'query': query,
      'uri': uri,
    };
  }

  @override
  Future<DatabaseQueryPreview> testDatabaseQuery({
    required String query,
    required String uri,
  }) async {
    capturedTestDatabaseQueryArgs = {'query': query, 'uri': uri};
    return testDatabaseQueryResult;
  }

  KnowledgeSource _stub(KnowledgeSourceType type, CrawlInterval interval) {
    final now = DateTime(2026, 1, 1);
    return KnowledgeSource(
      id: 'stub',
      name: 'stub',
      type: type,
      status: KnowledgeSourceStatus.pending,
      interval: interval,
      createdAt: now,
      updatedAt: now,
    );
  }
}
