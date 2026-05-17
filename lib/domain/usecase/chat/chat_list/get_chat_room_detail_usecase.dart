import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_room.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';

class GetChatRoomDetailUseCase
    extends UseCase<List<ChatRoom>, GetChatRoomDetailParams> {
  final ChatRoomRepository _repository;

  GetChatRoomDetailUseCase(this._repository);

  @override
  Future<List<ChatRoom>> call({required GetChatRoomDetailParams params}) {
    return _repository.getChatRoomDetail(
      chatRoomId: params.chatRoomId,
      customerId: params.customerId,
    );
  }
}

class GetChatRoomDetailParams {
  final String? chatRoomId;
  final String? customerId;

  const GetChatRoomDetailParams({
    this.chatRoomId,
    this.customerId,
  });
}
