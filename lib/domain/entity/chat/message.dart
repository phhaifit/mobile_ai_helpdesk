import 'reaction.dart';

enum MessageReadStatus { sent, delivered, read }

class Message {
  final String id;
  final String? chatRoomId;
  final String content;
  final DateTime timestamp;
  final bool isMe;
  final String senderName;
  final bool isPending;
  final MessageReadStatus readStatus;
  final List<Reaction> reactions;

  Message({
    required this.id,
    this.chatRoomId,
    required this.content,
    required this.timestamp,
    required this.isMe,
    required this.senderName,
    required this.isPending,
    this.readStatus = MessageReadStatus.sent,
    this.reactions = const [],
  });

  /// Create a copy with optional fields
  Message copyWith({
    String? id,
    String? chatRoomId,
    String? content,
    DateTime? timestamp,
    bool? isMe,
    String? senderName,
    bool? isPending,
    MessageReadStatus? readStatus,
    List<Reaction>? reactions,
  }) {
    return Message(
      id: id ?? this.id,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isMe: isMe ?? this.isMe,
      senderName: senderName ?? this.senderName,
      isPending: isPending ?? this.isPending,
      readStatus: readStatus ?? this.readStatus,
      reactions: reactions ?? this.reactions,
    );
  }
}
