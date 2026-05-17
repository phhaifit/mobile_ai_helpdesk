import 'message.dart';

/// Local update when a chat room's preview message changes (e.g. agent send).
class ChatRoomLastMessageUpdate {
  final String chatRoomId;
  final Message message;

  const ChatRoomLastMessageUpdate({
    required this.chatRoomId,
    required this.message,
  });
}
