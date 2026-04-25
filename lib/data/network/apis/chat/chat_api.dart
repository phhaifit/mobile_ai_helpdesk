import 'package:ai_helpdesk/data/network/apis/chat/models/message_list_dto.dart';

import '/core/data/network/dio/dio_client.dart';
import '/data/network/constants/endpoints.dart';
import 'models/chat_room_counter_dto.dart';
import 'models/chat_room_dto.dart';
import 'models/message_dto.dart';
import 'models/message_group_dto.dart';
import 'models/message_reaction_dto.dart';
import 'models/seen_info_dto.dart';
import 'params/fetch_chat_rooms_params.dart';
import 'params/react_message_params.dart';
import 'params/send_cs_message_to_customer_params.dart';

class ChatApi {
  final DioClient _dioClient;

  ChatApi(this._dioClient);

  /// Returns ticket-status-based counters for chat rooms.
  /// 
  /// Keys are dynamic status strings (open, pending, solved, closed), values are counts.
  Future<List<ChatRoomDto>> getChatRoomList({
    required FetchChatRoomsParams params,
  }) async {
    final res = await _dioClient.dio.get(
      Endpoints.chatRoom(),
      queryParameters: params.toJson(),
    );

    return (res.data as List).map((e) => ChatRoomDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  
  /// Returns ticket-status-based counters for chat rooms.
  /// 
  /// Keys are dynamic status strings (open, pending, solved, closed), values are counts.
  Future<ChatRoomCounterDto> getChatRoomCounters({
    String? customerName,
    bool getAll = false,
  }) async {
    final res = await _dioClient.dio.get(
      Endpoints.chatRoomCounter(),
      queryParameters: {
        if (customerName != null) 'customerName': customerName,
        'getAll': getAll,
      },
    );
    return ChatRoomCounterDto.fromJson((res.data as List)[0] as Map<String, dynamic>);
  }

  Future<List<ChatRoomDto>> getChatRoomDetail({
    String? chatRoomId,
    String? customerId,
  }) async {
    final res = await _dioClient.dio.get(
      Endpoints.chatRoomDetail(),
      queryParameters: {
        if (chatRoomId != null) 'chatRoomID': chatRoomId,
        if (customerId != null) 'customerID': customerId,
      },
    );
    return (res.data as List).map((e) => ChatRoomDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Returns messages for a chat room with cursor-based pagination.
  /// 
  /// Messages are sorted by messageOrder DESC (newest first).
  /// 
  /// The response uses entity normalization: shared objects (channels, senders, tickets) are extracted into entities to avoid duplication.
  Future<MessageListDto> getMessageList({
    String? chatRoomId,
    String? customerId,
    String? lastMessageId,
    int limit = 20,
  }) async {
    final res = await _dioClient.dio.get(
      Endpoints.message(),
      queryParameters: {
        'chatRoomID': chatRoomId,
        if (customerId != null) 'customerID': customerId,
        if (lastMessageId != null) 'lastMessageID': lastMessageId,
        'limit': limit,
      },
    );
    return MessageListDto.fromJson(res.data as Map<String, dynamic>);
  }

  /// Fetches messages newer than lastMessageID (ascending order).
  ///
  /// Used for real-time catch-up when the app reconnects or scrolls down.
  Future<MessageListDto> getNewerMessages({
    required String chatRoomId,
    String? lastMessageId,
    int limit = 20,
  }) async {
    final res = await _dioClient.dio.get(
      Endpoints.newerMessage(),
      queryParameters: {
        'chatRoomID': chatRoomId,
        if (lastMessageId != null) 'lastMessageID': lastMessageId,
        'limit': limit,
      },
    );
    return MessageListDto.fromJson(res.data as Map<String, dynamic>);
  }

  /// Sends a message from a customer support agent to a customer.
  /// 
  /// Supports text, file attachments, reply threading, and auto-reply flag.
  /// 
  /// After sending, the message is broadcast via the appropriate Socket.io
  /// channel event (e.g., SOCKET_MESSENGER_MESSAGE, SOCKET_ZALO_MESSAGE).
  Future<MessageDto> sendMessageFromAgentToCustomer({
    required SendCsMessageToCustomerParams params,
  }) async {
    final res = await _dioClient.dio.post(
      Endpoints.csToCustomer(),
      data: params.toJson(),
    );
    return MessageDto.fromJson(res.data as Map<String, dynamic>);
  }

  /// Marks a chat room as read up to a specific message.
  /// 
  /// Broadcasts `SOCKET_SEEN_CHAT_ROOM` to other connected agents.
  Future<SeenInfoDto> markChatRoomAsSeen({
    required String chatRoomId,
    required String messageId,
    required int messageOrder,
    String? socketId,
  }) async {
    final res = await _dioClient.dio.post(
      Endpoints.chatRoomSeen(),
      data: {
        'chatRoomID': chatRoomId,
        'messageID': messageId,
        'messageOrder': messageOrder,
        if (socketId != null) 'socketID': socketId,
      },
    );
    return SeenInfoDto.fromJson(res.data as Map<String, dynamic>);
  }

  /// Adds an emoji reaction to a message.
  /// 
  /// Broadcasts `SOCKET_REACT_MESSAGE` to other connected agents.
  Future<MessageReactionDto> reactToMessage({
    required ReactMessageParams params,
  }) async {
    final res = await _dioClient.dio.post(
      Endpoints.reactToMessage(),
      data: params.toJson(),
    );
    return MessageReactionDto.fromJson(res.data as Map<String, dynamic>);
  }

  /// Removes an emoji reaction.
  /// 
  /// Broadcasts `SOCKET_REACT_MESSAGE` update.
  Future<bool> unreactMessage({
    required ReactMessageParams params,
  }) async {
    final res = await _dioClient.dio.post(
      Endpoints.unreactToMessage(),
      data: params.toJson(),
    );
    return res.data['success'] as bool? ?? false;
  } 

  /// Counts the number of search results in a chat room.
  /// 
  /// Returns 0 if no results are found.
  Future<int> countSearchResultsInChatRoom({
    required String chatRoomId,
    required String keyword,
  }) async {
    final res = await _dioClient.dio.get(
      Endpoints.countSearchResult(chatRoomId),
      queryParameters: {
        'keyword': keyword,
      },
    );
    return res.data as int? ?? 0;
  }

  /// Returns search results grouped by chat room, useful for global search UI.
  Future<List<MessageGroupDto>> searchMessagesGroupedByChatRoom({
    required String keyword,
  }) async {
    final res = await _dioClient.dio.get(
      Endpoints.searchGroupedByChatRoomMessage(),
      queryParameters: {
        'keyword': keyword,
      },
    );
    return (res.data as List).map((e) => MessageGroupDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Returns a flat list of messages matching the keyword, optionally scoped to a chat room.
  Future<MessageListDto> flatSearchMessageList({
    required String keyword,
    String? chatRoomId,
  }) async {
    final res = await _dioClient.dio.get(
      Endpoints.flatSearchMessageList(),
      queryParameters: {
        'keyword': keyword,
        if (chatRoomId != null) 'chatRoomId': chatRoomId,
      },
    );
    return MessageListDto.fromJson(res.data as Map<String, dynamic>);
  }

  /// BE proxy to AI-Services.
  Future<Map<String, dynamic>> analyzeTicketInChatRoomAi({
    required String chatRoomId,
    String? ticketId,
  }) async {
    final res = await _dioClient.dio.post(
      Endpoints.chatRoomAnalyzeTicket(),
      data: {
        'chatRoomId': chatRoomId,
        if (ticketId != null) 'ticketId': ticketId,
      },
    );
    return (res.data as Map).cast<String, dynamic>();
  }

  /// BE proxy to AI-Services.
  /// 
  /// Returns a taskId for async processing.
  Future<Map<String, dynamic>> generateAiDraftResponse({
    required String chatRoomId,
    String? ticketId,
  }) async {
    final res = await _dioClient.dio.post(
      Endpoints.draftResponse(),
      data: {
        'chatRoomId': chatRoomId,
        if (ticketId != null) 'ticketId': ticketId,
      },
    );
    return (res.data as Map).cast<String, dynamic>();
  }
}

