// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatRoomStore on _ChatRoomStore, Store {
  Computed<int>? _$totalUnreadComputed;

  @override
  int get totalUnread =>
      (_$totalUnreadComputed ??= Computed<int>(
            () => super.totalUnread,
            name: '_ChatRoomStore.totalUnread',
          ))
          .value;

  late final _$activeRoomIdAtom = Atom(
    name: '_ChatRoomStore.activeRoomId',
    context: context,
  );

  @override
  String? get activeRoomId {
    _$activeRoomIdAtom.reportRead();
    return super.activeRoomId;
  }

  @override
  set activeRoomId(String? value) {
    _$activeRoomIdAtom.reportWrite(value, super.activeRoomId, () {
      super.activeRoomId = value;
    });
  }

  late final _$chatRoomsAtom = Atom(
    name: '_ChatRoomStore.chatRooms',
    context: context,
  );

  @override
  ObservableList<ChatRoom> get chatRooms {
    _$chatRoomsAtom.reportRead();
    return super.chatRooms;
  }

  @override
  set chatRooms(ObservableList<ChatRoom> value) {
    _$chatRoomsAtom.reportWrite(value, super.chatRooms, () {
      super.chatRooms = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_ChatRoomStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$fetchChatRoomsAsyncAction = AsyncAction(
    '_ChatRoomStore.fetchChatRooms',
    context: context,
  );

  @override
  Future<void> fetchChatRooms() {
    return _$fetchChatRoomsAsyncAction.run(() => super.fetchChatRooms());
  }

  late final _$markAsReadAsyncAction = AsyncAction(
    '_ChatRoomStore.markAsRead',
    context: context,
  );

  @override
  Future<void> markAsRead(ChatRoom room) {
    return _$markAsReadAsyncAction.run(() => super.markAsRead(room));
  }

  late final _$_ChatRoomStoreActionController = ActionController(
    name: '_ChatRoomStore',
    context: context,
  );

  @override
  void setActiveRoomId(String? roomId) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
      name: '_ChatRoomStore.setActiveRoomId',
    );
    try {
      return super.setActiveRoomId(roomId);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _onRoomSeen(ChatRoomSeenUpdate update) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
      name: '_ChatRoomStore._onRoomSeen',
    );
    try {
      return super._onRoomSeen(update);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _onInAppNotification(InAppNotification notification) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
      name: '_ChatRoomStore._onInAppNotification',
    );
    try {
      return super._onInAppNotification(notification);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearRooms() {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
      name: '_ChatRoomStore.clearRooms',
    );
    try {
      return super.clearRooms();
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateLastMessage(String roomId, Message message, {bool isMe = true}) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
      name: '_ChatRoomStore.updateLastMessage',
    );
    try {
      return super.updateLastMessage(roomId, message, isMe: isMe);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
activeRoomId: ${activeRoomId},
chatRooms: ${chatRooms},
isLoading: ${isLoading},
totalUnread: ${totalUnread}
    ''';
  }
}
