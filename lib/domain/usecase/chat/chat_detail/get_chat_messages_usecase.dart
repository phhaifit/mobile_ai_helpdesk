import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class GetChatMessagesUseCase extends UseCase<List<Message>, GetChatMessagesParams> {
  final ChatRepository _repository;

  GetChatMessagesUseCase(this._repository);

  @override
  Future<List<Message>> call({required GetChatMessagesParams params}) {
    return _repository.getMessages(
      chatRoomId: params.chatRoomId,
      customerId: params.customerId,
      lastMessageId: params.lastMessageId,
      limit: params.limit,
    );
  }
}

class GetChatMessagesParams {
  final String? chatRoomId;
  final String? customerId;
  final String? lastMessageId;
  final int limit;

  const GetChatMessagesParams({
    this.chatRoomId,
    this.customerId,
    this.lastMessageId,
    this.limit = 20,
  });
}