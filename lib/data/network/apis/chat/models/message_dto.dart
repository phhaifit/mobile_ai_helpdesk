import 'package:freezed_annotation/freezed_annotation.dart';

import 'channel_info_dto.dart';
import 'contact_info_dto.dart';
import 'customer_support_info_dto.dart';
import 'file_attachment_dto.dart';
import 'message_reaction_dto.dart';
import 'ticket_info_dto.dart';

part 'message_dto.freezed.dart';
part 'message_dto.g.dart';

@freezed
class MessageDto with _$MessageDto {
  const factory MessageDto({
    @JsonKey(name: 'contactID') required String contactId, @JsonKey(name: 'channelID') required String channelId, required DateTime createdAt, required ContactInfoDto contactInfo, required TicketInfoDto? ticketInfo, @JsonKey(name: 'messageID') @Default('') String messageId,
    @JsonKey(name: 'chatRoomID') @Default('') String chatRoomId,
    @JsonKey(name: 'ticketID') String? ticketId,
    String? sender,
    @JsonKey(name: 'replyMessageID') String? replyMessageId,
    @Default(0) int messageOrder,
    @Default('') String messageType,
    ChannelInfoDto? channelInfo,
    @JsonKey(name: 'zaloCliMsgID') String? zaloCliMsgId,
    DateTime? updatedAt,
    DateTime? deletedAt,
    @Default({}) Map<String, dynamic> contentInfo,
    @Default([]) List<FileAttachmentDto> files,
    @Default([]) List<MessageReactionDto> reaction,
    Map<String, dynamic>? replyMessage,
    @Default({}) Map<String, dynamic> slackMessage,
    @Default({}) Map<String, dynamic> zohoDeskMessage,
    @JsonKey(name: 'senderInfo') CustomerSupportInfoDto? senderInfo,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) => 
      _$MessageDtoFromJson(json);
}