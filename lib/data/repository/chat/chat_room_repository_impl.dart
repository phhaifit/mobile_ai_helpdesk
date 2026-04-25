import 'package:ai_helpdesk/data/network/apis/chat/chat_api.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/chat_room_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/params/fetch_chat_rooms_params.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_room.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';

class ChatRoomRepositoryImpl implements ChatRoomRepository {
  final ChatApi _chatApi;

  ChatRoomRepositoryImpl(this._chatApi);

  @override
  Future<List<ChatRoom>> getChatRooms() async {
    final raw = await _chatApi.getChatRoomList(params: FetchChatRoomsParams(getCounter: false, getAll: true));
    return raw.map(_toDomain).toList();
  }

  ChatRoom _toDomain(ChatRoomDto dto) {
    final name = dto.customerInfo?.name ?? 'Unknown';

    final lastContent = dto.lastMessage?.contentInfo['content'] as String? ?? '';
    final lastTime = dto.lastMessage?.createdAt ?? DateTime.now();

    return ChatRoom(
      id: dto.chatRoomId,
      name: name,
      avatarInitials: _initials(name),
      lastMessage: lastContent,
      lastMessageIsMe: dto.lastMessage?.sender == dto.customerId,
      lastMessageTime: lastTime,
      unreadCount: dto.totalMessage - dto.seenMessageOrder,
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
