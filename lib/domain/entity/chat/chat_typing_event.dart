class ChatTypingEvent {
  final String chatRoomId;
  final bool isTyping;
  final String? actorName;

  const ChatTypingEvent({
    required this.chatRoomId,
    required this.isTyping,
    this.actorName,
  });
}
