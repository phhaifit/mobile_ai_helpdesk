import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class FlatSearchMessageListUseCase
    extends UseCase<List<Message>, FlatSearchMessageListParams> {
  final ChatRepository _repository;

  FlatSearchMessageListUseCase(this._repository);

  @override
  Future<List<Message>> call({required FlatSearchMessageListParams params}) {
    return _repository.flatSearchMessageList(
      keyword: params.keyword,
      chatRoomId: params.chatRoomId,
    );
  }
}

class FlatSearchMessageListParams {
  final String keyword;
  final String? chatRoomId;

  const FlatSearchMessageListParams({
    required this.keyword,
    this.chatRoomId,
  });
}