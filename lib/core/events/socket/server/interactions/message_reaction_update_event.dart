class MessageReactionUpdateEvent {
  static const String name = 'SOCKET_REACT_MESSAGE';

  final String messageReactionId;
  final String messageId;
  final String chatRoomId;
  final String emoji;
  final int amount;
  final String? customerId;
  final String? customerSupportId;
  final String? customerSupportName;
  final String? customerSupportAvatar;
  final DateTime? deletedAt;

  MessageReactionUpdateEvent({
    required this.messageReactionId,
    required this.messageId,
    required this.chatRoomId,
    required this.emoji,
    required this.amount,
    required this.customerId,
    required this.customerSupportId,
    this.customerSupportName,
    this.customerSupportAvatar,
    this.deletedAt,
  });

  static MessageReactionUpdateEvent? parse(dynamic payload) {
    if (payload is! Map) return null;
    final m = payload.cast<String, dynamic>();
    final messageReactionId = (m['messageReactionID'] ?? '').toString();
    final messageId = (m['messageID'] ?? '').toString();
    final chatRoomId = (m['chatRoomID'] ?? '').toString();
    final emoji = (m['emoji'] ?? '').toString();
    final amount = m['amount'];
    if (messageReactionId.isEmpty ||
        messageId.isEmpty ||
        chatRoomId.isEmpty ||
        emoji.isEmpty ||
        amount is! num) {
      return null;
    }
    final String? deletedAtRaw = m['deletedAt']?.toString();
    return MessageReactionUpdateEvent(
      messageReactionId: messageReactionId,
      messageId: messageId,
      chatRoomId: chatRoomId,
      emoji: emoji,
      amount: amount.toInt(),
      customerId: m['customerID']?.toString(),
      customerSupportId: m['customerSupportID']?.toString(),
      customerSupportName: m['customerSupportName']?.toString(),
      customerSupportAvatar: m['customerSupportAvatar']?.toString(),
      deletedAt: deletedAtRaw != null && deletedAtRaw.isNotEmpty
          ? DateTime.tryParse(deletedAtRaw)
          : null,
    );
  }
}

