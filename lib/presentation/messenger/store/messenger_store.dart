import 'package:mobx/mobx.dart';

import '/domain/entity/messenger/messenger_page.dart';
import '/domain/usecase/messenger/connect_messenger_page_usecase.dart';
import '/domain/usecase/messenger/disconnect_messenger_page_usecase.dart';
import '/domain/usecase/messenger/get_messenger_pages_usecase.dart';
import '/domain/repository/messenger/messenger_repository.dart';

part 'messenger_store.g.dart';

class MessengerStore = _MessengerStore with _$MessengerStore;

abstract class _MessengerStore with Store {
  _MessengerStore(
    this._getPagesUseCase,
    this._connectPageUseCase,
    this._disconnectPageUseCase,
    this._repository,
  );

  final GetMessengerPagesUseCase _getPagesUseCase;
  final ConnectMessengerPageUseCase _connectPageUseCase;
  final DisconnectMessengerPageUseCase _disconnectPageUseCase;
  final MessengerRepository _repository;

  @observable
  ObservableList<MessengerPage> pages = ObservableList.of([]);

  @observable
  MessengerPage? selectedPage;

  @observable
  bool isLoading = false;

  @observable
  String errorMessage = '';

  @observable
  bool actionSuccess = false;

  @action
  Future<void> fetchPages() async {
    isLoading = true;
    errorMessage = '';
    try {
      final result = await _getPagesUseCase.call(params: null);
      pages = ObservableList.of(result);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  void selectPage(MessengerPage page) {
    selectedPage = page;
  }

  @action
  Future<void> connectPage(String pageId, String accessToken) async {
    isLoading = true;
    errorMessage = '';
    actionSuccess = false;
    try {
      await _connectPageUseCase.call(
        params: ConnectMessengerPageParams(
          pageId: pageId,
          accessToken: accessToken,
        ),
      );
      actionSuccess = true;
      await fetchPages();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> disconnectPage(String channelId) async {
    isLoading = true;
    errorMessage = '';
    actionSuccess = false;
    try {
      await _disconnectPageUseCase.call(params: channelId);
      actionSuccess = true;
      if (selectedPage?.id == channelId) selectedPage = null;
      await fetchPages();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> updatePageConfig({
    required String channelId,
    required bool autoReply,
    required String greeting,
  }) async {
    isLoading = true;
    errorMessage = '';
    actionSuccess = false;
    try {
      await _repository.updatePageConfig(
        channelId: channelId,
        autoReply: autoReply,
        greeting: greeting,
      );
      actionSuccess = true;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> resyncPage(String channelId) async {
    isLoading = true;
    errorMessage = '';
    actionSuccess = false;
    try {
      await _repository.resyncPage(channelId);
      actionSuccess = true;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }
}
