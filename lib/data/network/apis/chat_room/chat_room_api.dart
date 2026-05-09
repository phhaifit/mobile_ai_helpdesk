import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/data/network/dto/chat_room/chat_room_dto.dart';

class ChatRoomApi {
  final DioClient _dioClient;

  ChatRoomApi(this._dioClient);

  Future<List<ChatRoomDto>> getCustomerChatRooms(String customerId) async {
    final response = await _dioClient.dio.get(
      Endpoints.chatRoomDetail(),
      queryParameters: {'customerId': customerId},
    );

    final data = response.data;

    final dynamic payload;
    if (data is Map<String, dynamic>) {
      payload =
          data['data'] ?? data['result'] ?? data['chatRooms'] ?? data['rooms'];
    } else {
      payload = data;
    }

    if (payload == null) return [];

    if (payload is List) {
      return payload
          .whereType<Map<String, dynamic>>()
          .map(ChatRoomDto.fromJson)
          .toList();
    }

    if (payload is Map<String, dynamic>) {
      final items = payload['items'] ?? payload['data'];
      if (items is List) {
        return items
            .whereType<Map<String, dynamic>>()
            .map(ChatRoomDto.fromJson)
            .toList();
      }
    }

    return [];
  }

  Future<List<MessageDto>> getChatRoomMessages({
    required String chatRoomId,
    int limit = 20,
    String? lastMessageId,
  }) async {
    final response = await _dioClient.dio.get(
      Endpoints.chatRoomMessages(),
      queryParameters: {
        'chatRoomId': chatRoomId,
        'limit': limit,
        if (lastMessageId != null) 'lastMessageId': lastMessageId,
      },
    );

    final data = response.data;

    final dynamic payload;
    if (data is Map<String, dynamic>) {
      payload =
          data['data'] ?? data['result'] ?? data['messages'] ?? data['items'];
    } else {
      payload = data;
    }

    if (payload == null) return [];

    if (payload is List) {
      return payload
          .whereType<Map<String, dynamic>>()
          .map(MessageDto.fromJson)
          .toList();
    }

    if (payload is Map<String, dynamic>) {
      final items = payload['items'] ?? payload['data'];
      if (items is List) {
        return items
            .whereType<Map<String, dynamic>>()
            .map(MessageDto.fromJson)
            .toList();
      }
    }

    return [];
  }
}
