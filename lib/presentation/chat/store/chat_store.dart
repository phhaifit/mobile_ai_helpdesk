import 'dart:async';
import 'dart:math';
import 'package:ai_helpdesk/core/events/socket/server/ai/draft_response_sse_event.dart';
import 'package:ai_helpdesk/data/realtime/sse/draft_response_sse_client.dart';
import 'package:mobx/mobx.dart' hide Reaction;
import '../../../constants/analytics_events.dart';
import '../../../di/service_locator.dart';
import '../../../domain/analytics/analytics_service.dart';
import '../../../domain/entity/chat/message.dart';
import '../../../domain/entity/chat/reaction.dart';
import '../../../domain/repository/chat/chat_repository.dart';

part 'chat_store.g.dart'; // File này sẽ tự sinh ra sau khi chạy build_runner

class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  final ChatRepository _chatRepository;
  final AnalyticsService _analyticsService;

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

  _ChatStore(this._chatRepository, this._analyticsService);

  @observable
  ObservableList<Message> messageList = ObservableList<Message>();

  @observable
  bool isLoading = false;

  @observable
  bool isTyping = false;

  @observable
  ObservableList<String> draftResponses = ObservableList<String>();

  @observable
  bool isDraftLoading = false;

  StreamSubscription<DraftResponseSseEvent>? _draftSub;

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
  Future<void> getMessages(String chatRoomId) async {
    isLoading = true;
    messageList.clear(); // Clear sebelum load pesan baru
    final messages = await _chatRepository.getMessages(chatRoomId: chatRoomId);
    messageList.addAll(messages);
    isLoading = false;
  }

  @action
  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final newMessage = Message(
      id: id,
      content: text,
      timestamp: DateTime.now(),
      isMe: true,
      senderName: 'User',
      isPending: false,
      readStatus: MessageReadStatus.sent,
    );
    messageList.add(newMessage);

    // Track message sent event
    _analyticsService.trackEvent(
      AnalyticsEvents.messageSent,
      parameters: {'channel': 'chat'},
    );

    // Simulate delivery status progression
    _simulateReadStatusProgression(newMessage.id);

    // Simulate auto-reply from AI Assistant after 2 seconds
    _simulateAutoReply();
  }

  @action
  void addReactionToMessage(String messageId, String emoji) {
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
  void onSocketMessage(Message message) {
    // Merge by id to avoid duplicates.
    final index = messageList.indexWhere((m) => m.id == message.id);
    if (index >= 0) {
      messageList[index] = message;
    } else {
      messageList.add(message);
    }
  }

  @action
  void onSocketTyping({required bool typing}) {
    isTyping = typing;
  }

  @action
  Future<void> generateDraftResponses({required String chatRoomId}) async {
    _draftSub?.cancel();
    draftResponses.clear();
    isDraftLoading = true;
    final client = getIt<DraftResponseSseClient>();

    _draftSub = client
        .streamDraftResponse(chatRoomId: chatRoomId)
        .listen((evt) {
          if (evt.event == 'lastDraftResponseUpdate') {
            final json = evt.dataJson;
            final drafts = json?['drafts'];
            if (drafts is List) {
              draftResponses
                ..clear()
                ..addAll(drafts.whereType<String>());
            } else {
              // Fallback: treat data as a single draft.
              if (evt.data.isNotEmpty) {
                draftResponses
                  ..clear()
                  ..add(evt.data);
              }
            }
            isDraftLoading = false;
          }
        }, onError: (_) {
          isDraftLoading = false;
        }, onDone: () {
          isDraftLoading = false;
        });
  }

  void dispose() {
    _draftSub?.cancel();
  }

  @action
  void _updateMessageReadStatus(String messageId, MessageReadStatus newStatus) {
    final index = messageList.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messageList[index] = messageList[index].copyWith(readStatus: newStatus);
    }
  }

  Future<void> _simulateReadStatusProgression(String messageId) async {
    // Sent → Delivered (after 500ms)
    await Future.delayed(const Duration(milliseconds: 500), () {
      _updateMessageReadStatus(messageId, MessageReadStatus.delivered);
    });

    // Delivered → Read (after 2 seconds)
    await Future.delayed(const Duration(milliseconds: 2000), () {
      _updateMessageReadStatus(messageId, MessageReadStatus.read);
    });
  }

  Future<void> _simulateAutoReply() async {
    // Show typing indicator after 3 second from sending message
    await Future.delayed(const Duration(milliseconds: 3000), () {
      isTyping = true;
    });

    // Send auto-reply after 2 seconds
    await Future.delayed(const Duration(milliseconds: 2000), () {
      final randomResponse =
          _defaultResponses[Random().nextInt(_defaultResponses.length)];

      final autoReplyMessage = Message(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        content: randomResponse,
        timestamp: DateTime.now(),
        isMe: false,
        senderName: 'AI Assistant',
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
