// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_counter_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatRoomCounterDtoImpl _$$ChatRoomCounterDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ChatRoomCounterDtoImpl(
  open: (json['open'] as num?)?.toInt() ?? 0,
  pending: (json['pending'] as num?)?.toInt() ?? 0,
  solved: (json['solved'] as num?)?.toInt() ?? 0,
  closed: (json['closed'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$ChatRoomCounterDtoImplToJson(
  _$ChatRoomCounterDtoImpl instance,
) => <String, dynamic>{
  'open': instance.open,
  'pending': instance.pending,
  'solved': instance.solved,
  'closed': instance.closed,
};
