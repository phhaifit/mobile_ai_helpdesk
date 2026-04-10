// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_agent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiAgent _$AiAgentFromJson(Map<String, dynamic> json) => AiAgent(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  mode: $enumDecode(_$AgentModeEnumMap, json['mode']),
  platforms:
      (json['platforms'] as List<dynamic>).map((e) => e as String).toList(),
  workflows:
      (json['workflows'] as List<dynamic>).map((e) => e as String).toList(),
  teamId: json['teamId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AiAgentToJson(AiAgent instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'avatarUrl': instance.avatarUrl,
  'mode': _$AgentModeEnumMap[instance.mode]!,
  'platforms': instance.platforms,
  'workflows': instance.workflows,
  'teamId': instance.teamId,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$AgentModeEnumMap = {
  AgentMode.auto: 'auto',
  AgentMode.semiAuto: 'semiAuto',
};
