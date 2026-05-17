// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seen_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SeenInfoDtoImpl _$$SeenInfoDtoImplFromJson(Map<String, dynamic> json) =>
    _$SeenInfoDtoImpl(
      chatRoomSeenId: json['chatRoomSeenID'] as String? ?? '',
      chatRoomId: json['chatRoomID'] as String? ?? '',
      customerSupportId: json['customerSupportID'] as String? ?? '',
      messageId: json['messageID'] as String? ?? '',
      messageOrder: (json['messageOrder'] as num?)?.toInt() ?? 0,
      numberMessageSeen: (json['numberMessageSeen'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$SeenInfoDtoImplToJson(_$SeenInfoDtoImpl instance) =>
    <String, dynamic>{
      'chatRoomSeenID': instance.chatRoomSeenId,
      'chatRoomID': instance.chatRoomId,
      'customerSupportID': instance.customerSupportId,
      'messageID': instance.messageId,
      'messageOrder': instance.messageOrder,
      'numberMessageSeen': instance.numberMessageSeen,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
