import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class EmitTypingIndicatorUseCase extends UseCase<void, EmitTypingParams> {
  final ChatRepository _repository;

  EmitTypingIndicatorUseCase(this._repository);

  @override
  Future<void> call({required EmitTypingParams params}) async {
    _repository.emitTyping(
      chatRoomId: params.chatRoomId,
      customerSupportId: params.customerSupportId,
      fullname: params.fullname,
      profilePicture: params.profilePicture,
    );
  }
}

class EmitTypingParams {
  final String chatRoomId;
  final String? customerSupportId;
  final String? fullname;
  final String? profilePicture;

  const EmitTypingParams({
    required this.chatRoomId,
    this.customerSupportId,
    this.fullname,
    this.profilePicture,
  });
}
