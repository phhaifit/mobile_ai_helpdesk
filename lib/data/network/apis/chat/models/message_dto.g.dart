// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageDtoImpl _$$MessageDtoImplFromJson(
  Map<String, dynamic> json,
) => _$MessageDtoImpl(
  messageId: json['messageID'] as String? ?? '',
  chatRoomId: json['chatRoomID'] as String? ?? '',
  contactId: json['contactID'] as String? ?? '',
  ticketId: json['ticketID'] as String?,
  sender: json['sender'] as String?,
  replyMessageId: json['replyMessageID'] as String?,
  messageOrder: (json['messageOrder'] as num?)?.toInt() ?? 0,
  messageType: json['messageType'] as String? ?? '',
  channelId: json['channelID'] as String?,
  zaloCliMsgId: json['zaloCliMsgID'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt:
      json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
  contactInfo: ContactInfoDto.fromJson(
    json['contactInfo'] as Map<String, dynamic>,
  ),
  contentInfo: json['contentInfo'] as Map<String, dynamic>? ?? const {},
  ticketInfo: json['ticketInfo'] as Map<String, dynamic>? ?? const {},
  files:
      (json['files'] as List<dynamic>?)
          ?.map((e) => FileAttachmentDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  reaction:
      (json['reaction'] as List<dynamic>?)
          ?.map((e) => MessageReactionDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  replyMessage: json['replyMessage'] as Map<String, dynamic>? ?? const {},
  slackMessage: json['slackMessage'] as Map<String, dynamic>? ?? const {},
  zohoDeskMessage: json['zohoDeskMessage'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$MessageDtoImplToJson(_$MessageDtoImpl instance) =>
    <String, dynamic>{
      'messageID': instance.messageId,
      'chatRoomID': instance.chatRoomId,
      'contactID': instance.contactId,
      'ticketID': instance.ticketId,
      'sender': instance.sender,
      'replyMessageID': instance.replyMessageId,
      'messageOrder': instance.messageOrder,
      'messageType': instance.messageType,
      'channelID': instance.channelId,
      'zaloCliMsgID': instance.zaloCliMsgId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'contactInfo': instance.contactInfo,
      'contentInfo': instance.contentInfo,
      'ticketInfo': instance.ticketInfo,
      'files': instance.files,
      'reaction': instance.reaction,
      'replyMessage': instance.replyMessage,
      'slackMessage': instance.slackMessage,
      'zohoDeskMessage': instance.zohoDeskMessage,
    };
