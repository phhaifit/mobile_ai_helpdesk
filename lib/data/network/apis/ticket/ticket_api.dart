import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/data/network/dto/ticket/ticket_dto.dart';
import 'package:dio/dio.dart';

class TicketApi {
  final Dio _dio;

  TicketApi(DioClient dioClient) : _dio = dioClient.dio;

  /// GET /ticket/all
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
    return _parseGroupedList(response.data);
  }

  /// GET /ticket/my-ticket
  Future<List<dynamic>> getMyTickets({int offset = 0, int limit = 20}) async {
    final response = await _dio.get(
      Endpoints.ticketMy,
      queryParameters: _buildQuery(offset: offset, limit: limit),
    );
    return _parseGroupedList(response.data);
  }

  /// GET /api/ticket/mine-by-status?status={status}
  Future<List<dynamic>> getMyTicketsByStatus(String status) async {
    final response = await _dio.get(
      Endpoints.ticketMyByStatus,
      queryParameters: {'status': status},
    );
    return _parseGroupedList(response.data);
  }

  /// GET /ticket/unassigned
  Future<List<dynamic>> getUnassignedTickets({
    int offset = 0,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      Endpoints.ticketUnassigned,
      queryParameters: _buildQuery(offset: offset, limit: limit),
    );
    return _parseGroupedList(response.data);
  }

  /// GET /api/ticket/ticket-history-customer/{customerID}
  Future<List<dynamic>> getCustomerHistory(String customerId) async {
    final response =
        await _dio.get(Endpoints.ticketHistoryCustomer(customerId));
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
    required String customerId,
    String? description,
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

  /// POST /ticket/my-ticket/{ticketId}/detail
  ///
  /// BE-canonical "update ticket fields" endpoint. The web client posts ONLY
  /// the fields it wants to change (plus `ticketID`), e.g.:
  ///   - status change: `{ticketID, status: "SOLVED"}`
  ///   - priority change: `{ticketID, priority: "HIGH"}`
  ///   - assign agent: `{ticketID, customerSupportID, status: "OPEN"}`
  ///
  /// All enum string values are UPPERCASE. Callers map domain enums via
  /// [TicketRepositoryImpl._mapStatusToApi] / `_mapPriorityToApi`.
  Future<Map<String, dynamic>> updateTicketDetail({
    required String ticketId,
    String? title,
    String? priority,
    String? status,
    String? customerSupportId,
    bool includeCustomerSupportId = false,
  }) async {
    final data = <String, dynamic>{'ticketID': ticketId};
    if (title != null) data['title'] = title;
    if (priority != null) data['priority'] = priority;
    if (status != null) data['status'] = status;
    if (includeCustomerSupportId || customerSupportId != null) {
      data['customerSupportID'] = customerSupportId;
    }

    final response = await _dio.post(
      Endpoints.ticketUpdateDetail(ticketId),
      data: data,
    );
    return _parseMap(response.data);
  }

  /// GET `/api/ticket/ticket-history-customer/{customerId}`.
  ///
  /// Backend contract:
  ///   - 200 OK → `{ status, data: { tickets: [...], total? }, message }`
  ///   - 404 with `data: []` (or `{tickets: []}`) → customer has no history;
  ///     this is the documented "empty" response and is mapped to `[]` here
  ///     rather than thrown.
  /// Other DioExceptions bubble up so the repository can decide whether to
  /// fall back to mock data.
  Future<List<TicketDto>> getCustomerTickets(
    String customerId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        Endpoints.ticketHistoryByCustomer(customerId),
        queryParameters: {'limit': limit, 'offset': offset},
      );
      return _parseTickets(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 &&
          _looksLikeEmptyHistory(e.response?.data)) {
        return const <TicketDto>[];
      }
      rethrow;
    }
  }

  /// Comments live under the ticket detail at `GET /ticket/{ticketID}`
  /// as the `commentsOfTicket` array — the BE doesn't ship a standalone
  /// "list comments" route. We reuse the detail endpoint and slice out
  /// just the comments list so callers don't have to know that.
  ///
  /// (Note: `loadTicket` in the store also fetches the same endpoint via
  /// [getTicketDetail]; the double call is acceptable for now — see the
  /// store-level TODO if we ever need to consolidate.)
  Future<List<dynamic>> getComments(String ticketId) async {
    final response = await _dio.get(Endpoints.ticketDetail(ticketId));
    final body = response.data;
    if (body is Map) {
      final data = body['data'];
      if (data is Map && data['commentsOfTicket'] is List) {
        return data['commentsOfTicket'] as List;
      }
    }
    return const <dynamic>[];
  }

  /// POST /ticket/comment/add-comment
  ///
  /// Payload uses the BE-canonical field names `ticketID` (note capital `D`)
  /// and `body` — not `ticketId`/`content` like the OpenAPI spec implies.
  ///
  /// Response shape (success):
  /// ```json
  /// {
  ///   "status": "OK",
  ///   "data": [{ "commentID": "...", "body": "...", "customerSupport": {...} }],
  ///   "message": "Tạo comment thành công"
  /// }
  /// ```
  /// `data` is a single-element list containing the new comment with the
  /// author resolved under `customerSupport`. Returns the first element so
  /// callers see the populated comment object directly.
  Future<Map<String, dynamic>> addComment(
    String ticketId,
    String content,
  ) async {
    final response = await _dio.post(
      Endpoints.ticketAddComment,
      data: {
        'ticketID': ticketId,
        'body': content,
        'files': const <dynamic>[],
      },
    );
    return _extractFirstComment(response.data);
  }

  /// Extracts the first comment object from the `addComment` response.
  /// BE wraps the new comment in `data: [{...}]`; older / fallback shapes
  /// may use `data: {...}` directly.
  Map<String, dynamic> _extractFirstComment(dynamic body) {
    if (body is Map) {
      final data = body['data'];
      if (data is List && data.isNotEmpty) {
        final first = data.first;
        if (first is Map<String, dynamic>) return first;
        if (first is Map) return Map<String, dynamic>.from(first);
      }
      if (data is Map<String, dynamic>) return data;
    }
    return const <String, dynamic>{};
  }

  /// DELETE /api/ticket/comment/{id}
  Future<void> deleteComment(String commentId) async {
    await _dio.delete(Endpoints.ticketDeleteComment(commentId));
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

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

  /// Parses the helpdesk `/ticket/*` list response shape:
  /// `{ status, message, data: [{ tickets: [...], total, totalAssigned, totalFollowed }] }`.
  /// When `getCounter=true` the BE wraps results in a single-element `data`
  /// array. Falls back to legacy shapes via [_parseList] if structure differs.
  List<dynamic> _parseGroupedList(dynamic data) {
    if (data is Map && data['data'] is List) {
      final outer = data['data'] as List;
      if (outer.isNotEmpty && outer.first is Map) {
        final first = outer.first as Map;
        if (first['tickets'] is List) {
          return first['tickets'] as List;
        }
      }
    }
    return _parseList(data);
  }

  /// Unwraps the helpdesk envelope `{ status, message, data: {...} }` and
  /// returns the inner object. Falls back to the body itself when no envelope
  /// is present (legacy / mock paths).
  ///
  /// Order matters: BE responses are `Map<String, dynamic>` at the OUTER
  /// level too, so we must check for `data` first — otherwise we'd return
  /// the wrapper and lose the actual ticket payload.
  Map<String, dynamic> _parseMap(dynamic data) {
    if (data is Map) {
      final inner = data['data'];
      if (inner is Map<String, dynamic>) return inner;
      if (inner is Map) return Map<String, dynamic>.from(inner);
      if (data is Map<String, dynamic>) return data;
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }

  Map<String, dynamic> _buildQuery({
    int offset = 0,
    int limit = 20,
    String? search,
  }) {
    final query = <String, dynamic>{
      'offset': offset,
      'limit': limit,
      // BE requires these flags to return the grouped `{tickets, total, ...}`
      // payload. Without them the response shape changes and `_parseGroupedList`
      // would have to fall back to legacy parsing.
      'getCounter': true,
      'getTotal': true,
      'page': (limit > 0) ? (offset ~/ limit) + 1 : 1,
    };
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }
    return query;
  }
}

// ---------------------------------------------------------------------------
// Top-level helpers for getCustomerTickets (from feat/customer-management)
// ---------------------------------------------------------------------------

/// BE wraps tickets inside data.tickets[] (with optional total).
/// Tolerates the legacy / fallback shape where data itself is a list.
List<TicketDto> _parseTickets(Object? body) {
  if (body is! Map) return const <TicketDto>[];
  final data = body['data'];
  final Object? rawList = switch (data) {
    Map<dynamic, dynamic>() => data['tickets'],
    List<dynamic>() => data,
    _ => null,
  };
  if (rawList is! List) return const <TicketDto>[];
  return rawList
      .whereType<Map<dynamic, dynamic>>()
      .map((e) => TicketDto.fromJson(Map<String, dynamic>.from(e)))
      .toList(growable: false);
}

bool _looksLikeEmptyHistory(Object? body) {
  if (body is! Map) return false;
  final data = body['data'];
  if (data is List && data.isEmpty) return true;
  if (data is Map) {
    final tickets = data['tickets'];
    if (tickets is List && tickets.isEmpty) return true;
  }
  return false;
}
