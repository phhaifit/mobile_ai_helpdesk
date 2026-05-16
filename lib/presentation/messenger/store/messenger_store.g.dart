// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messenger_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MessengerStore on _MessengerStore, Store {
  late final _$pagesAtom = Atom(
    name: '_MessengerStore.pages',
    context: context,
  );

  @override
  ObservableList<MessengerPage> get pages {
    _$pagesAtom.reportRead();
    return super.pages;
  }

  @override
  set pages(ObservableList<MessengerPage> value) {
    _$pagesAtom.reportWrite(value, super.pages, () {
      super.pages = value;
    });
  }

  late final _$selectedPageAtom = Atom(
    name: '_MessengerStore.selectedPage',
    context: context,
  );

  @override
  MessengerPage? get selectedPage {
    _$selectedPageAtom.reportRead();
    return super.selectedPage;
  }

  @override
  set selectedPage(MessengerPage? value) {
    _$selectedPageAtom.reportWrite(value, super.selectedPage, () {
      super.selectedPage = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_MessengerStore.isLoading',
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

  late final _$errorMessageAtom = Atom(
    name: '_MessengerStore.errorMessage',
    context: context,
  );

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$actionSuccessAtom = Atom(
    name: '_MessengerStore.actionSuccess',
    context: context,
  );

  @override
  bool get actionSuccess {
    _$actionSuccessAtom.reportRead();
    return super.actionSuccess;
  }

  @override
  set actionSuccess(bool value) {
    _$actionSuccessAtom.reportWrite(value, super.actionSuccess, () {
      super.actionSuccess = value;
    });
  }

  late final _$fetchPagesAsyncAction = AsyncAction(
    '_MessengerStore.fetchPages',
    context: context,
  );

  @override
  Future<void> fetchPages() {
    return _$fetchPagesAsyncAction.run(() => super.fetchPages());
  }

  late final _$connectPageAsyncAction = AsyncAction(
    '_MessengerStore.connectPage',
    context: context,
  );

  @override
  Future<void> connectPage(String pageId, String accessToken) {
    return _$connectPageAsyncAction.run(
      () => super.connectPage(pageId, accessToken),
    );
  }

  late final _$disconnectPageAsyncAction = AsyncAction(
    '_MessengerStore.disconnectPage',
    context: context,
  );

  @override
  Future<void> disconnectPage(String channelId) {
    return _$disconnectPageAsyncAction.run(
      () => super.disconnectPage(channelId),
    );
  }

  late final _$updatePageConfigAsyncAction = AsyncAction(
    '_MessengerStore.updatePageConfig',
    context: context,
  );

  @override
  Future<void> updatePageConfig({
    required String channelId,
    required bool autoReply,
    required String greeting,
  }) {
    return _$updatePageConfigAsyncAction.run(
      () => super.updatePageConfig(
        channelId: channelId,
        autoReply: autoReply,
        greeting: greeting,
      ),
    );
  }

  late final _$resyncPageAsyncAction = AsyncAction(
    '_MessengerStore.resyncPage',
    context: context,
  );

  @override
  Future<void> resyncPage(String channelId) {
    return _$resyncPageAsyncAction.run(() => super.resyncPage(channelId));
  }

  late final _$_MessengerStoreActionController = ActionController(
    name: '_MessengerStore',
    context: context,
  );

  @override
  void selectPage(MessengerPage page) {
    final _$actionInfo = _$_MessengerStoreActionController.startAction(
      name: '_MessengerStore.selectPage',
    );
    try {
      return super.selectPage(page);
    } finally {
      _$_MessengerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pages: ${pages},
selectedPage: ${selectedPage},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
actionSuccess: ${actionSuccess}
    ''';
  }
}
