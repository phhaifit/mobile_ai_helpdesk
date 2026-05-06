import 'package:dio/dio.dart';

import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';

class TicketApi {
  final Dio _dio;

  TicketApi(DioClient dioClient) : _dio = dioClient.dio;

  /// GET /api/ticket/all
  Future<List<dynamic>> getAllTickets({
    int offset = 0,
    int limit = 20,
    String? search,
  }) async {
    final response = await _dio.get(
      Endpoints.ticketAll,
      queryParameters: _buildQuery(
        offset: offset,
        limit: limit,
        search: search,
      ),
    );
    return _parseList(response.data);
  }

  /// GET /api/ticket/my-ticket
  Future<List<dynamic>> getMyTickets({int offset = 0, int limit = 20}) async {
    final response = await _dio.get(
      Endpoints.ticketMy,
      queryParameters: _buildQuery(offset: offset, limit: limit),
    );
    return _parseList(response.data);
  }

  /// GET /api/ticket/mine-by-status?status={status}
  Future<List<dynamic>> getMyTicketsByStatus(String status) async {
    final response = await _dio.get(
      Endpoints.ticketMyByStatus,
      queryParameters: {'status': status},
    );
    return _parseList(response.data);
  }

  /// GET /api/ticket/unassigned
  Future<List<dynamic>> getUnassignedTickets({
    int offset = 0,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      Endpoints.ticketUnassigned,
      queryParameters: _buildQuery(offset: offset, limit: limit),
    );
    return _parseList(response.data);
  }

  /// GET /api/ticket/{ticketID}
  Future<Map<String, dynamic>> getTicketDetail(String ticketId) async {
    final response = await _dio.get(Endpoints.ticketDetail(ticketId));
    return _parseMap(response.data);
  }

  /// POST /api/ticket/new
  Future<Map<String, dynamic>> createTicket({
    required String title,
    String? description,
    required String customerId,
    String? priority,
  }) async {
    final response = await _dio.post(
      Endpoints.ticketCreate,
      data: {
        'title': title,
        if (description != null) 'description': description,
        'customerId': customerId,
        if (priority != null) 'priority': priority,
      },
    );
    return _parseMap(response.data);
  }

  /// POST /api/ticket/my-ticket/{id}/detail
  Future<Map<String, dynamic>> updateTicketDetail({
    required String ticketId,
    String? title,
    String? priority,
    String? assigneeId,
    bool includeAssigneeId = false,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (priority != null) data['priority'] = priority;
    if (includeAssigneeId || assigneeId != null) {
      data['assigneeId'] = assigneeId;
    }

    final response = await _dio.post(
      Endpoints.ticketUpdateDetail(ticketId),
      data: data,
    );
    return _parseMap(response.data);
  }

  /// POST /api/ticket/update-status
  Future<Map<String, dynamic>> updateTicketStatus({
    required String ticketId,
    required String status,
  }) async {
    final response = await _dio.post(
      Endpoints.ticketUpdateStatus,
      data: {'ticketId': ticketId, 'status': status},
    );
    return _parseMap(response.data);
  }

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
    if (data is Map && data['items'] is List) return data['items'] as List;
    if (data is Map && data['data'] is Map && data['data']['items'] is List) {
      return data['data']['items'] as List;
    }
    return const [];
  }

  /// Handles direct object response and wrapped `{ "data": { ... } }` format.
  Map<String, dynamic> _parseMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map && data['data'] is Map<String, dynamic>) {
      return data['data'] as Map<String, dynamic>;
    }
    return const {};
  }

  Map<String, dynamic> _buildQuery({
    int offset = 0,
    int limit = 20,
    String? search,
  }) {
    final query = <String, dynamic>{'offset': offset, 'limit': limit};
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }
    return query;
  }
}
