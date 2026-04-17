import '/core/data/network/dio/dio_client.dart';
import '/data/network/constants/endpoints.dart';
import '/domain/entity/messenger/messenger_page.dart';

class MessengerApi {
  final DioClient _dioClient;

  MessengerApi(this._dioClient);

  Future<List<MessengerPage>> getPages() async {
    final response = await _dioClient.dio.get(Endpoints.messengerPages);
    final list = response.data as List<dynamic>;
    return list
        .map((e) => MessengerPage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> connectPage(String pageId, String accessToken) async {
    await _dioClient.dio.post(
      Endpoints.messengerConnectPage,
      data: {'pageId': pageId, 'accessToken': accessToken},
    );
  }

  Future<void> disconnectPage(String channelId) async {
    await _dioClient.dio.delete(Endpoints.messengerDisconnectPage(channelId));
  }

  Future<void> updatePageConfig({
    required String channelId,
    required bool autoReply,
    required String greeting,
  }) async {
    await _dioClient.dio.post(
      Endpoints.messengerUpdatePageConfig,
      data: {
        'channelId': channelId,
        'autoReply': autoReply,
        'greeting': greeting,
      },
    );
  }

  Future<void> resyncPage(String channelId) async {
    await _dioClient.dio.post(
      Endpoints.messengerResyncPage,
      data: {'channelId': channelId},
    );
  }

  Future<void> verifyAuthCode(String code) async {
    await _dioClient.dio.post(
      Endpoints.messengerVerifyAuthCode,
      data: {'code': code},
    );
  }
}
