import 'channel.dart';

class ChatRoom {
  final String id;
  final String name;
  final String avatarUrl;
  final String appAvatarUrl;
  final Channel channel;
  final bool isActive;
  final bool isAI;
  final String lastMessage;
  final bool lastMessageIsMe;
  final DateTime lastMessageTime;
  final int unreadCount;

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


  const ChatRoom({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.appAvatarUrl,
    required this.lastMessage,
    required this.lastMessageIsMe,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isActive,
    required this.isAI,
    required this.channel,
  });

  ChatRoom copyWith({
    int? unreadCount,
    String? lastMessage,
    bool? lastMessageIsMe,
    DateTime? lastMessageTime,
    bool? isActive,
    bool? isAI,
    Channel? channel,
    String? appAvatarUrl,
  }) {
    return ChatRoom(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      appAvatarUrl: appAvatarUrl ?? this.appAvatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageIsMe: lastMessageIsMe ?? this.lastMessageIsMe,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isActive: isActive ?? this.isActive,
      isAI: isAI ?? this.isAI,
      channel: channel ?? this.channel,
    );
  }
}
