class ChatRoom {
  final String id;
  final String name;
  final String avatarInitials;
  final String lastMessage;
  final bool lastMessageIsMe;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isActive;
  final bool isAI;

  const ChatRoom({
    required this.id,
    required this.name,
    required this.avatarInitials,
    required this.lastMessage,
    required this.lastMessageIsMe,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isActive,
    required this.isAI,
  });

  ChatRoom copyWith({
    int? unreadCount,
    String? lastMessage,
    bool? lastMessageIsMe,
    DateTime? lastMessageTime,
    bool? isActive,
  }) {
    return ChatRoom(
      id: id,
      name: name,
      avatarInitials: avatarInitials,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageIsMe: lastMessageIsMe ?? this.lastMessageIsMe,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isActive: isActive ?? this.isActive,
      isAI: isAI,
    );
  }
}
