import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class GetNewerChatMessagesUseCase
    extends UseCase<List<Message>, GetNewerChatMessagesParams> {
  final ChatRepository _repository;

  GetNewerChatMessagesUseCase(this._repository);

  @override
  Future<List<Message>> call({required GetNewerChatMessagesParams params}) {
    return _repository.getNewerMessages(
      chatRoomId: params.chatRoomId,
      lastMessageId: params.lastMessageId,
      limit: params.limit,
    );
  }
}

class GetNewerChatMessagesParams {
  final String chatRoomId;
  final String? lastMessageId;
  final int limit;

  const GetNewerChatMessagesParams({
    required this.chatRoomId,
    this.lastMessageId,
    this.limit = 20,
  });
}