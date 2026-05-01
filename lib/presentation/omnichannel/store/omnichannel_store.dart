import 'dart:async';

import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/connect_messenger_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/connect_zalo_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/disconnect_messenger_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/disconnect_zalo_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/generate_zalo_qr_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/get_omnichannel_overview_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/get_zalo_qr_status_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/retry_zalo_sync_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/sync_messenger_data_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/update_messenger_settings_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/update_zalo_assignments_usecase.dart';
import 'package:mobx/mobx.dart';

part 'omnichannel_store.g.dart';

// ignore: library_private_types_in_public_api
class OmnichannelStore = _OmnichannelStore with _$OmnichannelStore;

abstract class _OmnichannelStore with Store {
  final GetOmnichannelOverviewUseCase _getOverviewUseCase;
  final ConnectMessengerUseCase _connectMessengerUseCase;
  final DisconnectMessengerUseCase _disconnectMessengerUseCase;
  final SyncMessengerDataUseCase _syncMessengerDataUseCase;
  final UpdateMessengerSettingsUseCase _updateMessengerSettingsUseCase;
  final DisconnectZaloUseCase _disconnectZaloUseCase;
  final RetryZaloSyncUseCase _retryZaloSyncUseCase;
  final UpdateZaloAssignmentsUseCase _updateZaloAssignmentsUseCase;
  final GenerateZaloQrUseCase _generateZaloQrUseCase;
  final GetZaloQrStatusUseCase _getZaloQrStatusUseCase;
  final ConnectZaloUseCase _connectZaloUseCase;
  String? _pendingMessengerAuthCode;

  _OmnichannelStore(
    this._getOverviewUseCase,
    this._connectMessengerUseCase,
    this._disconnectMessengerUseCase,
    this._syncMessengerDataUseCase,
    this._updateMessengerSettingsUseCase,
    this._disconnectZaloUseCase,
    this._retryZaloSyncUseCase,
    this._updateZaloAssignmentsUseCase,
    this._generateZaloQrUseCase,
    this._getZaloQrStatusUseCase,
    this._connectZaloUseCase,
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

  @observable
  ZaloQr? zaloQr;

  @observable
  ZaloQrStatus? zaloQrStatus;

  Timer? _qrPollingTimer;

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
    final String? authCode = _normalizedAuthCode(_pendingMessengerAuthCode);
    _pendingMessengerAuthCode = null;

    await _runAction(
      () => _connectMessengerUseCase.call(
        params: ConnectMessengerParams(authCode: authCode),
      ),
    );
  }

  set pendingMessengerAuthCode(String? authCode) {
    _pendingMessengerAuthCode = authCode;
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
    required String businessHours,
  }) async {
    await _runAction(
      () => _updateMessengerSettingsUseCase.call(
        params: MessengerSettingsUpdate(
          autoReply: autoReply,
          businessHours: businessHours,
        ),
      ),
    );
  }

  @action
  Future<void> startZaloQrFlow() async {
    _stopQrPolling();
    zaloQr = null;
    zaloQrStatus = null;

    actionFuture = ObservableFuture(
      _generateZaloQrUseCase.call(params: null).then((qr) {
        zaloQr = qr;
        zaloQrStatus = ZaloQrStatus.pending;
        _startQrPolling(qr.code);
      }).catchError((_) {
        actionWasSuccess = false;
        actionMessageKey = 'omnichannel_generic_error';
      }),
    );
    await actionFuture;
  }

  void _startQrPolling(String code) {
    _qrPollingTimer?.cancel();
    _qrPollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final update = await _getZaloQrStatusUseCase.call(params: code);
        zaloQrStatus = update.status;

        if (update.status == ZaloQrStatus.confirmed && update.authCode != null) {
          timer.cancel();
          await _connectZaloWithCode(update.authCode!);
        } else if (update.status == ZaloQrStatus.expired) {
          timer.cancel();
        }
      } catch (_) {
        // Continue polling on transient errors
      }
    });
  }

  void _stopQrPolling() {
    _qrPollingTimer?.cancel();
    _qrPollingTimer = null;
  }

  Future<void> _connectZaloWithCode(String authCode) async {
    await _runAction(() => _connectZaloUseCase.call(params: authCode));
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

  String? _normalizedAuthCode(String? value) {
    final String normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return null;
    }
    return normalized;
  }

  void dispose() {
    _stopQrPolling();
  }
}
