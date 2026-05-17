import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/attachment.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';

class SendMessageFromAgentToCustomerUseCase
    extends UseCase<Message, SendAgentToCustomerMessageParams> {
  final ChatRepository _chatRepository;
  final ChatRoomRepository _chatRoomRepository;

  SendMessageFromAgentToCustomerUseCase(
    this._chatRepository,
    this._chatRoomRepository,
  );

  @override
  Future<Message> call({required SendAgentToCustomerMessageParams params}) async {
    final Message message = await _chatRepository.sendMessageFromAgentToCustomer(
      params: params,
    );

    _chatRoomRepository.notifyLastMessageUpdated(
      chatRoomId: params.chatRoomId,
      message: message,
    );

    return message;
  }
}

class SendAgentToCustomerMessageParams {
  final String chatRoomId;
  final String channelId;
  final String contactId;
  final String ticketId;
  final String content;
  final List<Attachment>? attachments;
  final String? groupId;
  final String? replyMessageId;
  final String? socketId;

  const SendAgentToCustomerMessageParams({
    required this.chatRoomId,
    required this.channelId,
    required this.contactId,
    required this.ticketId,
    required this.content,
    this.attachments,
    this.groupId,
    this.replyMessageId,
    this.socketId,
  });
}