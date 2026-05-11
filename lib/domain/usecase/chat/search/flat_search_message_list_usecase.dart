import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class FlatSearchMessageListUseCase extends UseCase<List<Message>, FlatSearchMessageListParams> {
  final ChatRepository _repository;

  FlatSearchMessageListUseCase(this._repository);

  @override
  Future<List<Message>> call({required FlatSearchMessageListParams params}) async {
    final messages = await _repository.flatSearchMessageList(
      chatRoomId: params.chatRoomId,
      keyword: params.keyword,
    );

    messages.sort(
      (a, b) => a.order.compareTo(b.order),
    );

    return messages;
  }
}

class FlatSearchMessageListParams {
  final String chatRoomId;
  final String keyword;

  const FlatSearchMessageListParams({
    required this.chatRoomId,
    required this.keyword,
  });
}