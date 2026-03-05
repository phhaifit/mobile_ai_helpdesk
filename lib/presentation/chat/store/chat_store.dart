import 'package:mobx/mobx.dart';
import '../../../domain/entity/chat/message.dart';
import '../../../domain/repository/chat/chat_repository.dart';

part 'chat_store.g.dart'; // File này sẽ tự sinh ra sau khi chạy build_runner

class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  final ChatRepository _chatRepository;

  _ChatStore(this._chatRepository);

  @observable
  ObservableList<Message> messageList = ObservableList<Message>();

  @observable
  bool isLoading = false;

  @action
  Future<void> getMessages() async {
    isLoading = true;
    final messages = await _chatRepository.getMessages();
    messageList.addAll(messages);
    isLoading = false;
  }

  @action
  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch,
      content: text,
      timestamp: DateTime.now(),
      isMe: true,
      senderName: "User",
      isPending: false,
    );
    messageList.add(newMessage);
  }
}
