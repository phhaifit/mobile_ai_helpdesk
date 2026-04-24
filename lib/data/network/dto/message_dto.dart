import 'contact_info_dto.dart';
import 'file_attachment_dto.dart';
import 'message_reaction_dto.dart';

class MessageDto {
  final String messageId;
  final String chatRoomId;
  final String contactId;
  final String? ticketId;
  final String? sender;
  final String? replyMessageId;
  final int messageOrder;
  final String messageType;
  final String? channelId;
  final String? zaloCliMsgId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final ContactInfoDto contactInfo;
  final Map<String, dynamic> contentInfo;
  final Map<String, dynamic>? ticketInfo;
  final List<FileAttachmentDto> files;
  final List<MessageReactionDto> reaction;
  final Map<String, dynamic>? replyMessage;
  final Map<String, dynamic>? slackMessage;
  final Map<String, dynamic>? zohoDeskMessage;

  MessageDto({
    required this.messageId,
    required this.chatRoomId,
    required this.contactId,
    required this.ticketId,
    required this.sender,
    required this.replyMessageId,
    required this.messageOrder,
    required this.messageType,
    required this.channelId,
    required this.zaloCliMsgId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.contactInfo,
    required this.contentInfo,
    required this.ticketInfo,
    required this.files,
    required this.reaction,
    required this.replyMessage,
    required this.slackMessage,
    required this.zohoDeskMessage,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    return MessageDto(
      messageId: json['messageID']?.toString() ?? '',
      chatRoomId: json['chatRoomID']?.toString() ?? '',
      contactId: json['contactID']?.toString() ?? '',
      ticketId: json['ticketID']?.toString(),
      sender: json['sender']?.toString(),
      replyMessageId: json['replyMessageID']?.toString(),
      messageOrder: json['messageOrder'] is num ? (json['messageOrder'] as num).toInt() : 0,
      messageType: json['messageType']?.toString() ?? '',
      channelId: json['channelID']?.toString(),
      zaloCliMsgId: json['zaloCliMsgID']?.toString(),
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] is String
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      deletedAt: json['deletedAt'] is String
          ? DateTime.tryParse(json['deletedAt'] as String) ?? DateTime.now()
          : null,
      contactInfo: ContactInfoDto.fromJson(json['contactInfo'] as Map<String, dynamic>),
      contentInfo: json['contentInfo'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['contentInfo'] as Map)
          : <String, dynamic>{},
      ticketInfo: json['ticketInfo'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['ticketInfo'] as Map)
          : <String, dynamic>{},
      files: json['files'] is List
          ? (json['files'] as List).whereType<Map<String, dynamic>>().map((f) => FileAttachmentDto.fromJson(f)).toList()
          : const <FileAttachmentDto>[],
      reaction: json['reaction'] is List
          ? (json['reaction'] as List).whereType<Map<String, dynamic>>().map((r) => MessageReactionDto.fromJson(r)).toList()
          : const <MessageReactionDto>[],
      replyMessage: json['replyMessage'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['replyMessage'] as Map)
          : const <String, dynamic>{},
      slackMessage: json['slackMessage'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['slackMessage'] as Map)
          : const <String, dynamic>{},
      zohoDeskMessage: json['zohoDeskMessage'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['zohoDeskMessage'] as Map)
          : const <String, dynamic>{},
    );
  }
}
