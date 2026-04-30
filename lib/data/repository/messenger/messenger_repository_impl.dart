import '/data/network/apis/messenger/messenger_api.dart';
import '/domain/entity/messenger/messenger_page.dart';
import '/domain/repository/messenger/messenger_repository.dart';

class MessengerRepositoryImpl implements MessengerRepository {
  final MessengerApi _api;

  MessengerRepositoryImpl(this._api);

  @override
  Future<List<MessengerPage>> getPages() => _api.getPages();

  @override
  Future<void> connectPage(String pageId, String accessToken) =>
      _api.connectPage(pageId, accessToken);

  @override
  Future<void> disconnectPage(String channelId) =>
      _api.disconnectPage(channelId);

  @override
  Future<void> updatePageConfig({
    required String channelId,
    required bool autoReply,
    required String greeting,
  }) => _api.updatePageConfig(
        channelId: channelId,
        autoReply: autoReply,
        greeting: greeting,
      );

  @override
  Future<void> resyncPage(String channelId) => _api.resyncPage(channelId);

  @override
  Future<void> verifyAuthCode(String code) => _api.verifyAuthCode(code);
}
