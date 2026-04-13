// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_agent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiAgent _$AiAgentFromJson(Map<String, dynamic> json) => AiAgent(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  mode: $enumDecode(_$AgentModeEnumMap, json['mode']),
  platforms:
      (json['platforms'] as List<dynamic>).map((e) => e as String).toList(),
  workflows:
      (json['workflows'] as List<dynamic>).map((e) => e as String).toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  avatarUrl: json['avatarUrl'] as String?,
  teamId: json['teamId'] as String?,
  toneOfAI: json['toneOfAI'] as String?,
  language: json['language'] as String?,
  includeReference: json['includeReference'] as bool?,
  autoResponse: json['autoResponse'] as bool?,
  autoDraftResponse: json['autoDraftResponse'] as bool?,
  enableTemplate: json['enableTemplate'] as bool?,
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
  'toneOfAI': instance.toneOfAI,
  'language': instance.language,
  'includeReference': instance.includeReference,
  'autoResponse': instance.autoResponse,
  'autoDraftResponse': instance.autoDraftResponse,
  'enableTemplate': instance.enableTemplate,
};

const _$AgentModeEnumMap = {
  AgentMode.auto: 'auto',
  AgentMode.semiAuto: 'semiAuto',
};
