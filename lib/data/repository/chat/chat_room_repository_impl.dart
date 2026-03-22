import '../../../domain/entity/chat/chat_room.dart';
import '../../../domain/repository/chat/chat_room_repository.dart';
import '../../local/datasources/chat/chat_room_datasource.dart';

class ChatRoomRepositoryImpl implements ChatRoomRepository {
  final ChatRoomDataSource _dataSource;

  ChatRoomRepositoryImpl(this._dataSource);

  @override
  Future<List<ChatRoom>> getChatRooms() {
    return _dataSource.getMockChatRooms();
  }
}
