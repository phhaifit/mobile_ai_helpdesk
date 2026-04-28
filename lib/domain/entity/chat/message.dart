import '../../enums/chat/message_type.dart';
import 'reaction.dart';

class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final bool isMe;
  final String content;
  final MessageType type;
  final String? replyMessageId;
  final List<Reaction> reactions;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.isMe,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.replyMessageId,
    required this.reactions,
  });
}