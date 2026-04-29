import 'package:dio/dio.dart';

import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';

class ChatRoomApi {
  final Dio _dio;

  ChatRoomApi(DioClient dioClient) : _dio = dioClient.dio;

  /// GET /api/chat-room/message?chatRoomID={id}&limit={limit}
  ///
  /// Response: { data: { messages: [...], entities: {...} } }
  Future<List<dynamic>> getMessages(String chatRoomId, {int limit = 20}) async {
    final response = await _dio.get(
      Endpoints.chatRoomMessages,
      queryParameters: {'chatRoomID': chatRoomId, 'limit': limit},
    );
    final data = response.data;
    if (data is Map) {
      final inner = data['data'];
      if (inner is Map && inner['messages'] is List) {
        return inner['messages'] as List;
      }
    }
    return const [];
  }

  /// POST /api/chat-room/message/cs-to-customer
  ///
  /// Body: { chatRoomID, channelID, content, contactID? }
  /// Response: { data: Message }
  Future<Map<String, dynamic>> sendMessage({
    required String chatRoomId,
    required String channelId,
    required String content,
    String? contactId,
  }) async {
    final body = <String, dynamic>{
      'chatRoomID': chatRoomId,
      'channelID': channelId,
      'content': content,
      if (contactId != null) 'contactID': contactId,
    };
    final response = await _dio.post(Endpoints.chatRoomSendMessage, data: body);
    final data = response.data;
    if (data is Map && data['data'] is Map) {
      return Map<String, dynamic>.from(data['data'] as Map);
    }
    return const {};
  }

  /// GET /api/chat-room/detail?chatRoomID={id}
  ///
  /// Response: { data: [ChatRoom] }
  /// Returns the first ChatRoom object or empty map.
  Future<Map<String, dynamic>> getChatRoomDetail(String chatRoomId) async {
    final response = await _dio.get(
      Endpoints.chatRoomDetail,
      queryParameters: {'chatRoomID': chatRoomId},
    );
    final data = response.data;
    if (data is Map) {
      final list = data['data'];
      if (list is List && list.isNotEmpty && list[0] is Map) {
        return Map<String, dynamic>.from(list[0] as Map);
      }
    }
    return const {};
  }
}
