import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class SendMessageFromAgentToCustomerUseCase
    extends UseCase<Message, SendAgentToCustomerMessageParams> {
  final ChatRepository _repository;

  SendMessageFromAgentToCustomerUseCase(this._repository);

  @override
  Future<Message> call({required SendAgentToCustomerMessageParams params}) {
    return _repository.sendMessageFromAgentToCustomer(
      chatRoomId: params.chatRoomId,
      channelId: params.channelId,
      contactId: params.contactId,
      content: params.content,
      replyMessageId: params.replyMessageId,
      socketId: params.socketId,
    );
  }
}

class SendAgentToCustomerMessageParams {
  final String chatRoomId;
  final String channelId;
  final String contactId;
  final String content;
  final String? replyMessageId;
  final String? socketId;

  const SendAgentToCustomerMessageParams({
    required this.chatRoomId,
    required this.channelId,
    required this.contactId,
    required this.content,
    this.replyMessageId,
    this.socketId,
  });
}