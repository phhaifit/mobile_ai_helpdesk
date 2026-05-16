import 'package:ai_helpdesk/domain/entity/chat/chat_typing_event.dart';
import 'package:ai_helpdesk/domain/entity/chat/draft_response_progress.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart';
import 'package:ai_helpdesk/domain/entity/chat/message_group.dart';
import 'package:ai_helpdesk/domain/entity/chat/message_reaction_update.dart';
import 'package:ai_helpdesk/domain/entity/chat/reaction.dart';
import 'package:ai_helpdesk/domain/usecase/chat/chat_detail/react_to_message_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/chat_detail/send_message_from_agent_to_customer_usecase.dart';

abstract class ChatRepository {
  Stream<List<Message>> watchMessages(String roomId);

  Stream<Message> watchIncomingMessages();

  Stream<MessageReactionUpdate> watchReactionUpdates();

  Stream<ChatTypingEvent> watchSupportTyping();

  Stream<DraftResponseProgress> watchDraftProgress();

  void emitTyping({
    required String chatRoomId,
    String? customerSupportId,
    String? fullname,
    String? profilePicture,
  });

  void emitStopTyping({
    required String chatRoomId,
    String? customerSupportId,
  });

  bool hasMoreOlderMessages(String roomId);

  void resetMessageCache();

  Future<void> prefetchMessagesForRooms(Iterable<String> roomIds);

  Future<void> loadOlderMessages(String roomId);

  /// Fetches messages newer than the cached newest message and merges them.
  /// Returns the messages that were added to the cache (empty if none).
  Future<List<Message>> loadNewerMessages(String roomId);

  void mergeMessage({
    required String roomId,
    required Message message,
  });

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
    required String chatRoomId,
    required String keyword,
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