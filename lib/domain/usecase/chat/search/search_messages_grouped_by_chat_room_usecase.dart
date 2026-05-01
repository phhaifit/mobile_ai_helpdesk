import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/message_group.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class SearchMessagesGroupedByChatRoomUseCase
    extends UseCase<List<MessageGroup>, SearchMessagesGroupedParams> {
  final ChatRepository _repository;

  SearchMessagesGroupedByChatRoomUseCase(this._repository);

  @override
  Future<List<MessageGroup>> call({required SearchMessagesGroupedParams params}) {
    return _repository.searchMessagesGroupedByChatRoom(keyword: params.keyword);
  }
}

class SearchMessagesGroupedParams {
  final String keyword;

  const SearchMessagesGroupedParams({required this.keyword});
}
