// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChatStore on _ChatStore, Store {
  Computed<bool>? _$hasMoreOlderMessagesComputed;

  @override
  bool get hasMoreOlderMessages =>
      (_$hasMoreOlderMessagesComputed ??= Computed<bool>(
            () => super.hasMoreOlderMessages,
            name: '_ChatStore.hasMoreOlderMessages',
          ))
          .value;
  Computed<bool>? _$showSuggestedReplyPanelComputed;

  @override
  bool get showSuggestedReplyPanel =>
      (_$showSuggestedReplyPanelComputed ??= Computed<bool>(
            () => super.showSuggestedReplyPanel,
            name: '_ChatStore.showSuggestedReplyPanel',
          ))
          .value;
  Computed<List<Message>>? _$filteredMessagesComputed;

  @override
  List<Message> get filteredMessages =>
      (_$filteredMessagesComputed ??= Computed<List<Message>>(
            () => super.filteredMessages,
            name: '_ChatStore.filteredMessages',
          ))
          .value;

  late final _$currentMessagesAtom = Atom(
    name: '_ChatStore.currentMessages',
    context: context,
  );

  @override
  ObservableList<Message> get currentMessages {
    _$currentMessagesAtom.reportRead();
    return super.currentMessages;
  }

  @override
  set currentMessages(ObservableList<Message> value) {
    _$currentMessagesAtom.reportWrite(value, super.currentMessages, () {
      super.currentMessages = value;
    });
  }

  late final _$currentChatRoomIdAtom = Atom(
    name: '_ChatStore.currentChatRoomId',
    context: context,
  );

  @override
  String? get currentChatRoomId {
    _$currentChatRoomIdAtom.reportRead();
    return super.currentChatRoomId;
  }

  @override
  set currentChatRoomId(String? value) {
    _$currentChatRoomIdAtom.reportWrite(value, super.currentChatRoomId, () {
      super.currentChatRoomId = value;
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

  late final _$isLoadingOlderMessagesAtom = Atom(
    name: '_ChatStore.isLoadingOlderMessages',
    context: context,
  );

  @override
  bool get isLoadingOlderMessages {
    _$isLoadingOlderMessagesAtom.reportRead();
    return super.isLoadingOlderMessages;
  }

  @override
  set isLoadingOlderMessages(bool value) {
    _$isLoadingOlderMessagesAtom.reportWrite(
      value,
      super.isLoadingOlderMessages,
      () {
        super.isLoadingOlderMessages = value;
      },
    );
  }

  late final _$isSendingMessageAtom = Atom(
    name: '_ChatStore.isSendingMessage',
    context: context,
  );

  @override
  bool get isSendingMessage {
    _$isSendingMessageAtom.reportRead();
    return super.isSendingMessage;
  }

  @override
  set isSendingMessage(bool value) {
    _$isSendingMessageAtom.reportWrite(value, super.isSendingMessage, () {
      super.isSendingMessage = value;
    });
  }

  late final _$isSupportTypingAtom = Atom(
    name: '_ChatStore.isSupportTyping',
    context: context,
  );

  @override
  bool get isSupportTyping {
    _$isSupportTypingAtom.reportRead();
    return super.isSupportTyping;
  }

  @override
  set isSupportTyping(bool value) {
    _$isSupportTypingAtom.reportWrite(value, super.isSupportTyping, () {
      super.isSupportTyping = value;
    });
  }

  late final _$typingActorLabelAtom = Atom(
    name: '_ChatStore.typingActorLabel',
    context: context,
  );

  @override
  String? get typingActorLabel {
    _$typingActorLabelAtom.reportRead();
    return super.typingActorLabel;
  }

  @override
  set typingActorLabel(String? value) {
    _$typingActorLabelAtom.reportWrite(value, super.typingActorLabel, () {
      super.typingActorLabel = value;
    });
  }

  late final _$suggestedReplyAtom = Atom(
    name: '_ChatStore.suggestedReply',
    context: context,
  );

  @override
  String? get suggestedReply {
    _$suggestedReplyAtom.reportRead();
    return super.suggestedReply;
  }

  @override
  set suggestedReply(String? value) {
    _$suggestedReplyAtom.reportWrite(value, super.suggestedReply, () {
      super.suggestedReply = value;
    });
  }

  late final _$isSuggestedReplyLoadingAtom = Atom(
    name: '_ChatStore.isSuggestedReplyLoading',
    context: context,
  );

  @override
  bool get isSuggestedReplyLoading {
    _$isSuggestedReplyLoadingAtom.reportRead();
    return super.isSuggestedReplyLoading;
  }

  @override
  set isSuggestedReplyLoading(bool value) {
    _$isSuggestedReplyLoadingAtom.reportWrite(
      value,
      super.isSuggestedReplyLoading,
      () {
        super.isSuggestedReplyLoading = value;
      },
    );
  }

  late final _$isSuggestedReplyPanelExpandedAtom = Atom(
    name: '_ChatStore.isSuggestedReplyPanelExpanded',
    context: context,
  );

  @override
  bool get isSuggestedReplyPanelExpanded {
    _$isSuggestedReplyPanelExpandedAtom.reportRead();
    return super.isSuggestedReplyPanelExpanded;
  }

  @override
  set isSuggestedReplyPanelExpanded(bool value) {
    _$isSuggestedReplyPanelExpandedAtom.reportWrite(
      value,
      super.isSuggestedReplyPanelExpanded,
      () {
        super.isSuggestedReplyPanelExpanded = value;
      },
    );
  }

  late final _$activeDraftTaskIdAtom = Atom(
    name: '_ChatStore.activeDraftTaskId',
    context: context,
  );

  @override
  String? get activeDraftTaskId {
    _$activeDraftTaskIdAtom.reportRead();
    return super.activeDraftTaskId;
  }

  @override
  set activeDraftTaskId(String? value) {
    _$activeDraftTaskIdAtom.reportWrite(value, super.activeDraftTaskId, () {
      super.activeDraftTaskId = value;
    });
  }

  late final _$draftErrorAtom = Atom(
    name: '_ChatStore.draftError',
    context: context,
  );

  @override
  String? get draftError {
    _$draftErrorAtom.reportRead();
    return super.draftError;
  }

  @override
  set draftError(String? value) {
    _$draftErrorAtom.reportWrite(value, super.draftError, () {
      super.draftError = value;
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

  late final _$observeRoomAsyncAction = AsyncAction(
    '_ChatStore.observeRoom',
    context: context,
  );

  @override
  Future<void> observeRoom(
    String roomId, {
    int unreadCount = 0,
    String? ticketId,
    String? channelId,
  }) {
    return _$observeRoomAsyncAction.run(
      () => super.observeRoom(
        roomId,
        unreadCount: unreadCount,
        ticketId: ticketId,
        channelId: channelId,
      ),
    );
  }

  late final _$generateSuggestedReplyAsyncAction = AsyncAction(
    '_ChatStore.generateSuggestedReply',
    context: context,
  );

  @override
  Future<void> generateSuggestedReply({
    required String chatRoomId,
    String? ticketId,
  }) {
    return _$generateSuggestedReplyAsyncAction.run(
      () => super.generateSuggestedReply(
        chatRoomId: chatRoomId,
        ticketId: ticketId,
      ),
    );
  }

  late final _$regenerateSuggestedReplyAsyncAction = AsyncAction(
    '_ChatStore.regenerateSuggestedReply',
    context: context,
  );

  @override
  Future<void> regenerateSuggestedReply() {
    return _$regenerateSuggestedReplyAsyncAction.run(
      () => super.regenerateSuggestedReply(),
    );
  }

  late final _$prefetchMessagesForRoomsAsyncAction = AsyncAction(
    '_ChatStore.prefetchMessagesForRooms',
    context: context,
  );

  @override
  Future<void> prefetchMessagesForRooms(Iterable<String> roomIds) {
    return _$prefetchMessagesForRoomsAsyncAction.run(
      () => super.prefetchMessagesForRooms(roomIds),
    );
  }

  late final _$loadOlderMessagesAsyncAction = AsyncAction(
    '_ChatStore.loadOlderMessages',
    context: context,
  );

  @override
  Future<void> loadOlderMessages() {
    return _$loadOlderMessagesAsyncAction.run(() => super.loadOlderMessages());
  }

  late final _$sendMessageAsyncAction = AsyncAction(
    '_ChatStore.sendMessage',
    context: context,
  );

  @override
  Future<void> sendMessage(
    String chatRoomId,
    String channelId,
    String contactId,
    String ticketId,
    String text,
    List<Attachment>? attachments, {
    String? replyMessageId,
  }) {
    return _$sendMessageAsyncAction.run(
      () => super.sendMessage(
        chatRoomId,
        channelId,
        contactId,
        ticketId,
        text,
        attachments,
        replyMessageId: replyMessageId,
      ),
    );
  }

  late final _$searchMessagesAsyncAction = AsyncAction(
    '_ChatStore.searchMessages',
    context: context,
  );

  @override
  Future<List<Message>> searchMessages(String keyword) {
    return _$searchMessagesAsyncAction.run(() => super.searchMessages(keyword));
  }

  late final _$reactToMessageAsyncAction = AsyncAction(
    '_ChatStore.reactToMessage',
    context: context,
  );

  @override
  Future<void> reactToMessage({
    required Message message,
    required String reactIcon,
    required String chatRoomId,
    String? channelId,
  }) {
    return _$reactToMessageAsyncAction.run(
      () => super.reactToMessage(
        message: message,
        reactIcon: reactIcon,
        chatRoomId: chatRoomId,
        channelId: channelId,
      ),
    );
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
  void resetAfterTenantSwitch() {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
      name: '_ChatStore.resetAfterTenantSwitch',
    );
    try {
      return super.resetAfterTenantSwitch();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _clearSuggestedReplyState() {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
      name: '_ChatStore._clearSuggestedReplyState',
    );
    try {
      return super._clearSuggestedReplyState();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _onDraftProgress(DraftResponseProgress progress) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
      name: '_ChatStore._onDraftProgress',
    );
    try {
      return super._onDraftProgress(progress);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void dismissSuggestedReply() {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
      name: '_ChatStore.dismissSuggestedReply',
    );
    try {
      return super.dismissSuggestedReply();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleSuggestedReplyPanel() {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
      name: '_ChatStore.toggleSuggestedReplyPanel',
    );
    try {
      return super.toggleSuggestedReplyPanel();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentMessages: ${currentMessages},
currentChatRoomId: ${currentChatRoomId},
isLoading: ${isLoading},
isLoadingOlderMessages: ${isLoadingOlderMessages},
isSendingMessage: ${isSendingMessage},
isSupportTyping: ${isSupportTyping},
typingActorLabel: ${typingActorLabel},
suggestedReply: ${suggestedReply},
isSuggestedReplyLoading: ${isSuggestedReplyLoading},
isSuggestedReplyPanelExpanded: ${isSuggestedReplyPanelExpanded},
activeDraftTaskId: ${activeDraftTaskId},
draftError: ${draftError},
searchQuery: ${searchQuery},
hasMoreOlderMessages: ${hasMoreOlderMessages},
showSuggestedReplyPanel: ${showSuggestedReplyPanel},
filteredMessages: ${filteredMessages}
    ''';
  }
}
