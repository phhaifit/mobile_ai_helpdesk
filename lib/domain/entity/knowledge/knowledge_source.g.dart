// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KnowledgeSource _$KnowledgeSourceFromJson(Map<String, dynamic> json) =>
    KnowledgeSource(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$KnowledgeSourceTypeEnumMap, json['type']),
      status: $enumDecode(_$KnowledgeSourceStatusEnumMap, json['status']),
      lastSyncAt: DateTime.parse(json['lastSyncAt'] as String),
      crawlInterval: $enumDecode(_$CrawlIntervalEnumMap, json['crawlInterval']),
      config: json['config'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$KnowledgeSourceToJson(KnowledgeSource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$KnowledgeSourceTypeEnumMap[instance.type]!,
      'status': _$KnowledgeSourceStatusEnumMap[instance.status]!,
      'lastSyncAt': instance.lastSyncAt.toIso8601String(),
      'crawlInterval': _$CrawlIntervalEnumMap[instance.crawlInterval]!,
      'config': instance.config,
    };

const _$KnowledgeSourceTypeEnumMap = {
  KnowledgeSourceType.webSingle: 'webSingle',
  KnowledgeSourceType.webFull: 'webFull',
  KnowledgeSourceType.localFile: 'localFile',
  KnowledgeSourceType.googleDrive: 'googleDrive',
  KnowledgeSourceType.postgresql: 'postgresql',
  KnowledgeSourceType.sqlServer: 'sqlServer',
};

const _$KnowledgeSourceStatusEnumMap = {
  KnowledgeSourceStatus.active: 'active',
  KnowledgeSourceStatus.indexing: 'indexing',
  KnowledgeSourceStatus.error: 'error',
};

const _$CrawlIntervalEnumMap = {
  CrawlInterval.manual: 'manual',
  CrawlInterval.hourly: 'hourly',
  CrawlInterval.daily: 'daily',
  CrawlInterval.weekly: 'weekly',
  CrawlInterval.monthly: 'monthly',
};
