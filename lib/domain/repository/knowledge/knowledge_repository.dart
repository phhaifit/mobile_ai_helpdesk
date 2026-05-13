import 'dart:io';

import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';

/// Result of a successful database connection test.
class DatabaseQueryPreview {
  /// Sample rows returned by the test query (first N).  Empty if BE only
  /// reports success without echoing rows.
  final List<Map<String, dynamic>> rows;

  /// Column names in the order they were returned, when available.
  final List<String> columns;

  /// Optional message from the backend (e.g. "Connection succeeded — 5 rows").
  final String? message;

  const DatabaseQueryPreview({
    required this.rows,
    required this.columns,
    this.message,
  });
}

/// OAuth credentials passed to the Google Drive import endpoint.
///
/// The backend treats this as an opaque object — we forward whatever the OAuth
/// flow yielded (access token, refresh token, expiry, scopes, …).
class GoogleDriveCredentials {
  final Map<String, dynamic> raw;
  const GoogleDriveCredentials(this.raw);
}

/// Knowledge Base contract.  Implementations must surface DioExceptions as
/// thrown errors with a user-friendly message — no `Either<Failure, T>`
/// pattern here for now (callers handle try/catch in stores).
abstract class KnowledgeRepository {
  // ---------------------------------------------------------------------------
  // Read
  // ---------------------------------------------------------------------------

  /// `GET /sources` — full list, optionally filtered by ids/query.
  Future<List<KnowledgeSource>> getSources({
    List<String>? ids,
    String? query,
  });

  /// `GET /sources/{type}` — server-side filter by source type.
  Future<List<KnowledgeSource>> getSourcesByType(KnowledgeSourceType type);

  /// `POST /sources/poll-status` — batch status snapshot for the given ids.
  Future<Map<String, KnowledgeSourceStatus>> pollSourceStatus(
    List<String> ids,
  );

  /// `GET /status-sse` — live status stream.  Implementations that don't
  /// support SSE should return [Stream.empty].
  Stream<Map<String, KnowledgeSourceStatus>> watchSourceStatuses();

  // ---------------------------------------------------------------------------
  // Mutate (status / interval / delete / reindex)
  // ---------------------------------------------------------------------------

  /// `PATCH /sources/{sourceId}` — manually sets the processing status.
  Future<void> updateSourceStatus(String id, KnowledgeSourceStatus status);

  /// `PATCH /sources/{sourceId}/interval` — change scheduled re-sync frequency.
  Future<void> updateSourceInterval(String id, CrawlInterval interval);

  /// `DELETE /sources/{sourceId}` — permanent.
  Future<void> deleteSource(String id);

  /// `POST /sources/{sourceId}/reindex` — trigger a manual reindex job.
  Future<void> reindexSource(String id);

  // ---------------------------------------------------------------------------
  // Imports
  // ---------------------------------------------------------------------------

  /// `POST /web` — import a single URL or whole site.
  ///
  /// [type] must be either [KnowledgeSourceType.web] (single page) or
  /// [KnowledgeSourceType.wholeSite] (entire domain).
  Future<KnowledgeSource> importWebSource({
    required String url,
    required KnowledgeSourceType type,
    required CrawlInterval interval,
  });

  /// `POST /local-file` — multipart upload.  [onSendProgress] reports
  /// upload progress in bytes.
  Future<KnowledgeSource> importLocalFile({
    required File file,
    required String fileName,
    void Function(int sent, int total)? onSendProgress,
  });

  /// `POST /google-drive` — import from Drive folders/files using the OAuth
  /// credentials produced by an in-app sign-in flow.
  Future<KnowledgeSource> importGoogleDrive({
    required String name,
    required List<String> includePaths,
    required String customerSupportId,
    required GoogleDriveCredentials credentials,
    required CrawlInterval interval,
  });

  /// `POST /database-query` — import from a SQL query.
  Future<KnowledgeSource> importDatabaseQuery({
    required String name,
    required String query,
    required String uri,
    required CrawlInterval interval,
    DatabaseDialect dialect = DatabaseDialect.postgresql,
  });

  /// `PATCH /database-query/{sourceId}` — update query/uri of an existing source.
  Future<void> updateDatabaseQuery({
    required String id,
    required String query,
    required String uri,
  });

  /// `POST /test-database-query` — validate URI + preview query result.
  Future<DatabaseQueryPreview> testDatabaseQuery({
    required String query,
    required String uri,
  });
}
