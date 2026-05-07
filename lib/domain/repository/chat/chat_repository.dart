import 'package:ai_helpdesk/domain/usecase/chat/chat_detail/send_message_from_agent_to_customer_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/chat_detail/react_to_message_usecase.dart';
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
    required SendAgentToCustomerMessageParams params,
  });

  Future<Reaction> reactToMessage(ReactToMessageRequest params);

  Future<bool> unreactToMessage(ReactToMessageRequest params);

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