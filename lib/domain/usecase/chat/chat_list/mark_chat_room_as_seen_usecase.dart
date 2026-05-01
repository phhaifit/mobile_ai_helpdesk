import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/seen_info.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';

class MarkChatRoomAsSeenUseCase
    extends UseCase<SeenInfo, MarkChatRoomAsSeenParams> {
  final ChatRoomRepository _repository;

  MarkChatRoomAsSeenUseCase(this._repository);

  @override
  Future<SeenInfo> call({required MarkChatRoomAsSeenParams params}) {
    return _repository.markChatRoomAsSeen(
      chatRoomId: params.chatRoomId,
      messageId: params.messageId,
      messageOrder: params.messageOrder,
      socketId: params.socketId,
    );
  }
}

class MarkChatRoomAsSeenParams {
  final String chatRoomId;
  final String messageId;
  final int messageOrder;
  final String? socketId;

  const MarkChatRoomAsSeenParams({
    required this.chatRoomId,
    required this.messageId,
    required this.messageOrder,
    this.socketId,
  });
}