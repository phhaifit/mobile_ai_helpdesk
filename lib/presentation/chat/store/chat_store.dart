import 'dart:async';

import 'package:ai_helpdesk/core/domain/error/api_failure.dart';
import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/core/stores/error/error_store.dart';
import 'package:ai_helpdesk/domain/entity/chat/attachment.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_typing_event.dart';
import 'package:ai_helpdesk/domain/entity/chat/draft_response_progress.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart' show Message;
import 'package:ai_helpdesk/domain/entity/chat/message_reaction_update.dart';
import 'package:ai_helpdesk/domain/entity/chat/reaction.dart';
import 'package:ai_helpdesk/domain/entity/chat/user.dart' show User;
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';
import 'package:ai_helpdesk/domain/usecase/chat/ai/generate_ai_draft_response_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/chat_detail/react_to_message_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/chat_detail/send_message_from_agent_to_customer_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/chat_detail/unreact_to_message_usecase.dart';
import 'package:ai_helpdesk/domain/repository/setting/setting_repository.dart';
import 'package:ai_helpdesk/domain/usecase/chat/realtime/observe_chat_messages_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/realtime/observe_customer_typing_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/realtime/observe_draft_progress_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/realtime/observe_incoming_messages_usecase.dart'
    show NoParams;
import 'package:ai_helpdesk/domain/usecase/chat/realtime/observe_reaction_updates_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/search/flat_search_message_list_usecase.dart';
import 'package:mobx/mobx.dart' hide Reaction;

import '../../../constants/analytics_events.dart';
import '../../../domain/analytics/analytics_service.dart';

part 'chat_store.g.dart';

class ChatStore = _ChatStore with _$ChatStore;

abstract class _ChatStore with Store {
  final SendMessageFromAgentToCustomerUseCase _sendMessage;
  final FlatSearchMessageListUseCase _flatSearchMessageList;
  final ReactToMessageUseCase _reactToMessage;
  final UnreactToMessageUseCase _unreactToMessage;
  final GenerateAiDraftResponseUseCase _generateAiDraftResponse;
  final ObserveChatMessagesUseCase _observeChatMessages;
  final ObserveReactionUpdatesUseCase _observeReactionUpdates;
  final ObserveCustomerTypingUseCase _observeCustomerTyping;
  final ObserveDraftProgressUseCase _observeDraftProgress;
  final SettingRepository _settingRepository;
  final AnalyticsService _analyticsService;
  final ErrorStore _errorStore;
  final ChatRepository _chatRepository;

  StreamSubscription<List<Message>>? _messagesSub;
  StreamSubscription<MessageReactionUpdate>? _reactionSub;
  StreamSubscription<ChatTypingEvent>? _typingSub;
  StreamSubscription<DraftResponseProgress>? _draftProgressSub;

  String? _currentTicketId;
  String? _currentChannelId;

  _ChatStore(
    this._sendMessage,
    this._flatSearchMessageList,
    this._reactToMessage,
    this._unreactToMessage,
    this._generateAiDraftResponse,
    this._analyticsService,
    this._errorStore,
    this._chatRepository,
    this._observeChatMessages,
    this._observeReactionUpdates,
    this._observeCustomerTyping,
    this._observeDraftProgress,
    this._settingRepository,
  );

  @observable
  ObservableList<Message> currentMessages = ObservableList<Message>();

  @observable
  String? currentChatRoomId;

  @observable
  bool isLoading = false;

  @observable
  bool isLoadingOlderMessages = false;

  @observable
  bool isSendingMessage = false;

  @observable
  bool isCustomerTyping = false;

  @observable
  String? typingActorLabel;

  @observable
  String? suggestedReply;

  @observable
  bool isSuggestedReplyLoading = false;

  @observable
  bool isSuggestedReplyPanelExpanded = true;

  @observable
  String? activeDraftTaskId;

  @observable
  String? draftError;

  @observable
  String searchQuery = '';

  @computed
  bool get hasMoreOlderMessages {
    final String? roomId = currentChatRoomId;
    if (roomId == null) return false;
    return _chatRepository.hasMoreOlderMessages(roomId);
  }

  @computed
  bool get showSuggestedReplyPanel =>
      isSuggestedReplyLoading ||
      suggestedReply != null ||
      draftError != null;

