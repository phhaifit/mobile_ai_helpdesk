import 'attachment.dart';
import 'reaction.dart';
import 'user.dart';

class Message {
  final String id;
  final String? externalAccountId;
  final String conversationId;
  final User sender;
  final bool isMe;
  final String content;
  final List<Attachment> attachments;
  final String? replyMessageId;
  final List<Reaction> reactions;
  final DateTime timestamp;

  /// Same as [conversationId]; matches backend naming in socket/UI.
  String get chatRoomId => conversationId;

  const Message({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.isMe,
    required this.content,
    required this.attachments,
    required this.timestamp,
    required this.replyMessageId,
    required this.reactions,
    this.externalAccountId,
  });

  Message copyWith({
    String? id,
    String? externalAccountId,
    String? conversationId,
    User? sender,
    bool? isMe,
    String? content,
    List<Attachment>? attachments,
    String? replyMessageId,
    List<Reaction>? reactions,
    DateTime? timestamp,
  }) {
    return Message(
      id: id ?? this.id,
      externalAccountId: externalAccountId ?? this.externalAccountId,
      conversationId: conversationId ?? this.conversationId,
      sender: sender ?? this.sender,
      isMe: isMe ?? this.isMe,
      content: content ?? this.content,
      attachments: attachments ?? this.attachments,
      replyMessageId: replyMessageId ?? this.replyMessageId,
      reactions: reactions ?? this.reactions,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
