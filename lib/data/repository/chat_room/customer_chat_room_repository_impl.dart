import 'package:ai_helpdesk/data/local/datasources/chat_room/mock_chat_room_datasource.dart';
import 'package:ai_helpdesk/data/network/apis/chat_room/chat_room_api.dart';
import 'package:ai_helpdesk/domain/entity/chat_room/customer_chat_room.dart';
import 'package:ai_helpdesk/domain/repository/chat_room/customer_chat_room_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CustomerChatRoomRepositoryImpl implements CustomerChatRoomRepository {
  final ChatRoomApi _api;
  final MockChatRoomDataSource? _mock;

  CustomerChatRoomRepositoryImpl(this._api, [this._mock]);

  bool _shouldFallback(DioException e) {
    if (!kDebugMode || _mock == null) return false;
    final code = e.response?.statusCode;
    if (code == null) return true;
    if (code == 404) return true;
    if (code >= 500) return true;
    return false;
  }

  @override
  Future<List<CustomerChatRoom>> getCustomerChatRooms(String customerId) async {
    try {
      final dtos = await _api.getCustomerChatRooms(customerId);
      return dtos.map((e) => e.toEntity()).toList(growable: false);
    } on DioException catch (e) {
      if (_shouldFallback(e)) {
        if (kDebugMode) {
          // ignore: avoid_print
          print(
            '[ChatRoomRepo] getCustomerChatRooms failed (${e.response?.statusCode ?? e.type.name}); using mock data.',
          );
        }
        return _mock!.getCustomerChatRooms(customerId);
      }
      rethrow;
    }
  }
}
