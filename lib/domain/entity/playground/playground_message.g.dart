// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playground_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaygroundMessage _$PlaygroundMessageFromJson(Map<String, dynamic> json) =>
    PlaygroundMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      role: $enumDecode(_$MessageRoleEnumMap, json['role']),
      attachments:
          (json['attachments'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$PlaygroundMessageToJson(PlaygroundMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'role': _$MessageRoleEnumMap[instance.role]!,
      'attachments': instance.attachments,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$MessageRoleEnumMap = {
  MessageRole.user: 'user',
  MessageRole.assistant: 'assistant',
};
