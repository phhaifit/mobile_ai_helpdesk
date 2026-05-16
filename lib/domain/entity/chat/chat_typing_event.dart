class ChatTypingEvent {
  final String chatRoomId;
  final bool isTyping;
  final String? actorName;
  final String? customerSupportId;

  const ChatTypingEvent({
    required this.chatRoomId,
    required this.isTyping,
    this.actorName,
    this.customerSupportId,
  });
}
