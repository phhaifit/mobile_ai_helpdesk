// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ZaloChannelInfoDtoImpl _$$ZaloChannelInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ZaloChannelInfoDtoImpl(
  zaloId: json['zaloId'] as String,
  displayName: json['displayName'] as String?,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$ZaloChannelInfoDtoImplToJson(
  _$ZaloChannelInfoDtoImpl instance,
) => <String, dynamic>{
  'zaloId': instance.zaloId,
  'displayName': instance.displayName,
  'runtimeType': instance.$type,
};

_$MessengerChannelInfoDtoImpl _$$MessengerChannelInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$MessengerChannelInfoDtoImpl(
  messengerId: json['messengerId'] as String,
  username: json['username'] as String?,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$MessengerChannelInfoDtoImplToJson(
  _$MessengerChannelInfoDtoImpl instance,
) => <String, dynamic>{
  'messengerId': instance.messengerId,
  'username': instance.username,
  'runtimeType': instance.$type,
};

_$UnknownChannelInfoDtoImpl _$$UnknownChannelInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$UnknownChannelInfoDtoImpl($type: json['runtimeType'] as String?);

Map<String, dynamic> _$$UnknownChannelInfoDtoImplToJson(
  _$UnknownChannelInfoDtoImpl instance,
) => <String, dynamic>{'runtimeType': instance.$type};
