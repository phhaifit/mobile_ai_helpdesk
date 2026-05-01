import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class CountSearchResultsInChatRoomUseCase
    extends UseCase<int, CountSearchResultsInChatRoomParams> {
  final ChatRepository _repository;

  CountSearchResultsInChatRoomUseCase(this._repository);

  @override
  Future<int> call({required CountSearchResultsInChatRoomParams params}) {
    return _repository.countSearchResultsInChatRoom(
      chatRoomId: params.chatRoomId,
      keyword: params.keyword,
    );
  }
}

class CountSearchResultsInChatRoomParams {
  final String chatRoomId;
  final String keyword;

  const CountSearchResultsInChatRoomParams({
    required this.chatRoomId,
    required this.keyword,
  });
}