import 'package:ai_helpdesk/data/network/apis/chat/chat_api.dart';
import 'package:ai_helpdesk/data/network/dto/chat_room_dto.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_room.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';

class ChatRoomRepositoryNetworkImpl implements ChatRoomRepository {
  final ChatApi _chatApi;

  ChatRoomRepositoryNetworkImpl(this._chatApi);

  @override
  Future<List<ChatRoom>> getChatRooms() async {
    final raw = await _chatApi.getChatRoomList(getCounter: false, getAll: true);
    final data = raw['data'];
    if (data is! List) {
      return const [];
    }

    final rooms = data
        .whereType<Map<dynamic, dynamic>>()
        .map((r) => ChatRoomDto.fromJson(r.cast<String, dynamic>()))
        .map(_toDomain)
        .toList();

    return rooms;
  }

  ChatRoom _toDomain(ChatRoomDto dto) {
    final name = dto.customerInfo?.name.isNotEmpty == true
        ? dto.customerInfo!.name
        : 'Unknown';

    final lastContent = '';
        (dto.lastMessage?.contentInfo?['content'] is String
            ? dto.lastMessage!.contentInfo!['content'] as String
            : '');
    final lastTime = dto.lastMessage?.createdAt ?? dto.updatedAt ?? DateTime.now();

    final seenOrder = dto.seenMessageOrder ?? 0;
    final unread = (dto.totalMessage - seenOrder) < 0 ? 0 : (dto.totalMessage - seenOrder);

    return ChatRoom(  
      id: dto.chatRoomID,
      name: name,
      avatarInitials: _initials(name),
      lastMessage: lastContent,
      lastMessageIsMe: false,
      lastMessageTime: lastTime,
      unreadCount: unread,
      isActive: true,
      isAI: false,
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    final a = parts.first.substring(0, 1).toUpperCase();
    final b = parts.last.substring(0, 1).toUpperCase();
    return '$a$b';
  }
}

