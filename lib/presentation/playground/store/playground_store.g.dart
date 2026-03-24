// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playground_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlaygroundStore on _PlaygroundStore, Store {
  Computed<bool>? _$isLoadingSessionsComputed;

  @override
  bool get isLoadingSessions =>
      (_$isLoadingSessionsComputed ??= Computed<bool>(
            () => super.isLoadingSessions,
            name: '_PlaygroundStore.isLoadingSessions',
          ))
          .value;
  Computed<List<PlaygroundMessage>>? _$messagesComputed;

  @override
  List<PlaygroundMessage> get messages =>
      (_$messagesComputed ??= Computed<List<PlaygroundMessage>>(
            () => super.messages,
            name: '_PlaygroundStore.messages',
          ))
          .value;

  late final _$fetchSessionsFutureAtom = Atom(
    name: '_PlaygroundStore.fetchSessionsFuture',
    context: context,
  );

  @override
  ObservableFuture<List<PlaygroundSession>?> get fetchSessionsFuture {
    _$fetchSessionsFutureAtom.reportRead();
    return super.fetchSessionsFuture;
  }

  @override
  set fetchSessionsFuture(ObservableFuture<List<PlaygroundSession>?> value) {
    _$fetchSessionsFutureAtom.reportWrite(value, super.fetchSessionsFuture, () {
      super.fetchSessionsFuture = value;
    });
  }

  late final _$sessionsAtom = Atom(
    name: '_PlaygroundStore.sessions',
    context: context,
  );

  @override
  ObservableList<PlaygroundSession> get sessions {
    _$sessionsAtom.reportRead();
    return super.sessions;
  }

  @override
  set sessions(ObservableList<PlaygroundSession> value) {
    _$sessionsAtom.reportWrite(value, super.sessions, () {
      super.sessions = value;
    });
  }

  late final _$activeSessionAtom = Atom(
    name: '_PlaygroundStore.activeSession',
    context: context,
  );

  @override
  PlaygroundSession? get activeSession {
    _$activeSessionAtom.reportRead();
    return super.activeSession;
  }

  @override
  set activeSession(PlaygroundSession? value) {
    _$activeSessionAtom.reportWrite(value, super.activeSession, () {
      super.activeSession = value;
    });
  }

  late final _$isStreamingAtom = Atom(
    name: '_PlaygroundStore.isStreaming',
    context: context,
  );

  @override
  bool get isStreaming {
    _$isStreamingAtom.reportRead();
    return super.isStreaming;
  }

  @override
  set isStreaming(bool value) {
    _$isStreamingAtom.reportWrite(value, super.isStreaming, () {
      super.isStreaming = value;
    });
  }

  late final _$fetchSessionsAsyncAction = AsyncAction(
    '_PlaygroundStore.fetchSessions',
    context: context,
  );

  @override
  Future<void> fetchSessions() {
    return _$fetchSessionsAsyncAction.run(() => super.fetchSessions());
  }

  late final _$createSessionAsyncAction = AsyncAction(
    '_PlaygroundStore.createSession',
    context: context,
  );

  @override
  Future<void> createSession(
    PlaygroundContextType contextType,
    String? agentId,
  ) {
    return _$createSessionAsyncAction.run(
      () => super.createSession(contextType, agentId),
    );
  }

  late final _$sendMessageAsyncAction = AsyncAction(
    '_PlaygroundStore.sendMessage',
    context: context,
  );

  @override
  Future<void> sendMessage(
    String content, {
    List<String> attachments = const [],
  }) {
    return _$sendMessageAsyncAction.run(
      () => super.sendMessage(content, attachments: attachments),
    );
  }

  late final _$_PlaygroundStoreActionController = ActionController(
    name: '_PlaygroundStore',
    context: context,
  );

  @override
  void openSession(PlaygroundSession session) {
    final _$actionInfo = _$_PlaygroundStoreActionController.startAction(
      name: '_PlaygroundStore.openSession',
    );
    try {
      return super.openSession(session);
    } finally {
      _$_PlaygroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void openSessionById(String sessionId) {
    final _$actionInfo = _$_PlaygroundStoreActionController.startAction(
      name: '_PlaygroundStore.openSessionById',
    );
    try {
      return super.openSessionById(sessionId);
    } finally {
      _$_PlaygroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editMessage(String messageId, String newContent) {
    final _$actionInfo = _$_PlaygroundStoreActionController.startAction(
      name: '_PlaygroundStore.editMessage',
    );
    try {
      return super.editMessage(messageId, newContent);
    } finally {
      _$_PlaygroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeSession() {
    final _$actionInfo = _$_PlaygroundStoreActionController.startAction(
      name: '_PlaygroundStore.closeSession',
    );
    try {
      return super.closeSession();
    } finally {
      _$_PlaygroundStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchSessionsFuture: ${fetchSessionsFuture},
sessions: ${sessions},
activeSession: ${activeSession},
isStreaming: ${isStreaming},
isLoadingSessions: ${isLoadingSessions},
messages: ${messages}
    ''';
  }
}
