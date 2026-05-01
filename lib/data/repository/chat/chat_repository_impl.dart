import 'package:ai_helpdesk/data/network/apis/chat/chat_api.dart';
import 'package:ai_helpdesk/data/network/apis/chat/params/send_cs_message_to_customer_params.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart' show Message;
import 'package:ai_helpdesk/domain/entity/chat/message_group.dart';
import 'package:ai_helpdesk/domain/entity/chat/reaction.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';
import 'utils.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatApi _chatApi;

  ChatRepositoryImpl(this._chatApi);

  @override
  Future<List<Message>> getMessages({
    String? chatRoomId,
    String? customerId,
    String? lastMessageId,
    int limit = 20,
  }) async {
    final dto = await _chatApi.getMessageList(
      chatRoomId: chatRoomId,
      customerId: customerId,
      lastMessageId: lastMessageId,
      limit: limit,
    );
    return dto.messages.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Message>> getNewerMessages({
    required String chatRoomId,
    String? lastMessageId,
    int limit = 20,
  }) async {
    final dto = await _chatApi.getNewerMessages(
      chatRoomId: chatRoomId,
      lastMessageId: lastMessageId,
      limit: limit,
    );
    return dto.messages.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Message> sendMessageFromAgentToCustomer({
    required String chatRoomId,
    required String channelId,
    required String contactId,
    required String content,
    String? replyMessageId,
    String? socketId,
  }) async {
    final dto = await _chatApi.sendMessageFromAgentToCustomer(
      params: SendCsMessageToCustomerParams(
        chatRoomId: chatRoomId,
        channelId: channelId,
        contactId: contactId,
        content: content,
        replyMessageId: replyMessageId,
        socketId: socketId,
      ),
    );
    return dto.toDomain();
  }

  @override
  Future<Reaction> reactToMessage(ReactToMessageRequest request) async {
    final dto = await _chatApi.reactToMessage(params: mapReactParams(request));
    return dto.toDomain();
  }

  @override
  Future<bool> unreactToMessage(ReactToMessageRequest request) async {
    return _chatApi.unreactMessage(params: mapReactParams(request));
  }

  @override
  Future<int> countSearchResultsInChatRoom({
    required String chatRoomId,
    required String keyword,
  }) async {
    return _chatApi.countSearchResultsInChatRoom(
      chatRoomId: chatRoomId,
      keyword: keyword,
    );
  }

  @override
  Future<List<MessageGroup>> searchMessagesGroupedByChatRoom({
    required String keyword,
  }) async {
    final groups = await _chatApi.searchMessagesGroupedByChatRoom(
      keyword: keyword,
    );
    return groups.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Message>> flatSearchMessageList({
    required String keyword,
    String? chatRoomId,
  }) async {
    final dto = await _chatApi.flatSearchMessageList(
      keyword: keyword,
      chatRoomId: chatRoomId,
    );
    return dto.messages.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Map<String, dynamic>> analyzeTicketInChatRoomAi({
    required String chatRoomId,
    String? ticketId,
  }) async {
    return _chatApi.analyzeTicketInChatRoomAi(
      chatRoomId: chatRoomId,
      ticketId: ticketId,
    );
  }

  @override
  Future<Map<String, dynamic>> generateAiDraftResponse({
    required String chatRoomId,
    String? ticketId,
  }) async {
    return _chatApi.generateAiDraftResponse(
      chatRoomId: chatRoomId,
      ticketId: ticketId,
    );
  }
}