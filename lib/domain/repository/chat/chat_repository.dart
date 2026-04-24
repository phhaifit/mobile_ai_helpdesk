import '../../../domain/entity/chat/message.dart';

abstract class ChatRepository {
  Future<List<Message>> getMessages({
    required String chatRoomId,
    String? lastMessageId,
    int limit = 20,
  });

  Future<List<Message>> getNewerMessages({
    required String chatRoomId,
    String? lastMessageId,
    int limit = 20,
  });

  Future<Message> sendMessageFromAgentToCustomer({
    required String chatRoomId,
    required String channelId,
    required String contactId,
    required String content,
    String? replyMessageId,
    String? socketId,
  });
}
