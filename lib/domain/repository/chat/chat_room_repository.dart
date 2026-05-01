import '../../../domain/entity/chat/chat_room.dart';
import '../../../domain/entity/chat/chat_room_counter.dart';
import '../../../domain/entity/chat/seen_info.dart';

abstract class ChatRoomRepository {
  Future<List<ChatRoom>> getChatRooms({
    ChatRoomListQuery query = ChatRoomListQuery.inboxDefault,
  });

  Future<ChatRoomCounter> getChatRoomCounters({
    String? customerName,
    bool getAll = false,
  });

  Future<List<ChatRoom>> getChatRoomDetail({
    String? chatRoomId,
    String? customerId,
  });

  Future<SeenInfo> markChatRoomAsSeen({
    required String chatRoomId,
    required String messageId,
    required int messageOrder,
    String? socketId,
  });
}

class ChatRoomListQuery {
  final String? customerName;
  final int limit;
  final String? lastMessageId;
  final String? lastChatRoomId;
  final String? lastChatRoomUpdatedAt;
  final String? status;
  final List<String>? statuses;
  final List<String>? channels;
  final List<String>? channelIds;
  final DateTime? updatedAtFrom;
  final DateTime? updatedAtTo;
  final bool getCounter;
  final bool getAll;

  const ChatRoomListQuery({
    this.customerName,
    this.limit = 20,
    this.lastMessageId,
    this.lastChatRoomId,
    this.lastChatRoomUpdatedAt,
    this.status,
    this.statuses,
    this.channels,
    this.channelIds,
    this.updatedAtFrom,
    this.updatedAtTo,
    this.getCounter = false,
    this.getAll = false,
  });

  /// Previous impl used fixed params: full list without counters.
  static const inboxDefault = ChatRoomListQuery(
    getCounter: false,
    getAll: true,
    limit: 20,
  );
}
