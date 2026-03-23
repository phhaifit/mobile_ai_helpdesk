import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/connect_messenger_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/connect_zalo_from_qr_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/disconnect_messenger_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/disconnect_zalo_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/get_omnichannel_overview_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/retry_zalo_sync_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/sync_messenger_data_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/update_messenger_settings_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/update_zalo_assignments_usecase.dart';
import 'package:mobx/mobx.dart';

part 'omnichannel_store.g.dart';

class OmnichannelStore = _OmnichannelStore with _$OmnichannelStore;

abstract class _OmnichannelStore with Store {
  final GetOmnichannelOverviewUseCase _getOverviewUseCase;
  final ConnectMessengerUseCase _connectMessengerUseCase;
  final DisconnectMessengerUseCase _disconnectMessengerUseCase;
  final SyncMessengerDataUseCase _syncMessengerDataUseCase;
  final UpdateMessengerSettingsUseCase _updateMessengerSettingsUseCase;
  final ConnectZaloFromQrUseCase _connectZaloFromQrUseCase;
  final DisconnectZaloUseCase _disconnectZaloUseCase;
  final RetryZaloSyncUseCase _retryZaloSyncUseCase;
  final UpdateZaloAssignmentsUseCase _updateZaloAssignmentsUseCase;

  _OmnichannelStore(
    this._getOverviewUseCase,
    this._connectMessengerUseCase,
    this._disconnectMessengerUseCase,
    this._syncMessengerDataUseCase,
    this._updateMessengerSettingsUseCase,
    this._connectZaloFromQrUseCase,
    this._disconnectZaloUseCase,
    this._retryZaloSyncUseCase,
    this._updateZaloAssignmentsUseCase,
  );

  @observable
  ObservableFuture<void> fetchFuture = ObservableFuture.value(null);

  @observable
  ObservableFuture<void> actionFuture = ObservableFuture.value(null);

  @observable
  OmnichannelOverview? overview;

  @observable
  String? actionMessageKey;

  @observable
  bool actionWasSuccess = true;

  @observable
  String? errorMessage;

  @computed
  bool get isLoading =>
      fetchFuture.status == FutureStatus.pending ||
      actionFuture.status == FutureStatus.pending;

  @action
  Future<void> fetchOverview() async {
    errorMessage = null;
    fetchFuture = ObservableFuture(
      _getOverviewUseCase
          .call(params: null)
          .then((data) {
            overview = data;
          })
          .catchError((_) {
            errorMessage = 'omnichannel_generic_error';
          }),
    );
    await fetchFuture;
  }

  @action
  Future<void> connectMessenger() async {
    await _runAction(() => _connectMessengerUseCase.call(params: null));
  }

  @action
  Future<void> disconnectMessenger() async {
    await _runAction(() => _disconnectMessengerUseCase.call(params: null));
  }

  @action
  Future<void> syncMessengerData() async {
    await _runAction(() => _syncMessengerDataUseCase.call(params: null));
  }

  @action
  Future<void> updateMessengerSettings({
    required bool autoReply,
    required String language,
    required String businessHours,
  }) async {
    await _runAction(
      () => _updateMessengerSettingsUseCase.call(
        params: MessengerSettingsUpdate(
          autoReply: autoReply,
          language: language,
          businessHours: businessHours,
        ),
      ),
    );
  }

  @action
  Future<void> connectZaloFromQr() async {
    await _runAction(() => _connectZaloFromQrUseCase.call(params: null));
  }

  @action
  Future<void> disconnectZalo() async {
    await _runAction(() => _disconnectZaloUseCase.call(params: null));
  }

  @action
  Future<void> retryZaloSync() async {
    await _runAction(() => _retryZaloSyncUseCase.call(params: null));
  }

  @action
  Future<void> updateZaloAssignments(List<ZaloAssignmentUpdate> updates) async {
    await _runAction(() => _updateZaloAssignmentsUseCase.call(params: updates));
  }

  @action
  void clearActionMessage() {
    actionMessageKey = null;
  }

  Future<void> _runAction(Future<ActionFeedback> Function() action) async {
    actionFuture = ObservableFuture(
      action()
          .then((feedback) async {
            actionWasSuccess = feedback.isSuccess;
            actionMessageKey = feedback.messageKey;
            await fetchOverview();
          })
          .catchError((_) {
            actionWasSuccess = false;
            actionMessageKey = 'omnichannel_generic_error';
          }),
    );

    await actionFuture;
  }
}
