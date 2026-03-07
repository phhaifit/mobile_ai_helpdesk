import '../../../../domain/entity/chat/message.dart';
import '../../../../domain/entity/chat/reaction.dart';

class ChatDataSource {
  Future<List<Message>> getMockMessages() async {
    return [
      Message(
        id: 1,
        content: "Chào bạn, tôi có thể giúp gì cho dự án mobile_ai_helpdesk?",
        timestamp: DateTime.now().subtract(Duration(minutes: 10)),
        isMe: false,
        senderName: "AI Assistant",
        isPending: false,
        readStatus: MessageReadStatus.read,
        reactions: [
          Reaction(emoji: '👍', userNames: ['You']),
        ],
      ),
      Message(
        id: 2,
        content: "Tôi đang tìm hiểu về cấu trúc MobX trong project.",
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        isMe: true,
        senderName: "User",
        isPending: false,
        readStatus: MessageReadStatus.read,
        reactions: [
          Reaction(emoji: '❤️', userNames: ['AI Assistant']),
        ],
      ),
      Message(
        id: 3,
        content: "Tôi có thể giúp bạn với cấu trúc Clean Architecture.",
        timestamp: DateTime.now().subtract(Duration(minutes: 3)),
        isMe: false,
        senderName: "AI Assistant",
        isPending: false,
        readStatus: MessageReadStatus.read,
      ),
      Message(
        id: 4,
        content: "Cảm ơn! Tôi sẽ bắt đầu implement features.",
        timestamp: DateTime.now().subtract(Duration(minutes: 1)),
        isMe: true,
        senderName: "User",
        isPending: false,
        readStatus: MessageReadStatus.read,
      ),
    ];
  }
}
