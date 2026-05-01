import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class UnreactToMessageUseCase extends UseCase<bool, ReactToMessageRequest> {
  final ChatRepository _repository;

  UnreactToMessageUseCase(this._repository);

  @override
  Future<bool> call({required ReactToMessageRequest params}) {
    return _repository.unreactToMessage(params);
  }
}
