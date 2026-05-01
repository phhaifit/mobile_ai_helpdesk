import 'package:ai_helpdesk/data/network/apis/chat/chat_api.dart';
import 'package:ai_helpdesk/data/network/utils/helpdesk_error_mapper.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_room.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_room_counter.dart';
import 'package:ai_helpdesk/domain/entity/chat/seen_info.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';
import 'package:dio/dio.dart';

import 'utils.dart';

class ChatRoomRepositoryImpl implements ChatRoomRepository {
  final ChatApi _chatApi;

  ChatRoomRepositoryImpl(this._chatApi);

  @override
  Future<List<ChatRoom>> getChatRooms({
    ChatRoomListQuery query = ChatRoomListQuery.inboxDefault,
  }) async {
    try {
      final dto = await _chatApi.getChatRoomList(params: mapQuery(query));

      return dto.map((e) => e.toDomain()).toList();
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }

  @override
  Future<ChatRoomCounter> getChatRoomCounters({
    String? customerName,
    bool getAll = false,
  }) async {
    try {
      final dto = await _chatApi.getChatRoomCounters(
        customerName: customerName,
        getAll: getAll,
      );
      return ChatRoomCounter(
        open: dto.open,
        pending: dto.pending,
        solved: dto.solved,
        closed: dto.closed,
      );
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }

  @override
  Future<List<ChatRoom>> getChatRoomDetail({
    String? chatRoomId,
    String? customerId,
  }) async {
    try {
      final dto = await _chatApi.getChatRoomDetail(
        chatRoomId: chatRoomId,
        customerId: customerId,
      );
      return dto.map((e) => e.toDomain()).toList();
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }

  @override
  Future<SeenInfo> markChatRoomAsSeen({
    required String chatRoomId,
    required String messageId,
    required int messageOrder,
    String? socketId,
  }) async {
    try {
      final dto = await _chatApi.markChatRoomAsSeen(
        chatRoomId: chatRoomId,
        messageId: messageId,
        messageOrder: messageOrder,
        socketId: socketId,
      );
      return dto.toDomain();
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }
}