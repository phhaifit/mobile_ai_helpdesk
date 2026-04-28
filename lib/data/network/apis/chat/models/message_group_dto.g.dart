// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_group_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageGroupDtoImpl _$$MessageGroupDtoImplFromJson(
  Map<String, dynamic> json,
) => _$MessageGroupDtoImpl(
  date: DateTime.parse(json['date'] as String),
  messages:
      (json['messages'] as List<dynamic>?)
          ?.map((e) => MessageDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$MessageGroupDtoImplToJson(
  _$MessageGroupDtoImpl instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'messages': instance.messages,
};
