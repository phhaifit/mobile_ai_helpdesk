// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_entities_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageEntitiesDtoImpl _$$MessageEntitiesDtoImplFromJson(
  Map<String, dynamic> json,
) => _$MessageEntitiesDtoImpl(
  channels: json['channels'] as Map<String, dynamic>? ?? const {},
  senders: json['senders'] as Map<String, dynamic>? ?? const {},
  tickets: json['tickets'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$MessageEntitiesDtoImplToJson(
  _$MessageEntitiesDtoImpl instance,
) => <String, dynamic>{
  'channels': instance.channels,
  'senders': instance.senders,
  'tickets': instance.tickets,
};
