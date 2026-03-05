import '../../../../domain/entity/chat/message.dart';

class ChartDataSources {
  Future<List<Message>> getMockMessages() async {
    return [
      Message(
        id: 1,
        content: "Chào bạn, tôi có thể giúp gì cho dự án mobile_ai_helpdesk?",
        timestamp: DateTime.now().subtract(Duration(minutes: 10)),
        isMe: false,
        senderName: "AI Assistant",
        isPending: false,
      ),
      Message(
        id: 2,
        content: "Tôi đang tìm hiểu về cấu trúc MobX trong project.",
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        isMe: true,
        senderName: "User",
        isPending: false,
      ),
    ];
  }
}
