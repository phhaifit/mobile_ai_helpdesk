class ChatRoomMarkedAsSeenEvent {
  static const String name = 'SOCKET_SEEN_CHAT_ROOM';

  final String chatRoomId;
  final String customerSupportId;
  final String messageId;
  final int messageOrder;
  final int? numberMessageSeen;

  ChatRoomMarkedAsSeenEvent({
    required this.chatRoomId,
    required this.customerSupportId,
    required this.messageId,
    required this.messageOrder,
    this.numberMessageSeen,
  });

  static ChatRoomMarkedAsSeenEvent? parse(dynamic payload) {
    if (payload is! Map) return null;
    final m = payload.cast<String, dynamic>();
    final chatRoomId = (m['chatRoomID'] ?? '').toString();
    final customerSupportId = (m['customerSupportID'] ?? '').toString();
    final messageId = (m['messageID'] ?? '').toString();
    final order = m['messageOrder'];
    if (chatRoomId.isEmpty ||
        customerSupportId.isEmpty ||
        messageId.isEmpty ||
        order is! num) {
      return null;
    }
    final Object? numberSeen = m['numberMessageSeen'];
    return ChatRoomMarkedAsSeenEvent(
      chatRoomId: chatRoomId,
      customerSupportId: customerSupportId,
      messageId: messageId,
      messageOrder: order.toInt(),
      numberMessageSeen:
          numberSeen is num ? numberSeen.toInt() : null,
    );
  }
}

