import 'package:mobx/mobx.dart' hide Reaction;
import 'dart:async';
import 'dart:math';
import '../../../domain/entity/chat/message.dart';
import '../../../domain/entity/chat/reaction.dart';
import '../../../domain/repository/chat/chat_repository.dart';

part 'chat_store.g.dart'; // File này sẽ tự sinh ra sau khi chạy build_runner

class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  final ChatRepository _chatRepository;

  // Canned responses for auto-reply simulation
  static const List<String> _defaultResponses = [
    'Cảm ơn bạn đã liên hệ! Tôi sẽ giúp bạn trong vài phút.',
    'Tôi đã ghi nhận vấn đề của bạn. Đang xử lý...',
    'Đó là một câu hỏi hay! Hãy cho tôi một giây để tìm câu trả lời.',
    'Tôi hiểu rồi. Để tôi kiểm tra thêm một chút.',
    'Cảm ơn! Tôi đang xử lý yêu cầu của bạn.',
    'Bạn có thể cung cấp thêm chi tiết không?',
    'Mình sẽ giúp bạn giải quyết vấn đề này.',
    'Tôi đang tìm kiếm thông tin phù hợp cho bạn.',
  ];

  _ChatStore(this._chatRepository);

  @observable
  ObservableList<Message> messageList = ObservableList<Message>();

  @observable
  bool isLoading = false;

  @observable
  bool isTyping = false;

  @observable
  String searchQuery = '';

  @computed
  List<Message> get filteredMessages {
    if (searchQuery.isEmpty) return messageList.toList();

    return messageList
        .where(
          (msg) =>
              msg.content.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  @action
  void setSearchQuery(String query) {
    searchQuery = query;
  }

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
      readStatus: MessageReadStatus.sent,
    );
    messageList.add(newMessage);

    // Simulate delivery status progression
    _simulateReadStatusProgression(newMessage.id);

    // Simulate auto-reply from AI Assistant after 2 seconds
    _simulateAutoReply();
  }

  @action
  void addReactionToMessage(int messageId, String emoji) {
    final index = messageList.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final message = messageList[index];

      // Check if emoji reaction already exists
      final reactionIndex = message.reactions.indexWhere(
        (r) => r.emoji == emoji,
      );

      if (reactionIndex != -1) {
        // Add user to existing reaction
        final existingReaction = message.reactions[reactionIndex];
        final updatedReaction = existingReaction.copyWith(
          userNames: [
            ...existingReaction.userNames,
            if (!existingReaction.userNames.contains('You')) 'You',
          ],
        );

        final updatedReactions = List<Reaction>.from(message.reactions);
        updatedReactions[reactionIndex] = updatedReaction;

        messageList[index] = message.copyWith(reactions: updatedReactions);
      } else {
        // Add new reaction
        final newReaction = Reaction(emoji: emoji, userNames: ['You']);
        messageList[index] = message.copyWith(
          reactions: [...message.reactions, newReaction],
        );
      }
    }
  }

  @action
  void _updateMessageReadStatus(int messageId, MessageReadStatus newStatus) {
    final index = messageList.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messageList[index] = messageList[index].copyWith(readStatus: newStatus);
    }
  }

  void _simulateReadStatusProgression(int messageId) {
    // Sent → Delivered (after 500ms)
    Future.delayed(const Duration(milliseconds: 500), () {
      _updateMessageReadStatus(messageId, MessageReadStatus.delivered);
    });

    // Delivered → Read (after 2 seconds)
    Future.delayed(const Duration(seconds: 2), () {
      _updateMessageReadStatus(messageId, MessageReadStatus.read);
    });
  }

  void _simulateAutoReply() {
    // Show typing indicator after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      isTyping = true;
    });

    // Send auto-reply after 2.5 seconds total
    Future.delayed(const Duration(milliseconds: 2500), () {
      final randomResponse =
          _defaultResponses[Random().nextInt(_defaultResponses.length)];

      final autoReplyMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch,
        content: randomResponse,
        timestamp: DateTime.now(),
        isMe: false,
        senderName: "AI Assistant",
        isPending: false,
        readStatus: MessageReadStatus.sent,
      );

      messageList.add(autoReplyMessage);
      isTyping = false; // Hide typing indicator

      // Simulate delivery status progression for auto-reply
      _simulateReadStatusProgression(autoReplyMessage.id);
    });
  }
}
