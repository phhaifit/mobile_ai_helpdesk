import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_typing_event.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';
import 'package:ai_helpdesk/domain/usecase/chat/realtime/observe_incoming_messages_usecase.dart';

class ObserveCustomerTypingUseCase
    extends UseCase<Stream<ChatTypingEvent>, NoParams> {
  final ChatRepository _repository;

  ObserveCustomerTypingUseCase(this._repository);

  @override
  Stream<ChatTypingEvent> call({NoParams? params}) {
    return _repository.watchCustomerTyping();
  }
}
