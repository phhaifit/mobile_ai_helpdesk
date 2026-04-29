import 'package:dio/dio.dart';

import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';

class TicketApi {
  final Dio _dio;

  TicketApi(DioClient dioClient) : _dio = dioClient.dio;

  /// GET /api/ticket/ticket-history-customer/{customerID}
  Future<List<dynamic>> getCustomerHistory(String customerId) async {
    final response = await _dio.get(Endpoints.ticketHistoryCustomer(customerId));
    return _parseList(response.data);
  }

  /// GET /api/ticket/{ticketId}
  ///
  /// Returns the raw ticket map (including chatRoomId) for internal use by the
  /// repository when resolving a chatRoomId from a ticketId.
  Future<Map<String, dynamic>> getTicketDetail(String ticketId) async {
    final response = await _dio.get(Endpoints.ticketDetail(ticketId));
    final data = response.data;
    if (data is Map) {
      final inner = data['data'];
      if (inner is Map) return Map<String, dynamic>.from(inner);
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }

  List<dynamic> _parseList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    return const [];
  }
}
