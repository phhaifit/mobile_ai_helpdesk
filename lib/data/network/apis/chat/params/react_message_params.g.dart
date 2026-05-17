// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'react_message_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReactMessageParamsImpl _$$ReactMessageParamsImplFromJson(
  Map<String, dynamic> json,
) => _$ReactMessageParamsImpl(
  messageId: json['messageID'] as String,
  zaloMessageId: json['zaloMessageID'] as String,
  reactIcon: json['reactIcon'] as String,
  zaloAccountId: json['zaloAccountID'] as String,
  chatRoomId: json['chatRoomID'] as String,
  socketId: json['socketID'] as String?,
  channelId: json['channelID'] as String?,
);

Map<String, dynamic> _$$ReactMessageParamsImplToJson(
  _$ReactMessageParamsImpl instance,
) => <String, dynamic>{
  'messageID': instance.messageId,
  'zaloMessageID': instance.zaloMessageId,
  'reactIcon': instance.reactIcon,
  'zaloAccountID': instance.zaloAccountId,
  'chatRoomID': instance.chatRoomId,
  if (instance.socketId case final value?) 'socketID': value,
  if (instance.channelId case final value?) 'channelID': value,
};
