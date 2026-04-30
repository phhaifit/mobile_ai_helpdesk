import 'dart:async';

import 'package:ai_helpdesk/data/network/realtime/marketing_broadcast_realtime_service.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/create_broadcast_template_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/create_broadcast_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/create_facebook_admin_account_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/delete_broadcast_template_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/delete_broadcast_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/disconnect_facebook_admin_account_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/execute_broadcast_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_broadcast_recipients_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_broadcast_templates_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_broadcasts_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_delivery_receipts_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_facebook_admin_accounts_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_facebook_admin_pages_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/reauth_facebook_admin_account_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/resume_broadcast_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/select_facebook_admin_page_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/stop_broadcast_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/update_broadcast_template_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/update_broadcast_usecase.dart';
import 'package:event_bus/event_bus.dart';
import 'package:mobx/mobx.dart';

class MarketingBroadcastStore {
  final GetBroadcastTemplatesUseCase _getBroadcastTemplatesUseCase;
  final CreateBroadcastTemplateUseCase _createBroadcastTemplateUseCase;
  final UpdateBroadcastTemplateUseCase _updateBroadcastTemplateUseCase;
  final DeleteBroadcastTemplateUseCase _deleteBroadcastTemplateUseCase;
  final GetBroadcastsUseCase _getBroadcastsUseCase;
  final CreateBroadcastUseCase _createBroadcastUseCase;
  final UpdateBroadcastUseCase _updateBroadcastUseCase;
  final DeleteBroadcastUseCase _deleteBroadcastUseCase;
  final ExecuteBroadcastUseCase _executeBroadcastUseCase;
  final StopBroadcastUseCase _stopBroadcastUseCase;
  final ResumeBroadcastUseCase _resumeBroadcastUseCase;
  final GetBroadcastRecipientsUseCase _getBroadcastRecipientsUseCase;
  final GetDeliveryReceiptsUseCase _getDeliveryReceiptsUseCase;
  final GetFacebookAdminAccountsUseCase _getFacebookAdminAccountsUseCase;
  final CreateFacebookAdminAccountUseCase _createFacebookAdminAccountUseCase;
  final DisconnectFacebookAdminAccountUseCase
  _disconnectFacebookAdminAccountUseCase;
  final ReauthFacebookAdminAccountUseCase _reauthFacebookAdminAccountUseCase;
  final GetFacebookAdminPagesUseCase _getFacebookAdminPagesUseCase;
  final SelectFacebookAdminPageUseCase _selectFacebookAdminPageUseCase;
  final MarketingBroadcastRealtimeService _realtimeService;
  final EventBus _eventBus;

  StreamSubscription<BroadcastStatusRealtimeEvent>? _statusSub;

  ObservableFuture<void>? fetchFuture;
  ObservableFuture<void>? actionFuture;

  final ObservableList<BroadcastTemplate> templates =
      ObservableList<BroadcastTemplate>();
  final ObservableList<BroadcastItem> campaigns =
      ObservableList<BroadcastItem>();
  final ObservableList<BroadcastRecipient> recipients =
      ObservableList<BroadcastRecipient>();
  final ObservableList<BroadcastDeliveryReceipt> receipts =
      ObservableList<BroadcastDeliveryReceipt>();
  final ObservableList<FacebookAdAccount> facebookAccounts =
      ObservableList<FacebookAdAccount>();
  final ObservableList<FacebookPage> facebookPages =
      ObservableList<FacebookPage>();

  final Observable<String?> _errorMessage = Observable<String?>(null);
  final Observable<String?> _actionMessageKey = Observable<String?>(null);
  final Observable<bool> _actionWasSuccess = Observable<bool>(true);
  final Observable<String?> _selectedFacebookAccountId = Observable<String?>(null);

  // Scoped action spinner: non-null while a lifecycle call is in flight
  final Observable<String?> _activeBroadcastActionId = Observable<String?>(null);

  // Delivery receipts pagination state
  final Observable<bool> _isLoadingReceipts = Observable<bool>(false);
  final Observable<String?> _receiptsError = Observable<String?>(null);
  final Observable<int> _receiptsTotal = Observable<int>(0);
  int _receiptsOffset = 0;
  static const int _receiptsPageSize = 20;

