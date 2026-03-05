import '../../../domain/entity/chat/message.dart';
import '../../../domain/repository/chat/chat_repository.dart';
import '../../local/datasources/chat/chat_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _chatDataSource;

  ChatRepositoryImpl(this._chatDataSource);

  @override
  Future<List<Message>> getMessages() {
    return _chatDataSource.getMockMessages();
  }
}
