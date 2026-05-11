import 'package:mobx/mobx.dart';
import '../../../domain/entity/chat/chat_room.dart';
import '../../../domain/entity/chat/message.dart';
import '../../../domain/entity/chat/user.dart';
import '../../../domain/repository/chat/chat_room_repository.dart';
import '../../../domain/usecase/chat/chat_list/get_chat_rooms_usecase.dart';
import '../../../domain/usecase/chat/chat_list/mark_chat_room_as_seen_usecase.dart';

part 'chat_room_store.g.dart';

class ChatRoomStore = _ChatRoomStore with _$ChatRoomStore;

abstract class _ChatRoomStore with Store {
  final GetChatRoomsUseCase _getChatRooms;
  final MarkChatRoomAsSeenUseCase _markChatRoomAsSeen;

  _ChatRoomStore(this._getChatRooms, this._markChatRoomAsSeen);

  @observable
  ObservableList<ChatRoom> chatRooms = ObservableList<ChatRoom>();

  @observable
  bool isLoading = false;

  @computed
  int get totalUnread =>
      chatRooms.fold(0, (sum, room) => sum + room.unreadCount);

  @action
  Future<void> fetchChatRooms() async {
    isLoading = true;
    final rooms = await _getChatRooms.call(
      params: ChatRoomListQuery.inboxDefault,
    );
    chatRooms
      ..clear()
      ..addAll(rooms);
    isLoading = false;
  }

  @action
  Future<void> markAsRead(ChatRoom room) async {
      try {
        final index = chatRooms.indexWhere((r) => r.id == room.id);
        if (index == -1) return;
        if (room.unreadCount == 0) return;
        
        await _markChatRoomAsSeen(
          params: MarkChatRoomAsSeenParams(
            chatRoomId: room.id,
            messageId: room.lastMessage.id,
            messageOrder: room.lastMessage.order,
          ),
        );

        chatRooms[index] = chatRooms[index].copyWith(
          unreadCount: 0,
        );
      } catch (_) {
        // Mark-seen is best-effort; failure should not surface to UI here.
      }
  }

  @action
  void updateLastMessage(String roomId, String message, {bool isMe = true}) {
    final index = chatRooms.indexWhere((r) => r.id == roomId);
    if (index != -1) {
      chatRooms[index] = chatRooms[index].copyWith(
        lastMessage: Message(
          id: message,
          content: message,
          sender: const User(
            id: '1',
            name: 'John Doe',
            avatar: 'https://example.com/avatar.png',
          ),
          isMe: isMe,
          attachments: [],
          timestamp: DateTime.now(),
          replyMessageId: null,
          reactions: [],
          conversationId: roomId,
          order: 1,
        ),
        lastMessageTime: DateTime.now().toLocal(),
      );
    }
  }

}
