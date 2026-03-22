import '../../../domain/entity/chat/message.dart';

abstract class ChatRepository {
  Future<List<Message>> getMessages();
}
