import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class ObserveIncomingMessagesUseCase extends UseCase<Stream<Message>, NoParams> {
  final ChatRepository _repository;

  ObserveIncomingMessagesUseCase(this._repository);

  @override
  Stream<Message> call({NoParams? params}) {
    return _repository.watchIncomingMessages();
  }
}

class NoParams {
  const NoParams();
}
