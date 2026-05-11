import 'dart:async';
import 'package:ai_helpdesk/core/domain/error/api_failure.dart';
import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/core/events/socket/server/ai/draft_response_sse_event.dart';
import 'package:ai_helpdesk/core/stores/error/error_store.dart';
import 'package:ai_helpdesk/data/realtime/socket/socket_service.dart';
import 'package:ai_helpdesk/data/realtime/sse/draft_response_sse_client.dart';
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
import '../../../domain/usecase/chat/search/flat_search_message_list_usecase.dart';

part 'chat_store.g.dart';

class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  final ObservableMap<String, ObservableList<Message>> _messageCache = ObservableMap();

  @computed
  ObservableList<Message> get currentMessages {
    final String? roomId = currentChatRoomId;

    if (roomId == null) return ObservableList<Message>();

    // Do not [putIfAbsent] here — a read during open would insert an empty
    // list into [_messageCache] and fight with the real fetch assignment.
    final ObservableList<Message>? list = _messageCache[roomId];
    return list ?? ObservableList<Message>();
  }

  final GetChatMessagesUseCase _getChatMessages;
  final SendMessageFromAgentToCustomerUseCase _sendMessage;
  final FlatSearchMessageListUseCase _flatSearchMessageList;
  final ReactToMessageUseCase _reactToMessage;
  final UnreactToMessageUseCase _unreactToMessage;
  final AnalyticsService _analyticsService;
  final ErrorStore _errorStore;
  final SocketService _socketService;

  /// Page size used for both initial open and scroll-up pagination.
  static const int _pageSize = 30;

  /// Maximum number of concurrent prefetch requests so the inbox prefetch
  /// does not overwhelm the API when there are many rooms.
  static const int _prefetchConcurrency = 4;

  /// Per-room flag — false once an older-message page returns fewer than
  /// [_pageSize] items (no more history).
  final Map<String, bool> _hasMoreOlderByRoom = <String, bool>{};

  StreamSubscription<Message>? _socketMessageSub;

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
    this._flatSearchMessageList,
    this._reactToMessage,
    this._unreactToMessage,
    this._analyticsService,
    this._errorStore,
    this._socketService,
  );

  @observable
  String? currentChatRoomId;

  @observable
  bool isLoading = false;

  @observable
  bool isLoadingOlderMessages = false;

  @observable
  bool isTyping = false;

  @computed
  bool get hasMoreOlderMessages {
    final String? roomId = currentChatRoomId;
    if (roomId == null) return false;
    return _hasMoreOlderByRoom[roomId] ?? true;
  }

  @observable
  ObservableList<String> draftResponses = ObservableList<String>();

  @observable
  bool isDraftLoading = false;

  StreamSubscription<DraftResponseSseEvent>? _draftSub;

  @observable
  String searchQuery = '';

  @computed
  List<Message> get filteredMessages {
    if (searchQuery.isEmpty) return currentMessages.toList();

    return currentMessages
        .where(
          (msg) =>
              msg.content.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  @action
  void setSearchQuery(String query) => searchQuery = query;

  /// Silently load the most recent [_pageSize] messages for each room so
  /// opening a room from the inbox feels instant. Failures are swallowed
  /// per-room. This does **not** mark rooms as seen.
  @action
  Future<void> prefetchMessagesForRooms(Iterable<String> roomIds) async {
    final List<String> pending = roomIds.where((String id) {
      final ObservableList<Message>? cached = _messageCache[id];
      return cached == null || cached.isEmpty;
    }).toList(growable: false);

    for (int i = 0; i < pending.length; i += _prefetchConcurrency) {
      final int end = (i + _prefetchConcurrency).clamp(0, pending.length);
      await Future.wait(
        pending.sublist(i, end).map(_prefetchSingleRoom),
        eagerError: false,
      );
    }
  }

  Future<void> _prefetchSingleRoom(String roomId) async {
    try {
      final List<Message> messages = await _getChatMessages(
        params: GetChatMessagesParams(
          chatRoomId: roomId,
          limit: _pageSize,
        ),
      );
      _messageCache[roomId] = ObservableList<Message>.of(messages);
      _hasMoreOlderByRoom[roomId] = messages.length >= _pageSize;
    } catch (_) {
      // Best-effort prefetch: a single failure must not block other rooms.
    }
  }

  /// Load the next older page (above the oldest cached message) for the
  /// currently open room. Prepends results in ascending order.
  @action
  Future<void> loadOlderMessages() async {
    final String? roomId = currentChatRoomId;
    if (roomId == null) return;
    if (isLoadingOlderMessages) return;
    if (!(_hasMoreOlderByRoom[roomId] ?? true)) return;

    final ObservableList<Message>? list = _messageCache[roomId];
    if (list == null || list.isEmpty) return;

    final String oldestId = list.first.id;

    try {
      isLoadingOlderMessages = true;

      final List<Message> older = await _getChatMessages(
        params: GetChatMessagesParams(
          chatRoomId: roomId,
          lastMessageId: oldestId,
          limit: _pageSize,
        ),
      );

      if (older.isEmpty) {
        _hasMoreOlderByRoom[roomId] = false;
        return;
      }

      final Set<String> existingIds = list.map((Message m) => m.id).toSet();
      final List<Message> deduped = older
          .where((Message m) => !existingIds.contains(m.id))
          .toList(growable: false);

      if (deduped.isNotEmpty) {
        list.insertAll(0, deduped);
      }

      _hasMoreOlderByRoom[roomId] = older.length >= _pageSize;
    } on ApiFailure catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoadingOlderMessages = false;
    }
  }

  @action
  void _mergeMessage(String roomId, Message message) {
    final list = _messageCache.putIfAbsent(
      roomId,
      () => ObservableList<Message>(),
    );

    if (list.isEmpty || message.order > list.last.order) {
      list.add(message);
    } else {
      final existingIndex = list.indexWhere((m) => m.id == message.id);

      if (existingIndex >= 0) {
        list[existingIndex] = message;
      } else {
        final insertIndex =
            list.indexWhere((m) => m.order > message.order);

        if (insertIndex == -1) {
          list.add(message);
        } else {
          list.insert(insertIndex, message);
        }
      }
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

      currentMessages.add(newMessage);
    } on Failure catch (e) {
      _errorStore.setErrorMessage(e.message);

      currentMessages.add(Message(
        id: '',
        conversationId: chatRoomId,
        order: currentMessages.last.order,
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
  Future<List<Message>> searchMessages(String keyword) async {
    if (currentChatRoomId == null) return [];

    final messages = await _flatSearchMessageList(
      params: FlatSearchMessageListParams(
        chatRoomId: currentChatRoomId!,
        keyword: keyword,
      ),
    );

    return messages;
  }

  void addReactionToMessage(String messageId, String emoji) {
    final index = currentMessages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final message = currentMessages[index];

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

        currentMessages[index] = message.copyWith(reactions: updatedReactions);
      } else {
        // Add new reaction
        currentMessages[index] = message.copyWith(
          reactions: [...message.reactions, Reaction(id: '', user: const User(id: 'You', name: 'You', avatar: ''), emoji: emoji, amount: 1)],
        );
      }
    }
  }

  @action
  void onSocketMessage(Message message) {
    // Merge by id to avoid duplicates.
    _mergeMessage(message.conversationId, message);
  }

  /// Subscribe to the underlying [SocketService.messages] stream so any
  /// inbound chat message reaches [_mergeMessage]. Idempotent.
  void bindSocket() {
    if (_socketMessageSub != null) return;
    _socketMessageSub = _socketService.messages.listen(onSocketMessage);
  }

  /// Cancel the socket subscription. Safe to call multiple times.
  Future<void> unbindSocket() async {
    await _socketMessageSub?.cancel();
    _socketMessageSub = null;
  }

  @action
  void onSocketTyping({required bool typing}) {
    isTyping = typing;
  }

  @action
  Future<void> generateDraftResponses({required String chatRoomId}) async {
    await _draftSub?.cancel();
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
    _socketMessageSub?.cancel();
  }

}
