import '../../../domain/entity/chat/message.dart';
import '../../../domain/repository/chat/chat_repository.dart';
import '../../local/datasources/chat/chat_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _chatDataSource;

  ChatRepositoryImpl(this._chatDataSource);

  @override
  Future<List<Message>> getMessages({
    required String chatRoomId,
    String? lastMessageId,
    int limit = 20,
  }) {
    return _chatDataSource.getMockMessages(chatRoomId: chatRoomId);
  }

  @override
  Future<List<Message>> getNewerMessages({
    required String chatRoomId,
    String? lastMessageId,
    int limit = 20,
  }) {
    return _chatDataSource.getMockMessages(chatRoomId: chatRoomId);
  }

  @override
  Future<Message> sendMessageFromAgentToCustomer({
    required String chatRoomId,
    required String channelId,
    required String contactId,
    required String content,
    String? replyMessageId,
    String? socketId,
  }) async {
    // Mock: just return a local message until REST implementation is wired.
    return Message(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      content: content,
      timestamp: DateTime.now(),
      isMe: true,
      senderName: 'You',
      isPending: false,
      readStatus: MessageReadStatus.sent,
    );
  }
}
