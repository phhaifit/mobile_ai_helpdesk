// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatRoomDtoImpl _$$ChatRoomDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ChatRoomDtoImpl(
  chatRoomId: json['chatRoomID'] as String? ?? '',
  customerId: json['customerID'] as String? ?? '',
  groupId: json['groupID'] as String?,
  lastMessageId: json['lastMessageID'] as String?,
  totalMessage: (json['totalMessage'] as num?)?.toInt() ?? 0,
  followupCount: (json['followupCount'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  lastMessage:
      json['lastMessage'] == null
          ? null
          : MessageDto.fromJson(json['lastMessage'] as Map<String, dynamic>),
  customerInfo:
      json['customerInfo'] == null
          ? null
          : CustomerInfoDto.fromJson(
            json['customerInfo'] as Map<String, dynamic>,
          ),
  groupInfo:
      json['groupInfo'] == null
          ? null
          : GroupInfoDto.fromJson(json['groupInfo'] as Map<String, dynamic>),
  myCurrentTicket: json['myCurrentTicket'] as Map<String, dynamic>?,
  tickets:
      (json['tickets'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const [],
  seenInfo:
      (json['seenInfo'] as List<dynamic>?)
          ?.map((e) => SeenInfoDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  seenMessageOrder: (json['seenMessageOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$ChatRoomDtoImplToJson(_$ChatRoomDtoImpl instance) =>
    <String, dynamic>{
      'chatRoomID': instance.chatRoomId,
      'customerID': instance.customerId,
      'groupID': instance.groupId,
      'lastMessageID': instance.lastMessageId,
      'totalMessage': instance.totalMessage,
      'followupCount': instance.followupCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastMessage': instance.lastMessage,
      'customerInfo': instance.customerInfo,
      'groupInfo': instance.groupInfo,
      'myCurrentTicket': instance.myCurrentTicket,
      'tickets': instance.tickets,
      'seenInfo': instance.seenInfo,
      'seenMessageOrder': instance.seenMessageOrder,
    };
