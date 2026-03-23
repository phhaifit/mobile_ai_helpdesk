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

enum CrawlInterval { manual, hourly, daily, weekly, monthly }

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
