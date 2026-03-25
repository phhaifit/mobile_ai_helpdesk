import 'package:mobx/mobx.dart';
import '../../../domain/entity/chat/chat_room.dart';
import '../../../domain/repository/chat/chat_room_repository.dart';

part 'chat_room_store.g.dart';

class ChatRoomStore = _ChatRoomStore with _$ChatRoomStore;

abstract class _ChatRoomStore with Store {
  final ChatRoomRepository _chatRoomRepository;

  _ChatRoomStore(this._chatRoomRepository);

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
    final rooms = await _chatRoomRepository.getChatRooms();
    chatRooms
      ..clear()
      ..addAll(rooms);
    isLoading = false;
  }

  @action
  void markAsRead(String roomId) {
    final index = chatRooms.indexWhere((r) => r.id == roomId);
    if (index != -1) {
      chatRooms[index] = chatRooms[index].copyWith(unreadCount: 0);
    }
  }

  @action
  void updateLastMessage(String roomId, String message, {bool isMe = true}) {
    final index = chatRooms.indexWhere((r) => r.id == roomId);
    if (index != -1) {
      chatRooms[index] = chatRooms[index].copyWith(
        lastMessage: message,
        lastMessageIsMe: isMe,
        lastMessageTime: DateTime.now(),
      );
    }
  }
}
