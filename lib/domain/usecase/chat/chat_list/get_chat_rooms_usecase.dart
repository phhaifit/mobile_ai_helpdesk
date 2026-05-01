import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_room.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';

class GetChatRoomsUseCase extends UseCase<List<ChatRoom>, ChatRoomListQuery> {
  final ChatRoomRepository _repository;

  GetChatRoomsUseCase(this._repository);

  @override
  Future<List<ChatRoom>> call({required ChatRoomListQuery params}) async {
    return _repository.getChatRooms(query: params);
  }
}
