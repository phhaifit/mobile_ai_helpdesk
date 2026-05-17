import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_room_last_message_update.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';
import 'package:ai_helpdesk/domain/usecase/chat/realtime/observe_incoming_messages_usecase.dart';

class ObserveChatRoomLastMessageUpdatesUseCase
    extends UseCase<Stream<ChatRoomLastMessageUpdate>, NoParams> {
  final ChatRoomRepository _repository;

  ObserveChatRoomLastMessageUpdatesUseCase(this._repository);

  @override
  Stream<ChatRoomLastMessageUpdate> call({NoParams? params}) {
    return _repository.watchLastMessageUpdates();
  }
}
