import 'dart:async';

import 'package:ai_helpdesk/data/network/realtime/marketing_broadcast_realtime_service.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/create_broadcast_template_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/create_broadcast_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/create_facebook_admin_account_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/delete_broadcast_template_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/delete_broadcast_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/execute_broadcast_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_broadcast_recipients_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_broadcast_templates_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_broadcasts_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_delivery_receipts_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_facebook_admin_accounts_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/resume_broadcast_usecase.dart';
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

  final Observable<String?> _errorMessage = Observable<String?>(null);
  final Observable<String?> _actionMessageKey = Observable<String?>(null);

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
    this._realtimeService,
    this._eventBus,
  ) {
    _statusSub = _eventBus.on<BroadcastStatusRealtimeEvent>().listen(
      _onRealtimeEvent,
    );
  }

  String? get errorMessage => _errorMessage.value;
  String? get actionMessageKey => _actionMessageKey.value;

  bool get isLoading => fetchFuture?.status == FutureStatus.pending;
  bool get isSubmitting => actionFuture?.status == FutureStatus.pending;

  void _setError(String? message) {
    runInAction(() {
      _errorMessage.value = message;
    });
  }

  void _setActionMessage(String? messageKey) {
    runInAction(() {
      _actionMessageKey.value = messageKey;
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
    final future = ObservableFuture(
      call().then((item) {
        _upsertCampaign(item);
        _setActionMessage(messageKey);
      }),
    );
    actionFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));
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
    int offset = 0,
    int limit = 10,
  }) async {
    _setError(null);
    final future = ObservableFuture(
      _getDeliveryReceiptsUseCase
          .call(
            params: GetDeliveryReceiptsParams(
              broadcastId: campaignId,
              query: PaginationQuery(offset: offset, limit: limit),
            ),
          )
          .then((page) {
            receipts
              ..clear()
              ..addAll(page.items);
          }),
    );
    fetchFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));
  }

  Future<void> fetchFacebookAdminAccounts() async {
    _setError(null);
    final future = ObservableFuture(
      _getFacebookAdminAccountsUseCase.call(params: null).then((items) {
        facebookAccounts
          ..clear()
          ..addAll(items);
      }),
    );
    fetchFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));
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
            _setActionMessage('marketing_success_facebook_connected');
          }),
    );
    actionFuture = future;
    await future.catchError((Object e) => _setError(e.toString()));
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
}
