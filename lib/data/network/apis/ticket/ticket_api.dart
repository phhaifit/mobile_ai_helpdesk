import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/data/network/dto/ticket/ticket_dto.dart';

class TicketApi {
  final DioClient _dioClient;

  TicketApi(this._dioClient);

  Future<List<TicketDto>> getCustomerTickets(String customerId) async {
    final response = await _dioClient.dio.get(
      Endpoints.customerTickets(),
      queryParameters: {'customerId': customerId},
    );

    final data = response.data;

    final dynamic payload;
    if (data is Map<String, dynamic>) {
      payload = data['data'] ?? data['result'] ?? data['tickets'];
    } else {
      payload = data;
    }

    if (payload == null) return [];

    if (payload is List) {
      return payload
          .whereType<Map<String, dynamic>>()
          .map(TicketDto.fromJson)
          .toList();
    }

    // Some endpoints return { data: { items: [...] } }
    if (payload is Map<String, dynamic>) {
      final items = payload['items'];
      if (items is List) {
        return items
            .whereType<Map<String, dynamic>>()
            .map(TicketDto.fromJson)
            .toList();
      }
    }

    return [];
  }

  Future<TicketDto?> getTicketById(String id) async {
    final response = await _dioClient.dio.get(Endpoints.ticketDetail(id));
    final data = response.data;

    final dynamic payload;
    if (data is Map<String, dynamic>) {
      payload = data['data'] ?? data['result'] ?? data['ticket'];
    } else {
      payload = data;
    }

    if (payload == null) return null;

    if (payload is List) {
      if (payload.isEmpty) return null;
      final first = payload.first;
      if (first is Map<String, dynamic>) {
        return TicketDto.fromJson(first);
      }
      return null;
    }

    if (payload is Map<String, dynamic>) {
      return TicketDto.fromJson(payload);
    }

    return null;
  }
}
