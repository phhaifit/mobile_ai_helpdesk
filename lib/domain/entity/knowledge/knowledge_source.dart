import 'package:json_annotation/json_annotation.dart';

part 'knowledge_source.g.dart';

/// Source type — mirrors the backend `type` enum 1:1.
///
/// Backend values for `GET /sources/{type}` (path param) and the `type` field
/// returned in list responses:
///   `web` | `whole_site` | `local_file` | `google_drive` | `database_query`
///
/// `POST /web` uses a different vocabulary for its body's `type` field
/// (`single_page` for a single URL, `whole_sites` for a full crawl) — see
/// [KnowledgeSourceTypeApiX.toWebImportType].
enum KnowledgeSourceType { web, wholeSite, localFile, googleDrive, databaseQuery }

/// Processing status — mirrors the backend `status` enum 1:1.
enum KnowledgeSourceStatus { pending, processing, completed, failed }

/// Sync interval — mirrors the backend `interval` enum 1:1.
enum CrawlInterval { once, daily, weekly, monthly }

/// Database dialect for `databaseQuery` sources.  Stored in [KnowledgeSource.config]
/// under the key `dialect`.  Used purely client-side to render the connection
/// form correctly — backend distinguishes by URI scheme (`postgresql://` vs `sqlserver://`).
enum DatabaseDialect { postgresql, sqlServer }

// ---------------------------------------------------------------------------
// API ↔ Domain mapping
// ---------------------------------------------------------------------------

extension KnowledgeSourceTypeApiX on KnowledgeSourceType {
  /// Path segment for `GET /sources/{type}`.
  ///
  /// Verified live against the BE: the AI-service expects **kebab-case** and
  /// uses the singular `file` rather than `local_file`. Snake-case variants
  /// return HTTP 500.
  ///
  /// Note: `wholeSite` is not listable separately — the BE folds it into
  /// `web` for listing. The value below is best-effort kebab-case but
  /// callers should avoid filtering by `wholeSite`.
  String toApiType() {
    switch (this) {
      case KnowledgeSourceType.web:
        return 'web';
      case KnowledgeSourceType.wholeSite:
        return 'whole-site';
      case KnowledgeSourceType.localFile:
        return 'file';
      case KnowledgeSourceType.googleDrive:
        return 'google-drive';
      case KnowledgeSourceType.databaseQuery:
        return 'database-query';
    }
  }

  /// Used for the body field `type` of `POST /web` (`single_page`|`whole_sites`).
  /// Distinct from [toApiType] — the BE deliberately uses a different
  /// vocabulary for the import endpoint than for the list/path endpoints.
  String toWebImportType() {
    if (this == KnowledgeSourceType.wholeSite) return 'whole_sites';
    return 'single_page';
  }
}

KnowledgeSourceType knowledgeSourceTypeFromApi(String? raw) {
  switch (raw) {
    case 'web':
    case 'single_page':
    case 'single_url': // legacy spelling, kept for backward compat
      return KnowledgeSourceType.web;
    case 'whole_site':
    case 'whole-site':
    case 'whole_sites': // POST /web body spelling
      return KnowledgeSourceType.wholeSite;
    case 'local_file':
    case 'local-file':
    case 'file':
      return KnowledgeSourceType.localFile;
    case 'google_drive':
    case 'google-drive':
    case 'drive':
      return KnowledgeSourceType.googleDrive;
    case 'database_query':
    case 'database-query':
    case 'database':
      return KnowledgeSourceType.databaseQuery;
    default:
      return KnowledgeSourceType.web;
  }
}

extension KnowledgeSourceStatusApiX on KnowledgeSourceStatus {
  String toApiStatus() {
    switch (this) {
      case KnowledgeSourceStatus.pending:
        return 'pending';
      case KnowledgeSourceStatus.processing:
        return 'processing';
      case KnowledgeSourceStatus.completed:
        return 'completed';
      case KnowledgeSourceStatus.failed:
        return 'failed';
    }
  }

  bool get isInFlight =>
      this == KnowledgeSourceStatus.pending ||
      this == KnowledgeSourceStatus.processing;
}

KnowledgeSourceStatus knowledgeSourceStatusFromApi(String? raw) {
  switch (raw) {
    case 'pending':
    case 'queued':
      return KnowledgeSourceStatus.pending;
    case 'processing':
    case 'indexing':
    case 'crawling':
      return KnowledgeSourceStatus.processing;
    case 'completed':
    case 'active':
    case 'inactive':
    case 'ready':
      return KnowledgeSourceStatus.completed;
    case 'failed':
    case 'error':
      return KnowledgeSourceStatus.failed;
    default:
      return KnowledgeSourceStatus.pending;
  }
}

extension CrawlIntervalApiX on CrawlInterval {
  String toApiInterval() {
    switch (this) {
      case CrawlInterval.once:
        return 'ONCE';
      case CrawlInterval.daily:
        return 'DAILY';
      case CrawlInterval.weekly:
        return 'WEEKLY';
      case CrawlInterval.monthly:
        return 'MONTHLY';
    }
  }
}

CrawlInterval crawlIntervalFromApi(String? raw) {
  switch (raw) {
    case 'ONCE':
      return CrawlInterval.once;
    case 'DAILY':
      return CrawlInterval.daily;
    case 'WEEKLY':
      return CrawlInterval.weekly;
    case 'MONTHLY':
      return CrawlInterval.monthly;
    default:
      return CrawlInterval.once;
  }
}

// ---------------------------------------------------------------------------
// Entity
// ---------------------------------------------------------------------------

@JsonSerializable()
class KnowledgeSource {
  final String id;
  final String name;
  final KnowledgeSourceType type;
  final KnowledgeSourceStatus status;
  final CrawlInterval interval;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Optional indexing progress in [0, 1].  Only populated when the backend
  /// reports it (e.g. via SSE during a crawl).
  final double? progress;

  /// Optional human-readable error message, populated when [status] is `failed`.
  final String? errorMessage;

  /// Type-specific config (URL, fileName, dialect, includePaths, …) — used by
  /// the UI to render details.  The backend list endpoint does not return this.
  final Map<String, dynamic> config;

  const KnowledgeSource({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.interval,
    required this.createdAt,
    required this.updatedAt,
    this.progress,
    this.errorMessage,
    this.config = const {},
  });

  factory KnowledgeSource.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeSourceFromJson(json);

  Map<String, dynamic> toJson() => _$KnowledgeSourceToJson(this);

  KnowledgeSource copyWith({
    String? id,
    String? name,
    KnowledgeSourceType? type,
    KnowledgeSourceStatus? status,
    CrawlInterval? interval,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? progress,
    bool clearProgress = false,
    String? errorMessage,
    bool clearErrorMessage = false,
    Map<String, dynamic>? config,
  }) {
    return KnowledgeSource(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      interval: interval ?? this.interval,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      progress: clearProgress ? null : (progress ?? this.progress),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      config: config ?? this.config,
    );
  }
}
