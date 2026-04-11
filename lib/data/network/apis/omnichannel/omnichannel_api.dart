import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';

class MessengerPageDto {
  final String id;
  final String name;
  final String pageId;
  final bool connected;

  const MessengerPageDto({
    required this.id,
    required this.name,
    required this.pageId,
    required this.connected,
  });

  factory MessengerPageDto.fromJson(Map<String, dynamic> json) {
    return MessengerPageDto(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      pageId: (json['pageId'] ?? '').toString(),
      connected: (json['connected'] as bool?) ?? false,
    );
  }
}

class OmnichannelApi {
  final DioClient _dioClient;

  OmnichannelApi(this._dioClient);

  Future<List<MessengerPageDto>> getMessengerPages() async {
    final res = await _dioClient.dio.get(Endpoints.messengerPages());
    final dynamic data = res.data;
    if (data is! List) {
      return const <MessengerPageDto>[];
    }

    return data
        .whereType<Map<Object?, Object?>>()
        .map(
          (Map<Object?, Object?> item) =>
              MessengerPageDto.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList(growable: false);
  }

  Future<dynamic> verifyMessengerAuthCode(String code) {
    return _dioClient.dio.post(
      Endpoints.verifyMessengerAuthCode(),
      data: <String, dynamic>{'code': code},
    );
  }

  Future<dynamic> connectMessengerPage({
    required String pageId,
    required String accessToken,
  }) {
    return _dioClient.dio.post(
      Endpoints.connectMessengerPage(),
      data: <String, dynamic>{'pageId': pageId, 'accessToken': accessToken},
    );
  }

  Future<dynamic> deleteMessengerPage(String channelId) {
    return _dioClient.dio.delete(Endpoints.deleteMessengerPage(channelId));
  }

  Future<dynamic> resyncMessengerPage(String channelId) {
    return _dioClient.dio.post(
      Endpoints.resyncMessengerPage(),
      data: <String, dynamic>{'channelId': channelId},
    );
  }

  Future<dynamic> updateMessengerPageConfig({
    required String channelId,
    required bool autoReply,
    String? greeting,
  }) {
    return _dioClient.dio.post(
      Endpoints.updateMessengerPageConfig(),
      data: <String, dynamic>{
        'channelId': channelId,
        'autoReply': autoReply,
        if (greeting != null) 'greeting': greeting,
      },
    );
  }

  Future<dynamic> getMessengerCustomers({int offset = 0, int limit = 20}) {
    return _dioClient.dio.get(
      Endpoints.messengerCustomers(),
      queryParameters: <String, dynamic>{'offset': offset, 'limit': limit},
    );
  }
}
