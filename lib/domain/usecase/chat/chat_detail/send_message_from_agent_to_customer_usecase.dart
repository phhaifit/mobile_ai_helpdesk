import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/attachment.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class SendMessageFromAgentToCustomerUseCase
    extends UseCase<Message, SendAgentToCustomerMessageParams> {
  final ChatRepository _repository;

  SendMessageFromAgentToCustomerUseCase(this._repository);

  @override
  Future<Message> call({required SendAgentToCustomerMessageParams params}) {
    return _repository.sendMessageFromAgentToCustomer(params: params);
  }
}

class SendAgentToCustomerMessageParams {
  final String? chatRoomId;
  final String? groupId;
  final String channelId;
  final String contactId;
  final String ticketId;
  final String content;
  final List<Attachment>? attachments;
  final String? replyMessageId;
  final String? socketId;

  const SendAgentToCustomerMessageParams({
    this.chatRoomId,
    this.groupId,
    required this.channelId,
    required this.contactId,
    required this.ticketId,
    required this.content,
    this.attachments,
    this.replyMessageId,
    this.socketId,
  });
}