  MarketingBroadcastStore(
    this._getBroadcastTemplatesUseCase,
    this._createBroadcastTemplateUseCase,
    this._updateBroadcastTemplateUseCase,
    this._deleteBroadcastTemplateUseCase,
    this._getBroadcastsUseCase,
    this._createBroadcastUseCase,
    this._updateBroadcastUseCase,
    this._deleteBroadcastUseCase,
    this._executeBroadcastUseCase,
    this._stopBroadcastUseCase,
    this._resumeBroadcastUseCase,
    this._getBroadcastRecipientsUseCase,
    this._getDeliveryReceiptsUseCase,
    this._getFacebookAdminAccountsUseCase,
    this._createFacebookAdminAccountUseCase,
    this._disconnectFacebookAdminAccountUseCase,
    this._reauthFacebookAdminAccountUseCase,
    this._getFacebookAdminPagesUseCase,
    this._selectFacebookAdminPageUseCase,
    this._realtimeService,
    this._eventBus,
  ) {
    _statusSub = _eventBus.on<BroadcastStatusRealtimeEvent>().listen(
      _onRealtimeEvent,
    );
  }

  String? get errorMessage => _errorMessage.value;
  String? get actionMessageKey => _actionMessageKey.value;
  bool get actionWasSuccess => _actionWasSuccess.value;
  String? get selectedFacebookAccountId => _selectedFacebookAccountId.value;
  String? get activeBroadcastActionId => _activeBroadcastActionId.value;
  bool get isLoadingReceipts => _isLoadingReceipts.value;
  String? get receiptsError => _receiptsError.value;
  bool get receiptsHasMore => receipts.length < _receiptsTotal.value;

  FacebookAdAccount? get selectedFacebookAccount {
    final selectedId = _selectedFacebookAccountId.value;
    if (selectedId == null || selectedId.isEmpty) {
      return null;
    }
    for (final account in facebookAccounts) {
      if (account.id == selectedId) {
        return account;
      }
    }
    return null;
  }

  bool get hasValidFacebookIntegration {
    final selected = selectedFacebookAccount;
    if (selected == null) {
      return false;
    }

    final status = selected.status?.toLowerCase();
    final isConnected =
        status == null ||
        status.isEmpty ||
        status == 'connected' ||
        status == 'active';
    final hasPage = (selected.pageId ?? '').trim().isNotEmpty;
    final isNotExpired =
        selected.tokenExpiresAt == null ||
        selected.tokenExpiresAt!.isAfter(DateTime.now());

    return isConnected && hasPage && isNotExpired;
  }

  bool get isLoading => fetchFuture?.status == FutureStatus.pending;
  bool get isSubmitting => actionFuture?.status == FutureStatus.pending;

  void setSelectedFacebookAccount(String? accountId) {
    runInAction(() {
      _selectedFacebookAccountId.value = accountId;
    });
  }

  void _setError(String? message) {
    runInAction(() {
      _errorMessage.value = message;
      if (message != null && message.isNotEmpty) {
        _actionWasSuccess.value = false;
      }
    });
  }

  void _setActionMessage(String? messageKey) {
    runInAction(() {
      _actionMessageKey.value = messageKey;
      _actionWasSuccess.value = true;
    });
  }

  void clearActionFeedback() {
    runInAction(() {
      _actionMessageKey.value = null;
      _errorMessage.value = null;
      _actionWasSuccess.value = true;
    });
  }

