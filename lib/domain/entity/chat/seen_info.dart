class SeenInfo {
  final String chatRoomSeenId;
  final String chatRoomId;
  final String customerSupportId;
  final String messageId;
  final int messageOrder;
  final int numberMessageSeen;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SeenInfo({
    required this.chatRoomSeenId,
    required this.chatRoomId,
    required this.customerSupportId,
    required this.messageId,
    required this.messageOrder,
    required this.numberMessageSeen,
    required this.createdAt,
    required this.updatedAt,
  });
}
