import 'dart:async';
import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/core/events/socket/server/ai/draft_response_sse_event.dart';
import 'package:ai_helpdesk/core/stores/error/error_store.dart';
import 'package:ai_helpdesk/data/realtime/sse/draft_response_sse_client.dart';
import 'package:ai_helpdesk/domain/usecase/chat/chat_detail/get_newer_chat_messages_usecase.dart';
import 'package:mobx/mobx.dart' hide Reaction;
import '../../../constants/analytics_events.dart';
import '../../../di/service_locator.dart';
import '../../../domain/analytics/analytics_service.dart';
import '../../../domain/entity/chat/attachment.dart';
import '../../../domain/entity/chat/message.dart' show Message;
import '../../../domain/entity/chat/reaction.dart';
import '../../../domain/entity/chat/user.dart' show User;
import '../../../domain/usecase/chat/chat_detail/get_chat_messages_usecase.dart';
import '../../../domain/usecase/chat/chat_detail/react_to_message_usecase.dart';
import '../../../domain/usecase/chat/chat_detail/send_message_from_agent_to_customer_usecase.dart';
import '../../../domain/usecase/chat/chat_detail/unreact_to_message_usecase.dart';

part 'chat_store.g.dart';

class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  final ObservableMap<String, ObservableList<Message>> _messageCache = ObservableMap();

  @computed
  ObservableList<Message> get currentMessages {
    final roomId = currentChatRoomId;

    if (roomId == null) return ObservableList();

    return _messageCache.putIfAbsent(
      roomId,
      () => ObservableList<Message>(),
    );
  }

  final GetChatMessagesUseCase _getChatMessages;
  final GetNewerChatMessagesUseCase _getNewerChatMessages;
  final SendMessageFromAgentToCustomerUseCase _sendMessage;
  final ReactToMessageUseCase _reactToMessage;
  final UnreactToMessageUseCase _unreactToMessage;
  final AnalyticsService _analyticsService;
  final ErrorStore _errorStore;

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
    this._getNewerChatMessages,
    this._sendMessage,
    this._reactToMessage,
    this._unreactToMessage,
    this._analyticsService,
    this._errorStore,
  );

  @observable
  String? currentChatRoomId;

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
  Future<void> openRoom(String chatRoomId) async {
    currentChatRoomId = chatRoomId;

    final existing = _messageCache[chatRoomId];

    // Already cached
    if (existing != null && existing.isNotEmpty) {
      await _syncNewerMessages(chatRoomId);
      return;
    }

    isLoading = true;

    final messages = await _getChatMessages(
      params: GetChatMessagesParams(
        chatRoomId: chatRoomId,
      ),
    );

    _messageCache[chatRoomId] =
        ObservableList.of(messages);

    isLoading = false;
  }

  @action
  Future<void> _syncNewerMessages(String roomId) async {
    final messages = _messageCache[roomId];

    if (messages == null || messages.isEmpty) return;

    final latestId = messages.last.id;

    final newer = await _getNewerChatMessages(
      params: GetNewerChatMessagesParams(
        chatRoomId: roomId,
        lastMessageId: latestId,
      ),
    );

    for (final msg in newer) {
      _mergeMessage(roomId, msg);
    }
  }

  @action
  void _mergeMessage(String roomId, Message message) {
    final list = _messageCache.putIfAbsent(
      roomId,
      () => ObservableList<Message>(),
    );

    final index = list.indexWhere((m) => m.id == message.id);

    if (index >= 0) {
      list[index] = message;
    } else {
      list.add(message);

      list.sort((a, b) => a.order.compareTo(b.order));
    }
  }

  @action
  Future<void> sendMessage(String chatRoomId, String channelId, String contactId, String ticketId, String text, List<Attachment>? attachments) async {
    if (text.trim().isEmpty && (attachments?.isEmpty ?? true)) return;

    try {
      final newMessage = await _sendMessage.call(
        params: SendAgentToCustomerMessageParams(
          chatRoomId: chatRoomId,
          channelId: channelId,
          contactId: contactId,
          ticketId: ticketId,
          content: text,
          attachments: attachments,
        ),
      );

      messageList.add(newMessage);
    } on Failure catch (e) {
      _errorStore.setErrorMessage(e.message);

      messageList.add(Message(
        id: '',
        conversationId: chatRoomId,
        order: messageList.last.order,
        sender: const User(id: '', name: '', avatar: ''),
        isMe: true,
        content: e.message,
        attachments: attachments ?? [],
        timestamp: DateTime.now(),
        replyMessageId: null,
        reactions: [],
      ));
    }

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
          user: const User(id: 'You', name: 'You', avatar: ''),
        );

        final updatedReactions = message.reactions.toList();
        updatedReactions[reactionIndex] = updatedReaction;

        messageList[index] = message.copyWith(reactions: updatedReactions);
      } else {
        // Add new reaction
        messageList[index] = message.copyWith(
          reactions: [...message.reactions, Reaction(id: '', user: const User(id: 'You', name: 'You', avatar: ''), emoji: emoji, amount: 1)],
        );
      }
    }
  }

  @action
  void onSocketMessage(Message message) {
    // Merge by id to avoid duplicates.
    _mergeMessage(currentChatRoomId!, message);
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

}
