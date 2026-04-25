import 'package:ai_helpdesk/data/network/apis/chat/models/file_attachment_dto.dart';

class SendCsMessageToCustomerParams {
  final String chatRoomId;
  final String? groupId;
  final String? ticketId;
  final String contactId;
  final String channelId;
  final String? content;
  final String? title;
  final String? replyMessageId;
  final String? socketId;
  final List<FileAttachmentDto>? files;
  final bool? isAutoReply;
  final String? messageTag;
  final bool? mentionReply;

  SendCsMessageToCustomerParams({
    required this.chatRoomId,
    required this.contactId,
    required this.channelId,
    this.groupId,
    this.ticketId,
    this.content,
    this.title,
    this.replyMessageId,
    this.socketId,
    this.files,
    this.isAutoReply,
    this.messageTag,
    this.mentionReply,
  });

  Map<String, dynamic> toJson() {
    return {
      'chatRoomID': chatRoomId,
      'groupId': groupId,
      'ticketID': ticketId,
      'contactID': contactId,
      'channelID': channelId,
      'content': content,
      'title': title,
      'replyMessageID': replyMessageId,
      'socketID': socketId,
      'files': files?.map((e) => e.toJson()).toList(),
      'isAutoReply': isAutoReply,
      'messageTag': messageTag,
      'mentionReply': mentionReply,
    };
  }
}