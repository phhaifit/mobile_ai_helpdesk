import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_room_seen_update.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';
import 'package:ai_helpdesk/domain/usecase/chat/realtime/observe_incoming_messages_usecase.dart';

class ObserveChatRoomSeenUseCase
    extends UseCase<Stream<ChatRoomSeenUpdate>, NoParams> {
  final ChatRoomRepository _repository;

  ObserveChatRoomSeenUseCase(this._repository);

  @override
  Stream<ChatRoomSeenUpdate> call({NoParams? params}) {
    return _repository.watchRoomSeenUpdates();
  }
}
