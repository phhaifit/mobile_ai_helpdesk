// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_chat_rooms_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FetchChatRoomsParamsImpl _$$FetchChatRoomsParamsImplFromJson(
  Map<String, dynamic> json,
) => _$FetchChatRoomsParamsImpl(
  customerName: json['customerName'] as String?,
  limit: (json['limit'] as num?)?.toInt() ?? 20,
  lastMessageId: json['lastMessageID'] as String?,
  lastChatRoomId: json['lastChatRoomID'] as String?,
  lastChatRoomUpdatedAt: json['lastChatRoomUpdatedAt'] as String?,
  status: json['status'] as String?,
  statuses:
      (json['statuses'] as List<dynamic>?)?.map((e) => e as String).toList(),
  channels:
      (json['channel'] as List<dynamic>?)?.map((e) => e as String).toList(),
  channelIds:
      (json['channelIDs'] as List<dynamic>?)?.map((e) => e as String).toList(),
  updatedAtFrom:
      json['updatedAtFrom'] == null
          ? null
          : DateTime.parse(json['updatedAtFrom'] as String),
  updatedAtTo:
      json['updatedAtTo'] == null
          ? null
          : DateTime.parse(json['updatedAtTo'] as String),
  getCounter: json['getCounter'] as bool? ?? false,
  getAll: json['getAll'] as bool? ?? false,
);

Map<String, dynamic> _$$FetchChatRoomsParamsImplToJson(
  _$FetchChatRoomsParamsImpl instance,
) => <String, dynamic>{
  if (instance.customerName case final value?) 'customerName': value,
  'limit': instance.limit,
  if (instance.lastMessageId case final value?) 'lastMessageID': value,
  if (instance.lastChatRoomId case final value?) 'lastChatRoomID': value,
  if (instance.lastChatRoomUpdatedAt case final value?)
    'lastChatRoomUpdatedAt': value,
  if (instance.status case final value?) 'status': value,
  if (instance.statuses case final value?) 'statuses': value,
  if (instance.channels case final value?) 'channel': value,
  if (instance.channelIds case final value?) 'channelIDs': value,
  'updatedAtFrom': instance.updatedAtFrom?.toIso8601String(),
  'updatedAtTo': instance.updatedAtTo?.toIso8601String(),
  'getCounter': instance.getCounter,
  'getAll': instance.getAll,
};
