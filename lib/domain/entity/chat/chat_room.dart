import 'channel.dart';
import 'message.dart';

class ChatRoom {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? appAvatarUrl;
  final Channel channel;
  final String ticketId;
  final String contactId;
  final bool isAI;
  final Message lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  const ChatRoom({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.appAvatarUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isAI,
    required this.channel,
    required this.ticketId,
    required this.contactId,
  });

  ChatRoom copyWith({
    int? unreadCount,
    Message? lastMessage,
    DateTime? lastMessageTime,
    bool? isAI,
    Channel? channel,
    String? appAvatarUrl,
    String? ticketId,
    String? contactId,
  }) {
    return ChatRoom(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      appAvatarUrl: appAvatarUrl ?? this.appAvatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isAI: isAI ?? this.isAI,
      channel: channel ?? this.channel,
      ticketId: ticketId ?? this.ticketId,
      contactId: contactId ?? this.contactId,
    );
  }
}
