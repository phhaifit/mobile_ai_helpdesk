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

  late final _$_ChatRoomStoreActionController = ActionController(
    name: '_ChatRoomStore',
    context: context,
  );

  @override
  void markAsRead(String roomId) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
      name: '_ChatRoomStore.markAsRead',
    );
    try {
      return super.markAsRead(roomId);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateLastMessage(String roomId, String message, {bool isMe = true}) {
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
chatRooms: ${chatRooms},
isLoading: ${isLoading},
totalUnread: ${totalUnread}
    ''';
  }
}
