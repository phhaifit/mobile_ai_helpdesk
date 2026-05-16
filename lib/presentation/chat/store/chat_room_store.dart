import 'dart:async';
import 'dart:developer' as developer;

import 'package:ai_helpdesk/domain/entity/chat/chat_room.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_room_last_message_update.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_room_seen_update.dart';
import 'package:ai_helpdesk/domain/entity/chat/in_app_notification.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';
import 'package:ai_helpdesk/domain/repository/setting/setting_repository.dart';
import 'package:ai_helpdesk/domain/usecase/chat/chat_list/get_chat_rooms_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/chat_list/mark_chat_room_as_seen_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/realtime/observe_chat_room_last_message_updates_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/realtime/observe_chat_room_seen_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/realtime/observe_in_app_notifications_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/realtime/observe_incoming_messages_usecase.dart'
    show NoParams, ObserveIncomingMessagesUseCase;
import 'package:mobx/mobx.dart';

part 'chat_room_store.g.dart';

// ignore: library_private_types_in_public_api
class ChatRoomStore = _ChatRoomStore with _$ChatRoomStore;

abstract class _ChatRoomStore with Store {
  final GetChatRoomsUseCase _getChatRooms;
  final MarkChatRoomAsSeenUseCase _markChatRoomAsSeen;
  final ObserveIncomingMessagesUseCase _observeIncomingMessages;
  final ObserveChatRoomSeenUseCase _observeChatRoomSeen;
  final ObserveInAppNotificationsUseCase _observeInAppNotifications;
  final ObserveChatRoomLastMessageUpdatesUseCase
      _observeChatRoomLastMessageUpdates;
  final SettingRepository _settingRepository;

  StreamSubscription<Message>? _incomingMessageSub;
  StreamSubscription<ChatRoomSeenUpdate>? _seenSub;
  StreamSubscription<InAppNotification>? _notificationSub;
  StreamSubscription<ChatRoomLastMessageUpdate>? _lastMessageSub;

  @observable
  String? activeRoomId;

  _ChatRoomStore(
    this._getChatRooms,
    this._markChatRoomAsSeen,
    this._observeIncomingMessages,
    this._observeChatRoomSeen,
    this._observeInAppNotifications,
    this._observeChatRoomLastMessageUpdates,
    this._settingRepository,
  ) {
    _bindRealtime();
  }

  @observable
  ObservableList<ChatRoom> chatRooms = ObservableList<ChatRoom>();

  @observable
  bool isLoading = false;

  @computed
  int get totalUnread =>
      chatRooms.fold(0, (int sum, ChatRoom room) => sum + room.unreadCount);

  void _bindRealtime() {
    _incomingMessageSub?.cancel();
    _seenSub?.cancel();
    _notificationSub?.cancel();
    _lastMessageSub?.cancel();

    _incomingMessageSub = _observeIncomingMessages
        .call(params: const NoParams())
        .listen(_onIncomingMessage);

    _seenSub = _observeChatRoomSeen
        .call(params: const NoParams())
        .listen(_onRoomSeen);

    _notificationSub = _observeInAppNotifications
        .call(params: const NoParams())
        .listen(_onInAppNotification);

    _lastMessageSub = _observeChatRoomLastMessageUpdates
        .call(params: const NoParams())
        .listen((ChatRoomLastMessageUpdate update) {
      updateLastMessage(update.chatRoomId, update.message);
    });
  }

  @action
  void setActiveRoomId(String? roomId) {
    activeRoomId = roomId;
  }

  void _onIncomingMessage(Message message) {
    final String roomId = message.conversationId;
    final int index = chatRooms.indexWhere((ChatRoom r) => r.id == roomId);
    if (index == -1) return;

    final ChatRoom room = chatRooms[index];
    final bool isActiveRoom = activeRoomId == roomId;
    final int unread = isActiveRoom ? 0 : room.unreadCount + 1;

    chatRooms[index] = room.copyWith(
      lastMessage: message,
      lastMessageTime: message.timestamp,
      unreadCount: unread,
    );
    _sortChatRoomsByLastMessageTime();
  }

  @action
  void _onRoomSeen(ChatRoomSeenUpdate update) {
    final int index =
        chatRooms.indexWhere((ChatRoom r) => r.id == update.chatRoomId);
    if (index == -1) return;
    chatRooms[index] = chatRooms[index].copyWith(unreadCount: 0);
  }

  @action
  void _onInAppNotification(InAppNotification notification) {
    // NEW_MESSAGE: [ChatRepositoryImpl] fetches newer messages and emits the
    // latest via the incoming-messages stream (_onIncomingMessage).
    if (_isNewMessageNotification(notification.type)) {
      return;
    }

    final String? roomId = notification.chatRoomId;
    if (roomId == null || roomId.isEmpty) return;

    final int index = chatRooms.indexWhere((ChatRoom r) => r.id == roomId);
    if (index == -1) return;

    final ChatRoom room = chatRooms[index];
    final bool isActiveRoom = activeRoomId == roomId;
    final int unread = isActiveRoom ? 0 : room.unreadCount + 1;

    chatRooms[index] = room.copyWith(
      unreadCount: unread,
      lastMessage: room.lastMessage.copyWith(content: notification.body),
      lastMessageTime: notification.createdAt ?? DateTime.now(),
    );
    _sortChatRoomsByLastMessageTime();
  }

  @action
  Future<void> fetchChatRooms() async {
    isLoading = true;
    final List<ChatRoom> rooms = await _getChatRooms.call(
      params: ChatRoomListQuery.inboxDefault,
    );
    chatRooms
      ..clear()
      ..addAll(rooms);
    _sortChatRoomsByLastMessageTime();
    isLoading = false;
  }

  @action
  void clearRooms() {
    chatRooms.clear();
  }

  @action
  Future<void> markAsRead(ChatRoom room) async {
    try {
      final int index = chatRooms.indexWhere((ChatRoom r) => r.id == room.id);
      if (index == -1) return;
      if (room.unreadCount == 0) return;

      await _markChatRoomAsSeen(
        params: MarkChatRoomAsSeenParams(
          chatRoomId: room.id,
          messageId: room.lastMessage.id,
          messageOrder: room.lastMessage.order,
          socketId: _settingRepository.socketId,
        ),
      );

      chatRooms[index] = chatRooms[index].copyWith(unreadCount: 0);
    } catch (e) {
      developer.log(
        'ERROR: Failed to mark chat room as seen: ${e.toString()}',
        name: 'ChatRoomStore',
        error: 'Mark-seen Failed',
      );
    }
  }

  @action
  void updateLastMessage(String roomId, Message message, {bool isMe = true}) {
    final int index = chatRooms.indexWhere((ChatRoom r) => r.id == roomId);
    if (index == -1) return;

    chatRooms[index] = chatRooms[index].copyWith(
      lastMessage: message,
      lastMessageTime: message.timestamp,
    );
    _sortChatRoomsByLastMessageTime();
  }

  void _sortChatRoomsByLastMessageTime() {
    chatRooms.sort(
      (ChatRoom a, ChatRoom b) => b.lastMessageTime.compareTo(a.lastMessageTime),
    );
  }

  bool _isNewMessageNotification(String type) {
    final String normalized =
        type.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '_');
    return normalized == 'NEW_MESSAGE';
  }

  void dispose() {
    unawaited(_incomingMessageSub?.cancel());
    unawaited(_seenSub?.cancel());
    unawaited(_notificationSub?.cancel());
    _incomingMessageSub = null;
    _seenSub = null;
    _notificationSub = null;
  }
}
