class ChatRoomSeenUpdate {
  final String chatRoomId;
  final String messageId;
  final int messageOrder;
  final String customerSupportId;
  final int? numberMessageSeen;

  const ChatRoomSeenUpdate({
    required this.chatRoomId,
    required this.messageId,
    required this.messageOrder,
    required this.customerSupportId,
    this.numberMessageSeen,
  });
}
