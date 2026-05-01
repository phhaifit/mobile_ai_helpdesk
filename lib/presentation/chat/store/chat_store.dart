import 'dart:async';
import 'dart:math';
import 'package:ai_helpdesk/core/events/socket/server/ai/draft_response_sse_event.dart';
import 'package:ai_helpdesk/data/realtime/sse/draft_response_sse_client.dart';
import 'package:mobx/mobx.dart' hide Reaction;
import '../../../constants/analytics_events.dart';
import '../../../di/service_locator.dart';
import '../../../domain/analytics/analytics_service.dart';
import '../../../domain/entity/chat/message.dart' show Message;
import '../../../domain/entity/chat/reaction.dart';
import '../../../domain/entity/chat/seen_info.dart' show SeenInfo;
import '../../../domain/entity/chat/user.dart' show User;
import '../../../domain/usecase/chat/chat_detail/get_chat_messages_usecase.dart';
import '../../../domain/usecase/chat/chat_detail/react_to_message_usecase.dart';
import '../../../domain/usecase/chat/chat_detail/send_message_from_agent_to_customer_usecase.dart';
import '../../../domain/usecase/chat/chat_detail/unreact_to_message_usecase.dart';

part 'chat_store.g.dart';

class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  final Map<String, List<Message>> _messageCache = {};

  final GetChatMessagesUseCase _getChatMessages;
  final SendMessageFromAgentToCustomerUseCase _sendMessage;
  final ReactToMessageUseCase _reactToMessage;
  final UnreactToMessageUseCase _unreactToMessage;
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

  _ChatStore(
    this._getChatMessages,
    this._sendMessage,
    this._reactToMessage,
    this._unreactToMessage,
    this._analyticsService,
  );

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
  void setSearchQuery(String query) => searchQuery = query;

  @action
  Future<void> getMessages(String chatRoomId) async {
    isLoading = true;
    messageList.clear(); // Clear sebelum load pesan baru
    final messages = await _getChatMessages.call(
      params: GetChatMessagesParams(chatRoomId: chatRoomId),
    );
    messageList.addAll(messages);
    isLoading = false;
  }

  @action
  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Track message sent event
    _analyticsService.trackEvent(
      AnalyticsEvents.messageSent,
      parameters: {'channel': 'chat'},
    );
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
          user: User(id: 'You', name: 'You', avatar: ''),
        );

        final updatedReactions = message.reactions.toList();
        updatedReactions[reactionIndex] = updatedReaction;

        messageList[index] = message.copyWith(reactions: updatedReactions);
      } else {
        // Add new reaction
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
        .listen(
          (evt) {
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
          },
          onError: (_) {
            isDraftLoading = false;
          },
          onDone: () {
            isDraftLoading = false;
          },
        );
  }

  void dispose() {
    _draftSub?.cancel();
  }

  @action
  void _updateMessageReadStatus(String messageId, SeenInfo newSeenInfo) {
    final index = messageList.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messageList[index] = messageList[index].copyWith(seenInfo: newSeenInfo);
    }
  }
}
