import 'dart:async';

import '/core/domain/usecase/use_case.dart';
import '/domain/entity/playground/playground_message.dart';
import '/domain/repository/playground/playground_repository.dart';

class SendMessageParams {
  final String sessionId;
  final String content;
  final List<String> attachments;

  const SendMessageParams({
    required this.sessionId,
    required this.content,
    this.attachments = const [],
  });
}

class SendPlaygroundMessageUseCase
    extends UseCase<PlaygroundMessage, SendMessageParams> {
  final PlaygroundRepository _repository;
  SendPlaygroundMessageUseCase(this._repository);

  @override
  Future<PlaygroundMessage> call({required SendMessageParams params}) =>
      _repository.sendMessage(
        params.sessionId,
        params.content,
        params.attachments,
      );
}
