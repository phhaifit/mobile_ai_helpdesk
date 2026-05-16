import 'attachment.dart';
import 'message_reply_preview.dart';
import 'reaction.dart';
import 'user.dart';

class Message {
  final String id;
  final String conversationId;
  final int order;
  final User sender;
  final bool isMe;
  final String content;
  final List<Attachment> attachments;
  final MessageReplyPreview? replyPreview;
  final List<Reaction> reactions;
  final DateTime timestamp;

  /// Zalo channel message (reactions require [zaloMessageId] + [zaloAccountId]).
  final bool isZalo;

  /// Zalo platform message id from `contentInfo.zaloMessageID` or `zaloCliMsgID`.
  final String? zaloMessageId;

  /// Customer Zalo account id from contact info.
  final String? zaloAccountId;

  /// Same as [conversationId]; matches backend naming in socket/UI.
  String get chatRoomId => conversationId;

  bool get canReactOnZalo =>
      isZalo &&
      zaloMessageId != null &&
      zaloMessageId!.isNotEmpty &&
      zaloAccountId != null &&
      zaloAccountId!.isNotEmpty;

  const Message({
    required this.id,
    required this.conversationId,
    required this.order,
    required this.sender,
    required this.isMe,
    required this.content,
    required this.attachments,
    required this.timestamp,
    this.replyPreview,
    required this.reactions,
    this.isZalo = false,
    this.zaloMessageId,
    this.zaloAccountId,
  });

  Message copyWith({
    String? id,
    String? conversationId,
    int? order,
    User? sender,
    bool? isMe,
    String? content,
    List<Attachment>? attachments,
    MessageReplyPreview? replyPreview,
    List<Reaction>? reactions,
    DateTime? timestamp,
    bool? isZalo,
    String? zaloMessageId,
    String? zaloAccountId,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      order: order ?? this.order,
      sender: sender ?? this.sender,
      isMe: isMe ?? this.isMe,
      content: content ?? this.content,
      attachments: attachments ?? this.attachments,
      replyPreview: replyPreview ?? this.replyPreview,
      reactions: reactions ?? this.reactions,
      timestamp: timestamp ?? this.timestamp,
      isZalo: isZalo ?? this.isZalo,
      zaloMessageId: zaloMessageId ?? this.zaloMessageId,
      zaloAccountId: zaloAccountId ?? this.zaloAccountId,
    );
  }
}