  Future<void> fetchTemplates({
    String? search,
    String? category,
    String? channel,
    int offset = 0,
    int limit = 10,
  }) async {
    _setError(null);
    final future = ObservableFuture(
      _getBroadcastTemplatesUseCase
          .call(
            params: GetBroadcastTemplatesParams(
              query: BroadcastTemplateQuery(
                search: search,
                category: category,
                channel: channel,
                offset: offset,
                limit: limit,
              ),
            ),
          )
          .then((page) {
            templates
              ..clear()
              ..addAll(page.items);
          }),
    );
    fetchFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));
  }

  Future<void> saveTemplate({
    required String? templateId,
    required BroadcastTemplateUpsertData data,
  }) async {
    _setError(null);
    final future = ObservableFuture(
      (templateId == null || templateId.isEmpty
              ? _createBroadcastTemplateUseCase.call(
                params: CreateBroadcastTemplateParams(data: data),
              )
              : _updateBroadcastTemplateUseCase.call(
                params: UpdateBroadcastTemplateParams(
                  templateId: templateId,
                  data: data,
                ),
              ))
          .then((item) {
            final index = templates.indexWhere((t) => t.id == item.id);
            if (index >= 0) {
              templates[index] = item;
            } else {
              templates.add(item);
            }
            _setActionMessage('marketing_success_template_saved');
          }),
    );
    actionFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));
  }

  Future<void> deleteTemplate(String templateId) async {
    _setError(null);
    final future = ObservableFuture(
      _deleteBroadcastTemplateUseCase
          .call(params: DeleteBroadcastTemplateParams(templateId: templateId))
          .then((isSuccess) {
            if (isSuccess) {
              templates.removeWhere((t) => t.id == templateId);
              _setActionMessage('marketing_success_template_deleted');
            }
          }),
    );
    actionFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));
  }

  Future<void> fetchCampaigns({
    BroadcastStatus? status,
    int offset = 0,
    int limit = 10,
  }) async {
    _setError(null);
    final future = ObservableFuture(
      _getBroadcastsUseCase
          .call(
            params: GetBroadcastsParams(
              query: BroadcastQuery(
                status: status,
                offset: offset,
                limit: limit,
              ),
            ),
          )
          .then((page) {
            campaigns
              ..clear()
              ..addAll(page.items);
          }),
    );
    fetchFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));
  }

  Future<void> saveCampaign({
    required String? campaignId,
    required BroadcastUpsertData data,
  }) async {
    _setError(null);
    final future = ObservableFuture(
      (campaignId == null || campaignId.isEmpty
              ? _createBroadcastUseCase.call(
                params: CreateBroadcastParams(data: data),
              )
              : _updateBroadcastUseCase.call(
                params: UpdateBroadcastParams(
                  broadcastId: campaignId,
                  data: data,
                ),
              ))
          .then((item) {
            final index = campaigns.indexWhere((c) => c.id == item.id);
            if (index >= 0) {
              campaigns[index] = item;
            } else {
              campaigns.add(item);
            }
            _setActionMessage('marketing_success_campaign_created');
          }),
    );
    actionFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));
  }

  Future<void> deleteCampaign(String campaignId) async {
    _setError(null);
    final future = ObservableFuture(
      _deleteBroadcastUseCase
          .call(params: DeleteBroadcastParams(broadcastId: campaignId))
          .then((isSuccess) {
            if (isSuccess) {
              campaigns.removeWhere((c) => c.id == campaignId);
            }
          }),
    );
    actionFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));
  }

  Future<void> executeCampaign(String campaignId) async {
    if (!hasValidFacebookIntegration) {
      _setError('marketing_error_facebook_not_connected');
      return;
    }

    await _changeCampaignLifecycle(
      campaignId: campaignId,
      messageKey: 'marketing_success_campaign_started',
      call:
          () => _executeBroadcastUseCase.call(
            params: ExecuteBroadcastParams(broadcastId: campaignId),
          ),
    );
  }

  Future<void> stopCampaign(String campaignId) async {
    await _changeCampaignLifecycle(
      campaignId: campaignId,
      messageKey: 'marketing_success_campaign_stopped',
      call:
          () => _stopBroadcastUseCase.call(
            params: StopBroadcastParams(broadcastId: campaignId),
          ),
    );
  }

  Future<void> resumeCampaign(String campaignId) async {
    await _changeCampaignLifecycle(
      campaignId: campaignId,
      messageKey: 'marketing_success_campaign_resumed',
      call:
          () => _resumeBroadcastUseCase.call(
            params: ResumeBroadcastParams(broadcastId: campaignId),
          ),
    );
  }

  Future<void> _changeCampaignLifecycle({
    required String campaignId,
    required String messageKey,
    required Future<BroadcastItem> Function() call,
  }) async {
    _setError(null);
    runInAction(() => _activeBroadcastActionId.value = campaignId);
    final future = ObservableFuture(
      call().then((item) {
        _upsertCampaign(item);
        _setActionMessage(messageKey);
      }),
    );
    actionFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));
    runInAction(() => _activeBroadcastActionId.value = null);
  }

  Future<void> fetchRecipients(
    String campaignId, {
    BroadcastRecipientsFilter filter = const BroadcastRecipientsFilter(),
    int offset = 0,
    int limit = 10,
  }) async {
    _setError(null);
    final future = ObservableFuture(
      _getBroadcastRecipientsUseCase
          .call(
            params: GetBroadcastRecipientsParams(
              query: BroadcastRecipientsQuery(
                broadcastId: campaignId,
                filter: filter,
                offset: offset,
                limit: limit,
              ),
            ),
          )
          .then((page) {
            recipients
              ..clear()
              ..addAll(page.items);
          }),
    );
    fetchFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));
  }

  Future<void> fetchDeliveryReceipts(
    String campaignId, {
    bool loadMore = false,
  }) async {
    if (_isLoadingReceipts.value) return;
    runInAction(() {
      _isLoadingReceipts.value = true;
      _receiptsError.value = null;
      if (!loadMore) {
        _receiptsOffset = 0;
        receipts.clear();
      }
    });
    try {
      final page = await _getDeliveryReceiptsUseCase.call(
        params: GetDeliveryReceiptsParams(
          broadcastId: campaignId,
          query: PaginationQuery(
            offset: _receiptsOffset,
            limit: _receiptsPageSize,
          ),
        ),
      );
      runInAction(() {
        receipts.addAll(page.items);
        _receiptsTotal.value = page.total;
        _receiptsOffset += page.items.length;
      });
    } catch (e) {
      runInAction(() => _receiptsError.value = e.toString());
    } finally {
      runInAction(() => _isLoadingReceipts.value = false);
    }
  }

  Future<void> fetchFacebookAdminAccounts() async {
    _setError(null);
    final future = ObservableFuture(
      _getFacebookAdminAccountsUseCase.call(params: null).then((items) {
        facebookAccounts
          ..clear()
          ..addAll(items);

        final connected = items.where(_isConnectedFacebookAccount).toList();
        final selected =
            connected.isNotEmpty
                ? connected.first
                : (items.isNotEmpty ? items.first : null);
        _selectedFacebookAccountId.value = selected?.id;
      }),
    );
    fetchFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));

    final selectedId = _selectedFacebookAccountId.value;
    if (selectedId != null && selectedId.isNotEmpty) {
      await fetchFacebookAdminPages(selectedId);
    } else {
      runInAction(() {
        facebookPages.clear();
      });
    }
  }

  Future<void> createFacebookAdminAccount(
    FacebookAdminAccountCreateData data,
  ) async {
    _setError(null);
    final future = ObservableFuture(
      _createFacebookAdminAccountUseCase
          .call(params: CreateFacebookAdminAccountParams(data: data))
          .then((created) {
            final index = facebookAccounts.indexWhere(
              (a) => a.id == created.id,
            );
            if (index >= 0) {
              facebookAccounts[index] = created;
            } else {
              facebookAccounts.add(created);
            }
            _selectedFacebookAccountId.value = created.id;
            _setActionMessage('marketing_success_facebook_connected');
          }),
    );
    actionFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));

    final selectedId = _selectedFacebookAccountId.value;
    if (selectedId != null && selectedId.isNotEmpty) {
      await fetchFacebookAdminPages(selectedId);
    }
  }

  Future<void> disconnectFacebookAdminAccount(String accountId) async {
    _setError(null);
    final future = ObservableFuture(
      _disconnectFacebookAdminAccountUseCase
          .call(
            params: DisconnectFacebookAdminAccountParams(accountId: accountId),
          )
          .then((isSuccess) {
            if (!isSuccess) {
              return;
            }

            facebookAccounts.removeWhere((a) => a.id == accountId);
            if (_selectedFacebookAccountId.value == accountId) {
              _selectedFacebookAccountId.value =
                  facebookAccounts.isEmpty ? null : facebookAccounts.first.id;
            }
            _setActionMessage('marketing_success_facebook_disconnected');
          }),
    );
    actionFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));

    final selectedId = _selectedFacebookAccountId.value;
    if (selectedId != null && selectedId.isNotEmpty) {
      await fetchFacebookAdminPages(selectedId);
    } else {
      runInAction(() {
        facebookPages.clear();
      });
    }
  }

  Future<void> reauthFacebookAdminAccount({
    required String accountId,
    required String accessToken,
  }) async {
    _setError(null);
    final future = ObservableFuture(
      _reauthFacebookAdminAccountUseCase
          .call(
            params: ReauthFacebookAdminAccountParams(
              accountId: accountId,
              accessToken: accessToken,
            ),
          )
          .then((account) {
            _upsertFacebookAccount(account);
            _setActionMessage('marketing_success_facebook_connected');
          }),
    );
    actionFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));
    await fetchFacebookAdminPages(accountId);
  }

  Future<void> fetchFacebookAdminPages(String accountId) async {
    _setError(null);
    final future = ObservableFuture(
      _getFacebookAdminPagesUseCase
          .call(params: GetFacebookAdminPagesParams(accountId: accountId))
          .then((items) {
            facebookPages
              ..clear()
              ..addAll(items);
          }),
    );
    fetchFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));
  }

  Future<void> selectFacebookAdminPage({
    required String accountId,
    required String pageId,
  }) async {
    _setError(null);
    final future = ObservableFuture(
      _selectFacebookAdminPageUseCase
          .call(
            params: SelectFacebookAdminPageParams(
              accountId: accountId,
              pageId: pageId,
            ),
          )
          .then((account) {
            _upsertFacebookAccount(account);
            _setActionMessage('marketing_success_facebook_connected');
          }),
    );
    actionFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));
    await fetchFacebookAdminPages(accountId);
  }

  Future<void> startRealtimeStatus(String campaignId) {
    return _realtimeService.subscribeCampaign(campaignId);
  }

  Future<void> stopRealtimeStatus(String campaignId) {
    return _realtimeService.unsubscribeCampaign(campaignId);
  }

  Future<void> dispose() async {
    await _statusSub?.cancel();
    _statusSub = null;
    await _realtimeService.dispose();
  }

  void _onRealtimeEvent(BroadcastStatusRealtimeEvent event) {
    final index = campaigns.indexWhere((item) => item.id == event.campaignId);
    if (index < 0) {
      return;
    }

    final current = campaigns[index];
    final updated = BroadcastItem(
      id: current.id,
      name: current.name,
      templateId: current.templateId,
      status: event.status ?? current.status,
      recipientCount: current.recipientCount,
      sentCount: event.sentCount,
      deliveredCount: event.deliveredCount,
      failedCount: event.failedCount,
      scheduledAt: current.scheduledAt,
      startedAt: current.startedAt,
      completedAt: current.completedAt,
      createdAt: current.createdAt,
    );

    campaigns[index] = updated;
  }

  void _upsertCampaign(BroadcastItem item) {
    final index = campaigns.indexWhere((c) => c.id == item.id);
    if (index >= 0) {
      campaigns[index] = item;
    } else {
      campaigns.add(item);
    }
  }

  void _upsertFacebookAccount(FacebookAdAccount account) {
    final index = facebookAccounts.indexWhere((a) => a.id == account.id);
    if (index >= 0) {
      facebookAccounts[index] = account;
    } else {
      facebookAccounts.add(account);
    }
    _selectedFacebookAccountId.value = account.id;
  }

  bool _isConnectedFacebookAccount(FacebookAdAccount account) {
    final status = account.status?.toLowerCase();
    return status == 'connected' || status == 'active';
  }
}
