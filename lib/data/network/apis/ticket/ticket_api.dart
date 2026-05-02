import 'package:dio/dio.dart';

import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';

class TicketApi {
  final Dio _dio;

  TicketApi(DioClient dioClient) : _dio = dioClient.dio;

  /// GET /api/ticket/customer-ticket?customerId={id}
  Future<List<dynamic>> getCustomerTickets(String customerId) async {
    final response = await _dio.get(
      Endpoints.ticketCustomerHistory,
      queryParameters: {'customerId': customerId},
    );
    return _parseList(response.data);
  }

  /// GET /api/ticket/comment/get-comment/{ticketId}
  Future<List<dynamic>> getComments(String ticketId) async {
    final response = await _dio.get(Endpoints.ticketComments(ticketId));
    return _parseList(response.data);
  }

  /// POST /api/ticket/comment/add-comment
  Future<Map<String, dynamic>> addComment(
    String ticketId,
    String content,
  ) async {
    final response = await _dio.post(
      Endpoints.ticketAddComment,
      data: {'ticketId': ticketId, 'content': content},
    );
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    return {};
  }

  /// DELETE /api/ticket/comment/{id}
  Future<void> deleteComment(String commentId) async {
    await _dio.delete(Endpoints.ticketDeleteComment(commentId));
  }

  /// Handles both direct list response and wrapped `{ "data": [...] }` format.
  List<dynamic> _parseList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    return const [];
  }
}
