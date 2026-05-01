import 'package:json_annotation/json_annotation.dart';

part 'knowledge_source.g.dart';

/// Source type — mirrors the backend `type` enum 1:1.
///
/// Backend values:
///   `web` (single URL) | `whole_site` | `local_file` | `google_drive` | `database_query`
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
  String toApiType() {
    switch (this) {
      case KnowledgeSourceType.web:
        return 'web';
      case KnowledgeSourceType.wholeSite:
        return 'whole_site';
      case KnowledgeSourceType.localFile:
        return 'local_file';
      case KnowledgeSourceType.googleDrive:
        return 'google_drive';
      case KnowledgeSourceType.databaseQuery:
        return 'database_query';
    }
  }

  /// Used for the body field `type` of `POST /web` (single_url|whole_site).
  String toWebImportType() {
    if (this == KnowledgeSourceType.wholeSite) return 'whole_site';
    return 'single_url';
  }
}

KnowledgeSourceType knowledgeSourceTypeFromApi(String? raw) {
  switch (raw) {
    case 'web':
      return KnowledgeSourceType.web;
    case 'whole_site':
      return KnowledgeSourceType.wholeSite;
    case 'local_file':
      return KnowledgeSourceType.localFile;
    case 'google_drive':
      return KnowledgeSourceType.googleDrive;
    case 'database_query':
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
      return KnowledgeSourceStatus.pending;
    case 'processing':
      return KnowledgeSourceStatus.processing;
    case 'completed':
      return KnowledgeSourceStatus.completed;
    case 'failed':
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
