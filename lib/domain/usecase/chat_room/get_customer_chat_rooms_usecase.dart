import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat_room/customer_chat_room.dart';
import 'package:ai_helpdesk/domain/repository/chat_room/customer_chat_room_repository.dart';

class GetCustomerChatRoomsUseCase extends UseCase<List<CustomerChatRoom>, String> {
  final CustomerChatRoomRepository _repository;

  GetCustomerChatRoomsUseCase(this._repository);

  @override
  Future<List<CustomerChatRoom>> call({required String params}) {
    return _repository.getCustomerChatRooms(params);
  }
}
