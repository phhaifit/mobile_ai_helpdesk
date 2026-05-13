import 'package:ai_helpdesk/data/local/datasources/chat_room/mock_chat_room_datasource.dart';
import 'package:ai_helpdesk/data/network/apis/chat_room/chat_room_api.dart';
import 'package:ai_helpdesk/domain/entity/chat_room/customer_chat_room.dart';
import 'package:ai_helpdesk/domain/repository/chat_room/customer_chat_room_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Implementation of [CustomerChatRoomRepository] for the customer-detail summary.
///
/// The backend customer-scoped conversation endpoint is still under design,
/// so in debug builds we transparently fall back to [MockChatRoomDataSource]
/// when the call fails for transport reasons (404 / 5xx / network). Auth
/// failures (401/403) still propagate so the upgrade and login flows
/// behave realistically.
class CustomerChatRoomRepositoryImpl implements CustomerChatRoomRepository {
  final ChatRoomApi _api;
  final MockChatRoomDataSource? _fallback;

  CustomerChatRoomRepositoryImpl(this._api, [this._fallback]);

  bool _shouldFallback(DioException e) {
    if (!kDebugMode || _fallback == null) return false;
    final code = e.response?.statusCode;
    if (code == null) return true;
    if (code == 404) return true;
    if (code >= 500) return true;
    return false;
  }

  @override
  Future<List<CustomerChatRoom>> getCustomerChatRooms(String customerId) async {
    try {
      final dtos = await _api.getByCustomer(customerId);
      return dtos.map((d) => d.toEntity()).toList(growable: false);
    } on DioException catch (e) {
      if (_shouldFallback(e)) {
        if (kDebugMode) {
          // ignore: avoid_print
          print('[ChatRoomRepo] getCustomerChatRooms failed (${e.response?.statusCode ?? e.type.name}); using mock data.');
        }
        return _fallback!.getCustomerChatRooms(customerId);
      }
      rethrow;
    }
  }
}
