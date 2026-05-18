import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart';
import 'package:ai_helpdesk/domain/usecase/chat/chat_detail/get_chat_messages_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/chat_list/mark_chat_room_as_seen_usecase.dart';

/// Fetches the most recent messages for a chat room and marks the newest
/// message as seen on behalf of the current support agent.
///
/// On open the API returns the most recent `limit` messages (DESC); the
/// inner [GetChatMessagesUseCase] sorts ascending. We then forward the
/// newest message (`messages.last`) to [MarkChatRoomAsSeenUseCase] so the
/// server-side unread counter is cleared.
class OpenChatRoomUseCase extends UseCase<List<Message>, OpenChatRoomParams> {
  final GetChatMessagesUseCase _getChatMessages;
  final MarkChatRoomAsSeenUseCase _markChatRoomAsSeen;

  OpenChatRoomUseCase(this._getChatMessages, this._markChatRoomAsSeen);

  @override
  Future<List<Message>> call({required OpenChatRoomParams params}) async {
    final List<Message> messages = await _getChatMessages(
      params: GetChatMessagesParams(
        chatRoomId: params.chatRoomId,
        lastMessageId: params.lastMessageId,
        limit: params.limit,
      ),
    );

    if (messages.isNotEmpty) {
      final Message newest = messages.last;
      // Best-effort: a failed mark-seen should not block the open flow.
      try {
        await _markChatRoomAsSeen(
          params: MarkChatRoomAsSeenParams(
            chatRoomId: params.chatRoomId,
            messageId: newest.id,
            messageOrder: newest.order,
            socketId: params.socketId,
          ),
        );
      } catch (_) {}
    }

    return messages;
  }
}

class OpenChatRoomParams {
  final String chatRoomId;
  final int limit;
  final String? lastMessageId;
  final String? socketId;

  const OpenChatRoomParams({
    required this.chatRoomId,
    this.limit = 30,
    this.lastMessageId,
    this.socketId,
  });
}
