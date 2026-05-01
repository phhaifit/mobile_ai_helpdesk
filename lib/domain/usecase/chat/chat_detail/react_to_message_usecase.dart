import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/reaction.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class ReactToMessageUseCase extends UseCase<Reaction, ReactToMessageRequest> {
  final ChatRepository _repository;

  ReactToMessageUseCase(this._repository);

  @override
  Future<Reaction> call({required ReactToMessageRequest params}) {
    return _repository.reactToMessage(params);
  }
}
