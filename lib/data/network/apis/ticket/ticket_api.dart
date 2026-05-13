import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/data/network/dto/ticket/ticket_dto.dart';
import 'package:dio/dio.dart';

class TicketApi {
  final DioClient _dioClient;

  TicketApi(this._dioClient);

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
      final response = await _dioClient.dio.get(
        Endpoints.ticketHistoryByCustomer(customerId),
        queryParameters: {'limit': limit, 'offset': offset},
      );
      return _parseTickets(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 && _looksLikeEmptyHistory(e.response?.data)) {
        return const <TicketDto>[];
      }
      rethrow;
    }
  }

  Future<TicketDto?> getTicketById(String id) async {
    final response = await _dioClient.dio.get(Endpoints.ticketDetail(id));
    final data = response.data;
    if (data is! Map) return null;
    final payload = data['data'];
    if (payload is! Map) return null;
    return TicketDto.fromJson(Map<String, dynamic>.from(payload));
  }
}

List<TicketDto> _parseTickets(Object? body) {
  if (body is! Map) return const <TicketDto>[];
  final data = body['data'];
  // BE wraps tickets inside data.tickets[] (with optional total).
  // Tolerate the legacy / fallback shape where data itself is a list.
  final Object? rawList = switch (data) {
    Map<dynamic, dynamic>() => data['tickets'],
    List<dynamic>() => data,
    _ => null,
  };
  if (rawList is! List) return const <TicketDto>[];
  return rawList
      .whereType<Map>()
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
