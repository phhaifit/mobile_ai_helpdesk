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
      interval: $enumDecode(_$CrawlIntervalEnumMap, json['interval']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      progress: (json['progress'] as num?)?.toDouble(),
      errorMessage: json['errorMessage'] as String?,
      config: json['config'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$KnowledgeSourceToJson(KnowledgeSource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$KnowledgeSourceTypeEnumMap[instance.type]!,
      'status': _$KnowledgeSourceStatusEnumMap[instance.status]!,
      'interval': _$CrawlIntervalEnumMap[instance.interval]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'progress': instance.progress,
      'errorMessage': instance.errorMessage,
      'config': instance.config,
    };

const _$KnowledgeSourceTypeEnumMap = {
  KnowledgeSourceType.web: 'web',
  KnowledgeSourceType.wholeSite: 'wholeSite',
  KnowledgeSourceType.localFile: 'localFile',
  KnowledgeSourceType.googleDrive: 'googleDrive',
  KnowledgeSourceType.databaseQuery: 'databaseQuery',
};

const _$KnowledgeSourceStatusEnumMap = {
  KnowledgeSourceStatus.pending: 'pending',
  KnowledgeSourceStatus.processing: 'processing',
  KnowledgeSourceStatus.completed: 'completed',
  KnowledgeSourceStatus.failed: 'failed',
};

const _$CrawlIntervalEnumMap = {
  CrawlInterval.once: 'once',
  CrawlInterval.daily: 'daily',
  CrawlInterval.weekly: 'weekly',
  CrawlInterval.monthly: 'monthly',
};
