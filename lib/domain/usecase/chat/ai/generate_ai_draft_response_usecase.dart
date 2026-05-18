import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class GenerateAiDraftResponseUseCase
    extends UseCase<Map<String, dynamic>, GenerateAiDraftResponseParams> {
  final ChatRepository _repository;

  GenerateAiDraftResponseUseCase(this._repository);

  @override
  Future<Map<String, dynamic>> call({
    required GenerateAiDraftResponseParams params,
  }) {
    return _repository.generateAiDraftResponse(
      chatRoomId: params.chatRoomId,
      ticketId: params.ticketId,
    );
  }
}

class GenerateAiDraftResponseParams {
  final String chatRoomId;
  final String? ticketId;

  const GenerateAiDraftResponseParams({
    required this.chatRoomId,
    this.ticketId,
  });
}
