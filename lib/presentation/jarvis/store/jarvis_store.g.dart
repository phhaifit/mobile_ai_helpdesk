// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jarvis_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$JarvisStore on _JarvisStore, Store {
  late final _$isLoadingAtom = Atom(
    name: '_JarvisStore.isLoading',
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

  late final _$lastResponseAtom = Atom(
    name: '_JarvisStore.lastResponse',
    context: context,
  );

  @override
  JarvisResponse? get lastResponse {
    _$lastResponseAtom.reportRead();
    return super.lastResponse;
  }

  @override
  set lastResponse(JarvisResponse? value) {
    _$lastResponseAtom.reportWrite(value, super.lastResponse, () {
      super.lastResponse = value;
    });
  }

  late final _$requiresConfirmationAtom = Atom(
    name: '_JarvisStore.requiresConfirmation',
    context: context,
  );

  @override
  bool get requiresConfirmation {
    _$requiresConfirmationAtom.reportRead();
    return super.requiresConfirmation;
  }

  @override
  set requiresConfirmation(bool value) {
    _$requiresConfirmationAtom.reportWrite(
      value,
      super.requiresConfirmation,
      () {
        super.requiresConfirmation = value;
      },
    );
  }

  late final _$pendingSessionIdAtom = Atom(
    name: '_JarvisStore.pendingSessionId',
    context: context,
  );

  @override
  String? get pendingSessionId {
    _$pendingSessionIdAtom.reportRead();
    return super.pendingSessionId;
  }

  @override
  set pendingSessionId(String? value) {
    _$pendingSessionIdAtom.reportWrite(value, super.pendingSessionId, () {
      super.pendingSessionId = value;
    });
  }

  late final _$sendMessageAsyncAction = AsyncAction(
    '_JarvisStore.sendMessage',
    context: context,
  );

  @override
  Future<JarvisResponse?> sendMessage({
    required String tenantId,
    required String userId,
    required String userRole,
    required String message,
    List<String> history = const [],
    String? sessionId,
    List<String> imageUrls = const [],
  }) {
    return _$sendMessageAsyncAction.run(
      () => super.sendMessage(
        tenantId: tenantId,
        userId: userId,
        userRole: userRole,
        message: message,
        history: history,
        sessionId: sessionId,
        imageUrls: imageUrls,
      ),
    );
  }

  late final _$confirmHitlAsyncAction = AsyncAction(
    '_JarvisStore.confirmHitl',
    context: context,
  );

  @override
  Future<JarvisResponse?> confirmHitl({
    required String tenantId,
    required String userId,
    required HitlAction action,
    String? language,
  }) {
    return _$confirmHitlAsyncAction.run(
      () => super.confirmHitl(
        tenantId: tenantId,
        userId: userId,
        action: action,
        language: language,
      ),
    );
  }

  late final _$_JarvisStoreActionController = ActionController(
    name: '_JarvisStore',
    context: context,
  );

  @override
  void clearError() {
    final _$actionInfo = _$_JarvisStoreActionController.startAction(
      name: '_JarvisStore.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_JarvisStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
lastResponse: ${lastResponse},
requiresConfirmation: ${requiresConfirmation},
pendingSessionId: ${pendingSessionId}
    ''';
  }
}
