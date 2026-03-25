import '../../../../domain/entity/chat/message.dart';
import '../../../../domain/entity/chat/reaction.dart';

class ChatDataSource {
  Future<List<Message>> getMockMessages() async {
    final baseTime = DateTime.now().subtract(const Duration(minutes: 45));

    return [
      // 1. Customer inquiry about order
      Message(
        id: 1,
        content: 'Xin chào, tôi có câu hỏi về đơn hàng của mình',
        timestamp: baseTime,
        isMe: false,
        senderName: 'Nguyễn Huy Tân',
        isPending: false,
        readStatus: MessageReadStatus.read,
      ),

      // 2. Support agent responds quickly
      Message(
        id: 2,
        content:
            'Chào bạn! 👋 Rất vui được hỗ trợ. Bạn có thể cung cấp mã đơn hàng không?',
        timestamp: baseTime.add(const Duration(minutes: 2)),
        isMe: false,
        senderName: 'AI Assistant',
        isPending: false,
        readStatus: MessageReadStatus.read,
      ),

      // 3. Customer provides order info
      Message(
        id: 3,
        content: 'Mã đơn hàng là: ORD-2026-002847',
        timestamp: baseTime.add(const Duration(minutes: 3)),
        isMe: true,
        senderName: 'You',
        isPending: false,
        readStatus: MessageReadStatus.read,
        reactions: [
          const Reaction(emoji: '👍', userNames: ['AI Assistant']),
        ],
      ),

      // 4. Support searching in system
      Message(
        id: 4,
        content: 'Đợi một chút, tôi đang kiểm tra thông tin đơn hàng...',
        timestamp: baseTime.add(const Duration(minutes: 4)),
        isMe: false,
        senderName: 'AI Assistant',
        isPending: false,
        readStatus: MessageReadStatus.read,
      ),

      // 5. Support continues (same sender, so isGroupStart=false for previous)
      Message(
        id: 5,
        content:
            'Tôi thấy đơn hàng của bạn rồi. Nó đang được vận chuyển và sẽ đến trong 2-3 ngày.',
        timestamp: baseTime.add(const Duration(minutes: 5)),
        isMe: false,
        senderName: 'AI Assistant',
        isPending: false,
        readStatus: MessageReadStatus.read,
      ),

      // 6. Customer follows up
      Message(
        id: 6,
        content: 'Cảm ơn! Vậy có cách nào để theo dõi gói hàng không?',
        timestamp: baseTime.add(const Duration(minutes: 7)),
        isMe: true,
        senderName: 'You',
        isPending: false,
        readStatus: MessageReadStatus.read,
      ),

      // 7. Support provides tracking info
      Message(
        id: 7,
        content:
            'Có chứ! Bạn có thể theo dõi đơn hàng bằng link này: tracking.shop.com/ORD-2026-002847',
        timestamp: baseTime.add(const Duration(minutes: 8)),
        isMe: false,
        senderName: 'AI Assistant',
        isPending: false,
        readStatus: MessageReadStatus.read,
      ),

      // 8. Support gives more info
      Message(
        id: 8,
        content:
            "Hoặc bạn cũng có thể kiểm tra trong section 'Đơn Hàng Của Tôi' trên ứng dụng.",
        timestamp: baseTime.add(const Duration(minutes: 9)),
        isMe: false,
        senderName: 'AI Assistant',
        isPending: false,
        readStatus: MessageReadStatus.read,
        reactions: [
          const Reaction(emoji: '❤️', userNames: ['You']),
        ],
      ),

      // 9. Customer satisfied
      Message(
        id: 9,
        content: 'Quá tốt rồi! Còn có câu hỏi gì khác không?',
        timestamp: baseTime.add(const Duration(minutes: 11)),
        isMe: true,
        senderName: 'You',
        isPending: false,
        readStatus: MessageReadStatus.read,
      ),

      // 10. Support offers more help
      Message(
        id: 10,
        content:
            'Nếu có bất kỳ vấn đề gì, hãy liên hệ với chúng tôi bất cứ lúc nào! 😊',
        timestamp: baseTime.add(const Duration(minutes: 12)),
        isMe: false,
        senderName: 'AI Assistant',
        isPending: false,
        readStatus: MessageReadStatus.delivered,
      ),

      // 11. Customer sends latest message
      Message(
        id: 11,
        content: 'Cảm ơn rất nhiều vì sự hỗ trợ tuyệt vời!',
        timestamp: baseTime.add(const Duration(minutes: 13)),
        isMe: true,
        senderName: 'You',
        isPending: false,
        readStatus: MessageReadStatus.sent,
      ),
    ];
  }
}
