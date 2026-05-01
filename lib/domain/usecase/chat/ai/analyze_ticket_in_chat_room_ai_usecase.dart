import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class AnalyzeTicketInChatRoomAiUseCase
    extends UseCase<Map<String, dynamic>, AnalyzeTicketInChatRoomAiParams> {
  final ChatRepository _repository;

  AnalyzeTicketInChatRoomAiUseCase(this._repository);

  @override
  Future<Map<String, dynamic>> call({
    required AnalyzeTicketInChatRoomAiParams params,
  }) {
    return _repository.analyzeTicketInChatRoomAi(
      chatRoomId: params.chatRoomId,
      ticketId: params.ticketId,
    );
  }
}

class AnalyzeTicketInChatRoomAiParams {
  final String chatRoomId;
  final String? ticketId;

  const AnalyzeTicketInChatRoomAiParams({
    required this.chatRoomId,
    this.ticketId,
  });
}
