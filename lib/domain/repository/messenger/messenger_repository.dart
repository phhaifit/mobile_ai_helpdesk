import '/domain/entity/messenger/messenger_page.dart';

abstract class MessengerRepository {
  Future<List<MessengerPage>> getPages();

  Future<void> connectPage(String pageId, String accessToken);

  Future<void> disconnectPage(String channelId);

  Future<void> updatePageConfig({
    required String channelId,
    required bool autoReply,
    required String greeting,
  });

  Future<void> resyncPage(String channelId);

  Future<void> verifyAuthCode(String code);
}