  @computed
  List<Message> get filteredMessages {
    if (searchQuery.isEmpty) return currentMessages.toList();

    return currentMessages
        .where(
          (Message msg) =>
              msg.content.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  @action
  void setSearchQuery(String query) => searchQuery = query;

  @action
  void resetAfterTenantSwitch() {
    _cancelRealtimeSubscriptions();
    _chatRepository.resetMessageCache();
    currentChatRoomId = null;
    _currentTicketId = null;
    _currentChannelId = null;
    isLoading = false;
    isLoadingOlderMessages = false;
    isSendingMessage = false;
    isCustomerTyping = false;
    typingActorLabel = null;
    searchQuery = '';
    currentMessages.clear();
    _clearSuggestedReplyState();
    activeDraftTaskId = null;
  }

  void _cancelRealtimeSubscriptions() {
    unawaited(_messagesSub?.cancel());
    _messagesSub = null;
    unawaited(_reactionSub?.cancel());
    _reactionSub = null;
    unawaited(_typingSub?.cancel());
    _typingSub = null;
    unawaited(_draftProgressSub?.cancel());
    _draftProgressSub = null;
  }

  @action
  void _clearSuggestedReplyState() {
    suggestedReply = null;
    isSuggestedReplyLoading = false;
    draftError = null;
  }

  @action
  Future<void> observeRoom(
    String roomId, {
    int unreadCount = 0,
    String? ticketId,
    String? channelId,
  }) async {
    currentChatRoomId = roomId;
    _currentTicketId = ticketId;
    _currentChannelId = channelId;
    isCustomerTyping = false;
    typingActorLabel = null;

    _cancelRealtimeSubscriptions();

    _messagesSub = _observeChatMessages
        .call(params: ObserveMessagesParams(roomId: roomId))
        .listen((List<Message> messages) {
      currentMessages
        ..clear()
        ..addAll(messages);
    });

    _reactionSub = _observeReactionUpdates
        .call(params: const NoParams())
        .listen((MessageReactionUpdate update) {
      if (update.chatRoomId != roomId) return;
      // Messages stream refreshes from repository cache after reaction merge.
    });

    _typingSub = _observeCustomerTyping.call(params: const NoParams()).listen(
      (ChatTypingEvent event) {
        if (event.chatRoomId != roomId) return;
        isCustomerTyping = event.isTyping;
        typingActorLabel = event.isTyping ? event.actorName : null;
      },
    );

    _draftProgressSub =
        _observeDraftProgress.call(params: const NoParams()).listen(
      _onDraftProgress,
    );

    if (unreadCount > 0 && suggestedReply == null && !isSuggestedReplyLoading) {
      await generateSuggestedReply(
        chatRoomId: roomId,
        ticketId: ticketId,
      );
    }
  }

  @action
  void _onDraftProgress(DraftResponseProgress progress) {
    if (activeDraftTaskId != null && progress.taskId != activeDraftTaskId) {
      return;
    }

    if (progress.isInProgress) {
      isSuggestedReplyLoading = true;
      draftError = null;
      return;
    }

    if (progress.isFailed) {
      isSuggestedReplyLoading = false;
      draftError = progress.errorMessage ?? 'Draft generation failed';
      return;
    }

    if (progress.isCompleted) {
      isSuggestedReplyLoading = false;
      draftError = null;
      final String? text = progress.suggestionText;
      if (text != null && text.isNotEmpty) {
        suggestedReply = text;
        isSuggestedReplyPanelExpanded = true;
      } else {
        draftError = 'No suggestion returned';
      }
    }
  }

  @action
  Future<void> generateSuggestedReply({
    required String chatRoomId,
    String? ticketId,
  }) async {
    if (currentChatRoomId != chatRoomId) {
      currentChatRoomId = chatRoomId;
    }

    suggestedReply = null;
    draftError = null;
    isSuggestedReplyLoading = true;
    isSuggestedReplyPanelExpanded = true;
    activeDraftTaskId = null;

    try {
      final Map<String, dynamic> data = await _generateAiDraftResponse.call(
        params: GenerateAiDraftResponseParams(
          chatRoomId: chatRoomId,
          ticketId: ticketId ?? _currentTicketId,
        ),
      );
      final String? taskId = data['taskId']?.toString();
      if (taskId == null || taskId.isEmpty) {
        isSuggestedReplyLoading = false;
        draftError = 'Missing draft task id';
        return;
      }
      activeDraftTaskId = taskId;
    } on Failure catch (e) {
      isSuggestedReplyLoading = false;
      draftError = e.message;
      _errorStore.setErrorMessage(e.message);
    } catch (e) {
      isSuggestedReplyLoading = false;
      draftError = e.toString();
      _errorStore.setErrorMessage(e.toString());
    }
  }

  @action
  Future<void> regenerateSuggestedReply() async {
    final String? roomId = currentChatRoomId;
    if (roomId == null) return;
    await generateSuggestedReply(
      chatRoomId: roomId,
      ticketId: _currentTicketId,
    );
  }

  @action
  void dismissSuggestedReply() {
    suggestedReply = null;
    draftError = null;
    isSuggestedReplyLoading = false;
    activeDraftTaskId = null;
  }

  @action
  void toggleSuggestedReplyPanel() {
    isSuggestedReplyPanelExpanded = !isSuggestedReplyPanelExpanded;
  }

  @action
  Future<void> prefetchMessagesForRooms(Iterable<String> roomIds) async {
    await _chatRepository.prefetchMessagesForRooms(roomIds);
  }

  @action
  Future<void> loadOlderMessages() async {
    final String? roomId = currentChatRoomId;
    if (roomId == null) return;
    if (isLoadingOlderMessages) return;
    if (!_chatRepository.hasMoreOlderMessages(roomId)) return;

    try {
      isLoadingOlderMessages = true;
      await _chatRepository.loadOlderMessages(roomId);
    } on ApiFailure catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoadingOlderMessages = false;
    }
  }

  @action
  Future<void> sendMessage(
    String chatRoomId,
    String channelId,
    String contactId,
    String ticketId,
    String text,
    List<Attachment>? attachments, {
    String? replyMessageId,
  }) async {
    if (text.trim().isEmpty && (attachments?.isEmpty ?? true)) return;

    try {
      final Message newMessage = await _sendMessage.call(
        params: SendAgentToCustomerMessageParams(
          chatRoomId: chatRoomId,
          channelId: channelId,
          contactId: contactId,
          ticketId: ticketId,
          content: text,
          attachments: attachments,
          replyMessageId: replyMessageId,
          socketId: _settingRepository.socketId,
        ),
      );

      _chatRepository.mergeMessage(roomId: chatRoomId, message: newMessage);
    } on Failure catch (e) {
      _errorStore.setErrorMessage(e.message);

      currentMessages.add(
        Message(
          id: '',
          conversationId: chatRoomId,
          order: currentMessages.isNotEmpty ? currentMessages.first.order : 0,
          sender: const User(id: '', name: '', avatar: ''),
          isMe: true,
          content: e.message,
          attachments: attachments ?? <Attachment>[],
          timestamp: DateTime.now(),
          replyMessageId: null,
          reactions: const <Reaction>[],
        ),
      );
    } finally {
      isSendingMessage = false;
    }

    unawaited(
      _analyticsService.trackEvent(
        AnalyticsEvents.messageSent,
        parameters: <String, String>{'channel': 'chat'},
      ),
    );
  }

  @action
  Future<List<Message>> searchMessages(String keyword) async {
    if (currentChatRoomId == null) return <Message>[];

    return _flatSearchMessageList(
      params: FlatSearchMessageListParams(
        chatRoomId: currentChatRoomId!,
        keyword: keyword,
      ),
    );
  }

  @action
  Future<void> reactToMessage({
    required Message message,
    required String reactIcon,
    required String chatRoomId,
    String? channelId,
  }) async {
    if (!message.canReactOnZalo) {
      _errorStore.setErrorMessage(
        'Reactions are only available for Zalo messages with valid Zalo IDs.',
      );
      return;
    }

    _applyOptimisticReaction(messageId: message.id, emoji: reactIcon);

    try {
      await _reactToMessage.call(
        params: ReactToMessageRequest(
          messageId: message.id,
          zaloMessageId: message.zaloMessageId!,
          reactIcon: reactIcon,
          zaloAccountId: message.zaloAccountId!,
          chatRoomId: chatRoomId,
          channelId: channelId ?? _currentChannelId,
          socketId: _settingRepository.socketId,
        ),
      );
    } on Failure catch (e) {
      _errorStore.setErrorMessage(e.message);
    }
  }

  void _applyOptimisticReaction({
    required String messageId,
    required String emoji,
  }) {
    final int index = currentMessages.indexWhere((Message m) => m.id == messageId);
    if (index == -1) return;

    final Message message = currentMessages[index];
    final int reactionIndex =
        message.reactions.indexWhere((Reaction r) => r.emoji == emoji);

    if (reactionIndex != -1) {
      final Reaction existingReaction = message.reactions[reactionIndex];
      final List<Reaction> updatedReactions = message.reactions.toList();
      updatedReactions[reactionIndex] = existingReaction.copyWith(
        user: const User(id: 'You', name: 'You', avatar: ''),
        amount: existingReaction.amount + 1,
      );
      currentMessages[index] =
          message.copyWith(reactions: updatedReactions);
    } else {
      currentMessages[index] = message.copyWith(
        reactions: <Reaction>[
          ...message.reactions,
          Reaction(
            id: '',
            user: const User(id: 'You', name: 'You', avatar: ''),
            emoji: emoji,
            amount: 1,
          ),
        ],
      );
    }
  }

  /// @deprecated Use [generateSuggestedReply] instead.
  @action
  Future<void> generateDraftResponses({required String chatRoomId}) async {
    await generateSuggestedReply(chatRoomId: chatRoomId);
  }

  Future<void> dispose() async {
    _cancelRealtimeSubscriptions();
  }
}
