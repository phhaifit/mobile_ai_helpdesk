import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_room_counter.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';

class GetChatRoomCountersUseCase
    extends UseCase<ChatRoomCounter, GetChatRoomCountersParams> {
  final ChatRoomRepository _repository;

  GetChatRoomCountersUseCase(this._repository);

  @override
  Future<ChatRoomCounter> call({required GetChatRoomCountersParams params}) {
    return _repository.getChatRoomCounters(
      customerName: params.customerName,
      getAll: params.getAll,
    );
  }
}

class GetChatRoomCountersParams {
  final String? customerName;
  final bool getAll;

  const GetChatRoomCountersParams({
    this.customerName,
    this.getAll = false,
  });
}
