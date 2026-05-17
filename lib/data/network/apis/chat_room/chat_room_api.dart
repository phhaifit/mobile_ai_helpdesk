import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/data/network/dto/chat_room/chat_room_dto.dart';
import 'package:dio/dio.dart';

/// Low-level HTTP client for the chat-room endpoints.
///
/// Two responsibility groups coexist here:
///  * **Ticket comments (Sub-issue B)** — `getMessages`, `sendMessage`,
///    `getChatRoomDetail`. The ticket detail screen sources its live comments
///    from these endpoints + the Socket.io `SOCKET_MESSAGE` stream.
///  * **Customer detail timeline** — `getByCustomer`. Hits a placeholder URL
///    that 404s until BE finalises the customer-scoped chat-room route;
///    the repository falls back to mock data in debug builds.
class ChatRoomApi {
  final Dio _dio;

  ChatRoomApi(DioClient dioClient) : _dio = dioClient.dio;

  // ───────────────────────────────────────────────────────────────────────────
  // Sub-issue B — ticket detail live comments
  // ───────────────────────────────────────────────────────────────────────────

  /// GET /api/chat-room/message?chatRoomID={id}&limit={limit}
  ///
  /// Response: `{ data: { messages: [...], entities: {...} } }`
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
  /// Body: `{ chatRoomID, channelID, content, contactID? }`
  /// Response: `{ data: Message }`
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
  /// Response: `{ data: [ChatRoom] }`. Returns the first ChatRoom object or
  /// empty map when the room is missing.
  Future<Map<String, dynamic>> getChatRoomDetail(String chatRoomId) async {
    final response = await _dio.get(
      Endpoints.chatRoomDetail(),
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

  // ───────────────────────────────────────────────────────────────────────────
  // Customer detail timeline (from main)
  // ───────────────────────────────────────────────────────────────────────────

  /// GET the chat rooms belonging to a single customer.
  ///
  /// Backend is still finalising the route shape: this call targets the
  /// placeholder `/api/customer/{id}/conversations` URL and will 404 until
  /// BE either ships that route or adds a `customerID` filter to
  /// `/api/chat-room`. The repository layer maps the 404 to mock data in
  /// debug builds so the customer-detail timeline stays renderable.
  Future<List<ChatRoomDto>> getByCustomer(String customerId) async {
    final response = await _dio.get(
      Endpoints.customerConversations(customerId),
    );
    final data = response.data;
    if (data is! Map) return const <ChatRoomDto>[];
    final raw = data['data'];
    if (raw is! List) return const <ChatRoomDto>[];
    return raw
        .whereType<Map<dynamic, dynamic>>()
        .map((e) => ChatRoomDto.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false);
  }
}
