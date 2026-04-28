import 'package:freezed_annotation/freezed_annotation.dart';

import 'contact_info_dto.dart';
import 'file_attachment_dto.dart';
import 'message_reaction_dto.dart';

part 'message_dto.freezed.dart';
part 'message_dto.g.dart';

@freezed
class MessageDto with _$MessageDto {
  const factory MessageDto({
    @JsonKey(name: 'messageID') @Default('') String messageId,
    @JsonKey(name: 'chatRoomID') @Default('') String chatRoomId,
    @JsonKey(name: 'contactID') @Default('') String contactId,
    @JsonKey(name: 'ticketID') String? ticketId,
    String? sender,
    @JsonKey(name: 'replyMessageID') String? replyMessageId,
    @Default(0) int messageOrder,
    @Default('') String messageType,
    @JsonKey(name: 'channelID') String? channelId,
    @JsonKey(name: 'zaloCliMsgID') String? zaloCliMsgId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required ContactInfoDto contactInfo,
    @Default({}) Map<String, dynamic> contentInfo,
    @Default({}) Map<String, dynamic> ticketInfo,
    @Default([]) List<FileAttachmentDto> files,
    @Default([]) List<MessageReactionDto> reaction,
    @Default({}) Map<String, dynamic> replyMessage,
    @Default({}) Map<String, dynamic> slackMessage,
    @Default({}) Map<String, dynamic> zohoDeskMessage,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) => 
      _$MessageDtoFromJson(json);
}