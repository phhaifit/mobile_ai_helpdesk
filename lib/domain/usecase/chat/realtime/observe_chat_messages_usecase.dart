import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

/// No parameters; the stream follows the active socket connection.
class ObserveMessagesParams {
  final String roomId;
  
  const ObserveMessagesParams({
    required this.roomId,
  });
}

class ObserveChatMessagesUseCase
    extends UseCase<Stream<List<Message>>, ObserveMessagesParams> {
  final ChatRepository _repository;

  ObserveChatMessagesUseCase(this._repository);

  @override
  Stream<List<Message>> call({required ObserveMessagesParams params}) {
    return _repository.watchMessages(params.roomId);
  }
}
