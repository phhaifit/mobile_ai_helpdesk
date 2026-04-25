import 'package:ai_helpdesk/data/network/apis/chat/chat_api.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/message_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/message_list_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/params/send_cs_message_to_customer_params.dart';
import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart';
import 'package:ai_helpdesk/domain/entity/chat/reaction.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatApi _chatApi;
  final SharedPreferenceHelper _prefs;

  ChatRepositoryImpl(this._chatApi, this._prefs);

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
    return _toDomainMessages(dto);
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
    return _toDomainMessages(dto);
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
    return _toDomainMessage(dto);
  }


  // TODO: Refactor Domain Entity and Mapper to avoid duplication
  Message _toDomainMessage(MessageDto dto) {
    return Message(
      id: dto.messageId,
      chatRoomId: dto.chatRoomId,
      content: dto.contentInfo['content'] as String? ?? '',
      timestamp: dto.createdAt ?? DateTime.now(),
      isMe: dto.sender == _prefs.tenantId,
      senderName: dto.sender == _prefs.tenantId ? 'You' : 'Customer',
      isPending: false,
      readStatus: MessageReadStatus.delivered,
    );
  }

  List<Message> _toDomainMessages(MessageListDto dto) {
    return dto.messages.map(_toDomainMessage).toList();
  }
}

