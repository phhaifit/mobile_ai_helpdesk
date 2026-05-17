class MessageReactionUpdate {
  final String messageReactionId;
  final String messageId;
  final String chatRoomId;
  final String emoji;
  final int amount;
  final String? customerId;
  final String? customerSupportId;
  final String? customerSupportName;
  final String? customerSupportAvatar;
  final bool isRemoved;

  const MessageReactionUpdate({
    required this.messageReactionId,
    required this.messageId,
    required this.chatRoomId,
    required this.emoji,
    required this.amount,
    this.customerId,
    this.customerSupportId,
    this.customerSupportName,
    this.customerSupportAvatar,
    this.isRemoved = false,
  });
}
