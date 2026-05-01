import 'package:json_annotation/json_annotation.dart';

part 'knowledge_source.g.dart';

enum KnowledgeSourceType {
  webSingle,
  webFull,
  localFile,
  googleDrive,
  postgresql,
  sqlServer,
}

enum KnowledgeSourceStatus { active, indexing, error }

/// Backend supports: ONCE | DAILY | WEEKLY | MONTHLY (no HOURLY).
enum CrawlInterval { manual, daily, weekly, monthly }

// ---------------------------------------------------------------------------
// API ↔ Domain mapping extensions
// ---------------------------------------------------------------------------

extension KnowledgeSourceTypeApiX on KnowledgeSourceType {
  /// Converts domain type to API `type` string used in import endpoints.
  String toApiImportType() {
    switch (this) {
      case KnowledgeSourceType.webSingle:
        return 'single_url';
      case KnowledgeSourceType.webFull:
        return 'whole_site';
      case KnowledgeSourceType.localFile:
        return 'local_file';
      case KnowledgeSourceType.googleDrive:
        return 'google_drive';
      case KnowledgeSourceType.postgresql:
      case KnowledgeSourceType.sqlServer:
        return 'database_query';
    }
  }
}

extension KnowledgeSourceTypeFromApi on String {
  /// Parses API `type` field from GET /sources response.
  KnowledgeSourceType toKnowledgeSourceType() {
    switch (this) {
      case 'web':
        return KnowledgeSourceType.webSingle;
      case 'whole_site':
        return KnowledgeSourceType.webFull;
      case 'local_file':
        return KnowledgeSourceType.localFile;
      case 'google_drive':
        return KnowledgeSourceType.googleDrive;
      case 'database_query':
        return KnowledgeSourceType.postgresql;
      default:
        return KnowledgeSourceType.webSingle;
    }
  }
}

extension KnowledgeSourceStatusFromApi on String {
  /// Maps API status (pending/processing/completed/failed) → domain status.
  KnowledgeSourceStatus toKnowledgeSourceStatus() {
    switch (this) {
      case 'completed':
        return KnowledgeSourceStatus.active;
      case 'pending':
      case 'processing':
        return KnowledgeSourceStatus.indexing;
      case 'failed':
        return KnowledgeSourceStatus.error;
      default:
        return KnowledgeSourceStatus.indexing;
    }
  }
}

extension KnowledgeSourceStatusApiX on KnowledgeSourceStatus {
  /// Maps domain status → API status string for PATCH requests.
  String toApiStatus() {
    switch (this) {
      case KnowledgeSourceStatus.active:
        return 'completed';
      case KnowledgeSourceStatus.indexing:
        return 'processing';
      case KnowledgeSourceStatus.error:
        return 'failed';
    }
  }
}

extension CrawlIntervalApiX on CrawlInterval {
  /// Converts domain interval → API interval string (ONCE/DAILY/WEEKLY/MONTHLY).
  String toApiInterval() {
    switch (this) {
      case CrawlInterval.manual:
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

extension CrawlIntervalFromApi on String {
  /// Parses API interval string → domain CrawlInterval.
  CrawlInterval toCrawlInterval() {
    switch (this) {
      case 'ONCE':
        return CrawlInterval.manual;
      case 'DAILY':
        return CrawlInterval.daily;
      case 'WEEKLY':
        return CrawlInterval.weekly;
      case 'MONTHLY':
        return CrawlInterval.monthly;
      default:
        return CrawlInterval.manual;
    }
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
  final DateTime lastSyncAt;
  final CrawlInterval crawlInterval;
  final Map<String, dynamic> config;

  const KnowledgeSource({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.lastSyncAt,
    required this.crawlInterval,
    required this.config,
  });

  factory KnowledgeSource.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeSourceFromJson(json);

  Map<String, dynamic> toJson() => _$KnowledgeSourceToJson(this);

  KnowledgeSource copyWith({
    String? id,
    String? name,
    KnowledgeSourceType? type,
    KnowledgeSourceStatus? status,
    DateTime? lastSyncAt,
    CrawlInterval? crawlInterval,
    Map<String, dynamic>? config,
  }) {
    return KnowledgeSource(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      crawlInterval: crawlInterval ?? this.crawlInterval,
      config: config ?? this.config,
    );
  }
}
