import '../../../domain/entity/chat/message.dart';
import '../../../domain/entity/chat/message_group.dart';
import '../../../domain/entity/chat/reaction.dart';

abstract class ChatRepository {
  Future<List<Message>> getMessages({
    String? chatRoomId,
    String? customerId,
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

  Future<Reaction> reactToMessage(ReactToMessageRequest request);

  Future<bool> unreactToMessage(ReactToMessageRequest request);

  Future<int> countSearchResultsInChatRoom({
    required String chatRoomId,
    required String keyword,
  });

  Future<List<MessageGroup>> searchMessagesGroupedByChatRoom({
    required String keyword,
  });

  Future<List<Message>> flatSearchMessageList({
    required String keyword,
    String? chatRoomId,
  });

  Future<Map<String, dynamic>> analyzeTicketInChatRoomAi({
    required String chatRoomId,
    String? ticketId,
  });

  Future<Map<String, dynamic>> generateAiDraftResponse({
    required String chatRoomId,
    String? ticketId,
  });
}

class ReactToMessageRequest {
  final String messageId;
  final String zaloMessageId;
  final String reactIcon;
  final String zaloAccountId;
  final String chatRoomId;
  final String? socketId;
  final String? channelId;

  const ReactToMessageRequest({
    required this.messageId,
    required this.zaloMessageId,
    required this.reactIcon,
    required this.zaloAccountId,
    required this.chatRoomId,
    this.socketId,
    this.channelId,
  });
}