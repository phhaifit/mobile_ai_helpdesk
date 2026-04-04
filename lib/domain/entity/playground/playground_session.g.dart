// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playground_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaygroundSession _$PlaygroundSessionFromJson(Map<String, dynamic> json) =>
    PlaygroundSession(
      id: json['id'] as String,
      agentId: json['agentId'] as String?,
      contextType: $enumDecode(
        _$PlaygroundContextTypeEnumMap,
        json['contextType'],
      ),
      messages:
          (json['messages'] as List<dynamic>)
              .map((e) => PlaygroundMessage.fromJson(e as Map<String, dynamic>))
              .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PlaygroundSessionToJson(PlaygroundSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'agentId': instance.agentId,
      'contextType': _$PlaygroundContextTypeEnumMap[instance.contextType]!,
      'messages': instance.messages.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$PlaygroundContextTypeEnumMap = {
  PlaygroundContextType.lazada: 'lazada',
  PlaygroundContextType.normal: 'normal',
};
