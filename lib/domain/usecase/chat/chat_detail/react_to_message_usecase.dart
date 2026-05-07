import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/reaction.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class ReactToMessageUseCase extends UseCase<Reaction, ReactToMessageRequest> {
  final ChatRepository _repository;

  ReactToMessageUseCase(this._repository);

  @override
  Future<Reaction> call({required ReactToMessageRequest params}) {
    return _repository.reactToMessage(params);
  }
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