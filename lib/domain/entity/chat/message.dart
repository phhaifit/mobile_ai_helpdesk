import 'reaction.dart';

enum MessageReadStatus { sent, delivered, read }

class Message {
  final int id;
  final String content;
  final DateTime timestamp;
  final bool isMe;
  final String senderName;
  final bool isPending;
  final MessageReadStatus readStatus;
  final List<Reaction> reactions;

  Message({
    required this.id,
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
    int? id,
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
