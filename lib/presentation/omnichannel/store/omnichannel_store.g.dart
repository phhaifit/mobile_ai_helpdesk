// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'omnichannel_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OmnichannelStore on _OmnichannelStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(
            () => super.isLoading,
            name: '_OmnichannelStore.isLoading',
          ))
          .value;

  late final _$fetchFutureAtom = Atom(
    name: '_OmnichannelStore.fetchFuture',
    context: context,
  );

  @override
  ObservableFuture<void> get fetchFuture {
    _$fetchFutureAtom.reportRead();
    return super.fetchFuture;
  }

  @override
  set fetchFuture(ObservableFuture<void> value) {
    _$fetchFutureAtom.reportWrite(value, super.fetchFuture, () {
      super.fetchFuture = value;
    });
  }

  late final _$actionFutureAtom = Atom(
    name: '_OmnichannelStore.actionFuture',
    context: context,
  );

  @override
  ObservableFuture<void> get actionFuture {
    _$actionFutureAtom.reportRead();
    return super.actionFuture;
  }

  @override
  set actionFuture(ObservableFuture<void> value) {
    _$actionFutureAtom.reportWrite(value, super.actionFuture, () {
      super.actionFuture = value;
    });
  }

  late final _$overviewAtom = Atom(
    name: '_OmnichannelStore.overview',
    context: context,
  );

  @override
  OmnichannelOverview? get overview {
    _$overviewAtom.reportRead();
    return super.overview;
  }

  @override
  set overview(OmnichannelOverview? value) {
    _$overviewAtom.reportWrite(value, super.overview, () {
      super.overview = value;
    });
  }

  late final _$actionMessageKeyAtom = Atom(
    name: '_OmnichannelStore.actionMessageKey',
    context: context,
  );

  @override
  String? get actionMessageKey {
    _$actionMessageKeyAtom.reportRead();
    return super.actionMessageKey;
  }

  @override
  set actionMessageKey(String? value) {
    _$actionMessageKeyAtom.reportWrite(value, super.actionMessageKey, () {
      super.actionMessageKey = value;
    });
  }

  late final _$actionWasSuccessAtom = Atom(
    name: '_OmnichannelStore.actionWasSuccess',
    context: context,
  );

  @override
  bool get actionWasSuccess {
    _$actionWasSuccessAtom.reportRead();
    return super.actionWasSuccess;
  }

  @override
  set actionWasSuccess(bool value) {
    _$actionWasSuccessAtom.reportWrite(value, super.actionWasSuccess, () {
      super.actionWasSuccess = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_OmnichannelStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$fetchOverviewAsyncAction = AsyncAction(
    '_OmnichannelStore.fetchOverview',
    context: context,
  );

  @override
  Future<void> fetchOverview() {
    return _$fetchOverviewAsyncAction.run(() => super.fetchOverview());
  }

  late final _$connectMessengerAsyncAction = AsyncAction(
    '_OmnichannelStore.connectMessenger',
    context: context,
  );

  @override
  Future<void> connectMessenger() {
    return _$connectMessengerAsyncAction.run(() => super.connectMessenger());
  }

  late final _$disconnectMessengerAsyncAction = AsyncAction(
    '_OmnichannelStore.disconnectMessenger',
    context: context,
  );

  @override
  Future<void> disconnectMessenger() {
    return _$disconnectMessengerAsyncAction.run(
      () => super.disconnectMessenger(),
    );
  }

  late final _$syncMessengerDataAsyncAction = AsyncAction(
    '_OmnichannelStore.syncMessengerData',
    context: context,
  );

  @override
  Future<void> syncMessengerData() {
    return _$syncMessengerDataAsyncAction.run(() => super.syncMessengerData());
  }

  late final _$updateMessengerSettingsAsyncAction = AsyncAction(
    '_OmnichannelStore.updateMessengerSettings',
    context: context,
  );

  @override
  Future<void> updateMessengerSettings({
    required bool autoReply,
    required String language,
    required String businessHours,
  }) {
    return _$updateMessengerSettingsAsyncAction.run(
      () => super.updateMessengerSettings(
        autoReply: autoReply,
        language: language,
        businessHours: businessHours,
      ),
    );
  }

  late final _$connectZaloFromQrAsyncAction = AsyncAction(
    '_OmnichannelStore.connectZaloFromQr',
    context: context,
  );

  @override
  Future<void> connectZaloFromQr() {
    return _$connectZaloFromQrAsyncAction.run(() => super.connectZaloFromQr());
  }

  late final _$disconnectZaloAsyncAction = AsyncAction(
    '_OmnichannelStore.disconnectZalo',
    context: context,
  );

  @override
  Future<void> disconnectZalo() {
    return _$disconnectZaloAsyncAction.run(() => super.disconnectZalo());
  }

  late final _$retryZaloSyncAsyncAction = AsyncAction(
    '_OmnichannelStore.retryZaloSync',
    context: context,
  );

  @override
  Future<void> retryZaloSync() {
    return _$retryZaloSyncAsyncAction.run(() => super.retryZaloSync());
  }

  late final _$updateZaloAssignmentsAsyncAction = AsyncAction(
    '_OmnichannelStore.updateZaloAssignments',
    context: context,
  );

  @override
  Future<void> updateZaloAssignments(List<ZaloAssignmentUpdate> updates) {
    return _$updateZaloAssignmentsAsyncAction.run(
      () => super.updateZaloAssignments(updates),
    );
  }

  late final _$_OmnichannelStoreActionController = ActionController(
    name: '_OmnichannelStore',
    context: context,
  );

  @override
  void clearActionMessage() {
    final _$actionInfo = _$_OmnichannelStoreActionController.startAction(
      name: '_OmnichannelStore.clearActionMessage',
    );
    try {
      return super.clearActionMessage();
    } finally {
      _$_OmnichannelStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchFuture: ${fetchFuture},
actionFuture: ${actionFuture},
overview: ${overview},
actionMessageKey: ${actionMessageKey},
actionWasSuccess: ${actionWasSuccess},
errorMessage: ${errorMessage},
isLoading: ${isLoading}
    ''';
  }
}
