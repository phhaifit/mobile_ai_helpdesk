import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class EmitStopTypingIndicatorUseCase extends UseCase<void, EmitStopTypingParams> {
  final ChatRepository _repository;

  EmitStopTypingIndicatorUseCase(this._repository);

  @override
  Future<void> call({required EmitStopTypingParams params}) async {
    _repository.emitStopTyping(
      chatRoomId: params.chatRoomId,
      customerSupportId: params.customerSupportId,
    );
  }
}

class EmitStopTypingParams {
  final String chatRoomId;
  final String? customerSupportId;

  const EmitStopTypingParams({
    required this.chatRoomId,
    this.customerSupportId,
  });
}
