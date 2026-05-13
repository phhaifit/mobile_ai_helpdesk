import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/data/network/dto/chat_room/chat_room_dto.dart';

class ChatRoomApi {
  final DioClient _dioClient;

  ChatRoomApi(this._dioClient);

  /// GET the chat rooms belonging to a single customer.
  ///
  /// Backend is still finalising the route shape: this call targets the
  /// placeholder `/api/customer/{id}/conversations` URL and will 404 until
  /// BE either ships that route or adds a `customerID` filter to
  /// `/api/chat-room`. The repository layer maps the 404 to mock data in
  /// debug builds so the customer-detail timeline stays renderable.
  Future<List<ChatRoomDto>> getByCustomer(String customerId) async {
    final response = await _dioClient.dio.get(
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
