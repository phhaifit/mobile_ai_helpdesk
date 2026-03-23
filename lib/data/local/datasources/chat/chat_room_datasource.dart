import '../../../../domain/entity/chat/chat_room.dart';

class ChatRoomDataSource {
  Future<List<ChatRoom>> getMockChatRooms() async {
    final now = DateTime.now();
    return [
      ChatRoom(
        id: '1',
        name: 'Jarvis AI',
        avatarInitials: 'AI',
        lastMessage: 'Tôi có thể giúp gì cho bạn?',
        lastMessageIsMe: false,
        lastMessageTime: now.subtract(const Duration(minutes: 2)),
        unreadCount: 3,
        isActive: true,
        isAI: true,
      ),
      ChatRoom(
        id: '2',
        name: 'Tech Support',
        avatarInitials: 'TS',
        lastMessage: 'Your issue has been resolved.',
        lastMessageIsMe: false,
        lastMessageTime: now.subtract(const Duration(hours: 1)),
        unreadCount: 0,
        isActive: false,
        isAI: false,
      ),
      ChatRoom(
        id: '3',
        name: 'Sales Team',
        avatarInitials: 'ST',
        lastMessage: 'New promotion is live!',
        lastMessageIsMe: false,
        lastMessageTime: now.subtract(const Duration(hours: 3)),
        unreadCount: 7,
        isActive: true,
        isAI: false,
      ),
      ChatRoom(
        id: '4',
        name: 'HR Helpdesk',
        avatarInitials: 'HR',
        lastMessage: 'You: Thanks for the update.',
        lastMessageIsMe: true,
        lastMessageTime: now.subtract(const Duration(days: 1)),
        unreadCount: 0,
        isActive: false,
        isAI: false,
      ),
      ChatRoom(
        id: '5',
        name: 'Billing Support',
        avatarInitials: 'BS',
        lastMessage: 'Your invoice is ready.',
        lastMessageIsMe: false,
        lastMessageTime: now.subtract(const Duration(days: 2)),
        unreadCount: 1,
        isActive: false,
        isAI: false,
      ),
      ChatRoom(
        id: '6',
        name: 'General Announcements',
        avatarInitials: 'GA',
        lastMessage: 'System maintenance on Friday.',
        lastMessageIsMe: false,
        lastMessageTime: now.subtract(const Duration(days: 3)),
        unreadCount: 0,
        isActive: true,
        isAI: false,
      ),
    ];
  }
}
