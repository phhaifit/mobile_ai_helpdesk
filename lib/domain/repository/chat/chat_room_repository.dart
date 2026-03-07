import '../../../domain/entity/chat/chat_room.dart';

abstract class ChatRoomRepository {
  Future<List<ChatRoom>> getChatRooms();
}
