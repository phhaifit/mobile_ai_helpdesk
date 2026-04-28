// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_cs_message_to_customer_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SendCsMessageToCustomerParamsImpl
_$$SendCsMessageToCustomerParamsImplFromJson(Map<String, dynamic> json) =>
    _$SendCsMessageToCustomerParamsImpl(
      chatRoomId: json['chatRoomID'] as String,
      contactId: json['contactID'] as String,
      channelId: json['channelID'] as String,
      groupId: json['groupId'] as String?,
      ticketId: json['ticketID'] as String?,
      content: json['content'] as String?,
      title: json['title'] as String?,
      replyMessageId: json['replyMessageID'] as String?,
      socketId: json['socketID'] as String?,
      files:
          (json['files'] as List<dynamic>?)
              ?.map(
                (e) => FileAttachmentDto.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      isAutoReply: json['isAutoReply'] as bool?,
      messageTag: json['messageTag'] as String?,
      mentionReply: json['mentionReply'] as bool?,
    );

Map<String, dynamic> _$$SendCsMessageToCustomerParamsImplToJson(
  _$SendCsMessageToCustomerParamsImpl instance,
) => <String, dynamic>{
  'chatRoomID': instance.chatRoomId,
  'contactID': instance.contactId,
  'channelID': instance.channelId,
  if (instance.groupId case final value?) 'groupId': value,
  if (instance.ticketId case final value?) 'ticketID': value,
  if (instance.content case final value?) 'content': value,
  if (instance.title case final value?) 'title': value,
  if (instance.replyMessageId case final value?) 'replyMessageID': value,
  if (instance.socketId case final value?) 'socketID': value,
  if (instance.files case final value?) 'files': value,
  if (instance.isAutoReply case final value?) 'isAutoReply': value,
  if (instance.messageTag case final value?) 'messageTag': value,
  if (instance.mentionReply case final value?) 'mentionReply': value,
};
