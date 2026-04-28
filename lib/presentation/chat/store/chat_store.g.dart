// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatStore on _ChatStore, Store {
  Computed<List<Message>>? _$filteredMessagesComputed;

  @override
  List<Message> get filteredMessages =>
      (_$filteredMessagesComputed ??= Computed<List<Message>>(
            () => super.filteredMessages,
            name: '_ChatStore.filteredMessages',
          ))
          .value;

  late final _$messageListAtom = Atom(
    name: '_ChatStore.messageList',
    context: context,
  );

  @override
  ObservableList<Message> get messageList {
    _$messageListAtom.reportRead();
    return super.messageList;
  }

  @override
  set messageList(ObservableList<Message> value) {
    _$messageListAtom.reportWrite(value, super.messageList, () {
      super.messageList = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_ChatStore.isLoading',
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

  late final _$isTypingAtom = Atom(
    name: '_ChatStore.isTyping',
    context: context,
  );

  @override
  bool get isTyping {
    _$isTypingAtom.reportRead();
    return super.isTyping;
  }

  @override
  set isTyping(bool value) {
    _$isTypingAtom.reportWrite(value, super.isTyping, () {
      super.isTyping = value;
    });
  }

  late final _$draftResponsesAtom = Atom(
    name: '_ChatStore.draftResponses',
    context: context,
  );

  @override
  ObservableList<String> get draftResponses {
    _$draftResponsesAtom.reportRead();
    return super.draftResponses;
  }

  @override
  set draftResponses(ObservableList<String> value) {
    _$draftResponsesAtom.reportWrite(value, super.draftResponses, () {
      super.draftResponses = value;
    });
  }

  late final _$isDraftLoadingAtom = Atom(
    name: '_ChatStore.isDraftLoading',
    context: context,
  );

  @override
  bool get isDraftLoading {
    _$isDraftLoadingAtom.reportRead();
    return super.isDraftLoading;
  }

  @override
  set isDraftLoading(bool value) {
    _$isDraftLoadingAtom.reportWrite(value, super.isDraftLoading, () {
      super.isDraftLoading = value;
    });
  }

  late final _$searchQueryAtom = Atom(
    name: '_ChatStore.searchQuery',
    context: context,
  );

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$getMessagesAsyncAction = AsyncAction(
    '_ChatStore.getMessages',
    context: context,
  );

  @override
  Future<void> getMessages(String chatRoomId) {
    return _$getMessagesAsyncAction.run(() => super.getMessages(chatRoomId));
  }

  late final _$generateDraftResponsesAsyncAction = AsyncAction(
    '_ChatStore.generateDraftResponses',
    context: context,
  );

  @override
  Future<void> generateDraftResponses({required String chatRoomId}) {
    return _$generateDraftResponsesAsyncAction.run(
      () => super.generateDraftResponses(chatRoomId: chatRoomId),
    );
  }

  late final _$_ChatStoreActionController = ActionController(
    name: '_ChatStore',
    context: context,
  );

  @override
  void setSearchQuery(String query) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
      name: '_ChatStore.setSearchQuery',
    );
    try {
      return super.setSearchQuery(query);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sendMessage(String text) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
      name: '_ChatStore.sendMessage',
    );
    try {
      return super.sendMessage(text);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addReactionToMessage(String messageId, String emoji) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
      name: '_ChatStore.addReactionToMessage',
    );
    try {
      return super.addReactionToMessage(messageId, emoji);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSocketMessage(Message message) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
      name: '_ChatStore.onSocketMessage',
    );
    try {
      return super.onSocketMessage(message);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSocketTyping({required bool typing}) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
      name: '_ChatStore.onSocketTyping',
    );
    try {
      return super.onSocketTyping(typing: typing);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _updateMessageReadStatus(String messageId, InvalidType newStatus) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
      name: '_ChatStore._updateMessageReadStatus',
    );
    try {
      return super._updateMessageReadStatus(messageId, newStatus);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
messageList: ${messageList},
isLoading: ${isLoading},
isTyping: ${isTyping},
draftResponses: ${draftResponses},
isDraftLoading: ${isDraftLoading},
searchQuery: ${searchQuery},
filteredMessages: ${filteredMessages}
    ''';
  }
}
