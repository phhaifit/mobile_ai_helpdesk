import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/message_reaction_update.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';
import 'package:ai_helpdesk/domain/usecase/chat/realtime/observe_incoming_messages_usecase.dart';

class ObserveReactionUpdatesUseCase
    extends UseCase<Stream<MessageReactionUpdate>, NoParams> {
  final ChatRepository _repository;

  ObserveReactionUpdatesUseCase(this._repository);

  @override
  Stream<MessageReactionUpdate> call({NoParams? params}) {
    return _repository.watchReactionUpdates();
  }
}
