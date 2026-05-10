// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChannelInfoDtoImpl _$$ChannelInfoDtoImplFromJson(Map<String, dynamic> json) =>
    _$ChannelInfoDtoImpl(
      appId: json['appID'] as String,
      channelId: json['channelID'] as String,
      name: json['name'] as String,
      config: json['config'] as Map<String, dynamic>,
      appInfo: json['appInfo'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$ChannelInfoDtoImplToJson(
  _$ChannelInfoDtoImpl instance,
) => <String, dynamic>{
  'appID': instance.appId,
  'channelID': instance.channelId,
  'name': instance.name,
  'config': instance.config,
  'appInfo': instance.appInfo,
};
