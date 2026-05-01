class ChatRoom {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isActive;
  final bool isAI;

  /// Up to two initials derived from [name] for avatar placeholders.
  String get avatarInitials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    final single = parts[0];
    return single.length >= 2
        ? single.substring(0, 2).toUpperCase()
        : single[0].toUpperCase();
  }

  final String lastMessage;
  final bool lastMessageIsMe;
  final DateTime lastMessageTime;
  final int unreadCount;

  const ChatRoom({
    required this.id,
    required this.name,
    required this.avatarUrl,
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
    bool? isAI,
  }) {
    return ChatRoom(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageIsMe: lastMessageIsMe ?? this.lastMessageIsMe,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isActive: isActive ?? this.isActive,
      isAI: isAI ?? this.isAI,
    );
  }
}
