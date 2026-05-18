import 'package:ai_helpdesk/core/data/network/dio/configs/dio_configs.dart';
import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/apis/chat_room/chat_room_api.dart';

/// Test double for [ChatRoomApi].  Overrides all network methods so Dio is
/// never actually called.
class FakeChatRoomApi extends ChatRoomApi {
  List<dynamic> messagesResponse = [];
  Map<String, dynamic> sendMessageResponse = {};
  Map<String, dynamic> chatRoomDetailResponse = {};

  String? lastGetMessagesChatRoomId;
  String? lastSendMessageChatRoomId;
  String? lastSendMessageChannelId;
  String? lastSendMessageContent;
  String? lastSendMessageContactId;
  String? lastGetChatRoomDetailId;

  FakeChatRoomApi()
      : super(DioClient(
          dioConfigs: const DioConfigs(baseUrl: 'http://fake.test'),
        ));

  @override
  Future<List<dynamic>> getMessages(String chatRoomId, {int limit = 20}) async {
    lastGetMessagesChatRoomId = chatRoomId;
    return messagesResponse;
  }

  @override
  Future<Map<String, dynamic>> sendMessage({
    required String chatRoomId,
    required String channelId,
    required String content,
    String? contactId,
  }) async {
    lastSendMessageChatRoomId = chatRoomId;
    lastSendMessageChannelId = channelId;
    lastSendMessageContent = content;
    lastSendMessageContactId = contactId;
    return sendMessageResponse;
  }

  @override
  Future<Map<String, dynamic>> getChatRoomDetail(String chatRoomId) async {
    lastGetChatRoomDetailId = chatRoomId;
    return chatRoomDetailResponse;
  }
}
