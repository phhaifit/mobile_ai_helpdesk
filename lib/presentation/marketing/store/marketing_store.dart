import 'dart:async';

import 'package:ai_helpdesk/data/network/realtime/marketing_broadcast_realtime_service.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/campaign_id_params.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/connect_facebook_admin_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/delete_template_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/disconnect_facebook_admin_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/get_campaigns_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/get_marketing_overview_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/get_templates_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/resume_campaign_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/save_template_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/start_campaign_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing/stop_campaign_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/create_broadcast_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_broadcast_recipients_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/update_broadcast_usecase.dart';
import 'package:event_bus/event_bus.dart';
import 'package:mobx/mobx.dart';

part 'marketing_store.g.dart';

class MarketingStore = _MarketingStore with _$MarketingStore;

abstract class _MarketingStore with Store {
  final GetMarketingOverviewUseCase _getMarketingOverviewUseCase;
  final GetTemplatesUseCase _getTemplatesUseCase;
  final SaveTemplateUseCase _saveTemplateUseCase;
  final DeleteTemplateUseCase _deleteTemplateUseCase;
  final GetCampaignsUseCase _getCampaignsUseCase;
  final StartCampaignUseCase _startCampaignUseCase;
  final StopCampaignUseCase _stopCampaignUseCase;
  final ResumeCampaignUseCase _resumeCampaignUseCase;
  final CreateBroadcastUseCase _createBroadcastUseCase;
  final UpdateBroadcastUseCase _updateBroadcastUseCase;
  final GetBroadcastRecipientsUseCase _getBroadcastRecipientsUseCase;
  final ConnectFacebookAdminUseCase _connectFacebookAdminUseCase;
  final DisconnectFacebookAdminUseCase _disconnectFacebookAdminUseCase;
  final MarketingBroadcastRealtimeService _realtimeService;
  final EventBus _eventBus;

  final Set<String> _subscribedCampaignIds = <String>{};
  StreamSubscription<BroadcastStatusRealtimeEvent>? _statusSub;

  _MarketingStore(
    this._getMarketingOverviewUseCase,
    this._getTemplatesUseCase,
    this._saveTemplateUseCase,
    this._deleteTemplateUseCase,
    this._getCampaignsUseCase,
    this._startCampaignUseCase,
    this._stopCampaignUseCase,
    this._resumeCampaignUseCase,
    this._createBroadcastUseCase,
    this._updateBroadcastUseCase,
    this._getBroadcastRecipientsUseCase,
    this._connectFacebookAdminUseCase,
    this._disconnectFacebookAdminUseCase,
    this._realtimeService,
    this._eventBus,
  ) {
    _statusSub = _eventBus.on<BroadcastStatusRealtimeEvent>().listen(
      _onRealtimeEvent,
    );
  }

  // --- Observable state ---
  @observable
  ObservableFuture<MarketingOverview>? fetchOverviewFuture;

  @observable
  ObservableFuture<void>? actionFuture;

  @observable
  MarketingOverview? overview;

  @observable
  ObservableList<BroadcastCampaign> campaigns = ObservableList();

  @observable
  ObservableList<MarketingTemplate> templates = ObservableList();

  @observable
  BroadcastCampaign? selectedCampaign;

  @observable
  MarketingTemplate? selectedTemplate;

  // Draft state for campaign creation
  @observable
  String draftCampaignName = '';

  @observable
  String draftTemplateId = '';

  @observable
  CampaignChannel draftChannel = CampaignChannel.messenger;

  @observable
  DateTime? draftScheduledAt;

  @observable
  RecipientFilterType draftFilterType = RecipientFilterType.all;

  @observable
  ObservableList<String> draftTagValues = ObservableList();

  @observable
  String draftSegmentValue = '';

  @observable
  CampaignChannel? draftChannelFilter;

  @observable
  String draftBroadcastId = '';

  @observable
  int draftAudienceTotal = 0;

  @observable
  ObservableList<BroadcastRecipient> draftAudienceSample = ObservableList();

  // Draft state for template creation/editing
  @observable
  String draftTemplateName = '';

  @observable
  String draftTemplateContent = '';

  @observable
  TemplateCategory draftTemplateCategory = TemplateCategory.promotional;

  @observable
  CampaignChannel draftTemplateChannel = CampaignChannel.messenger;

  // Search/filter for template library
  @observable
  String templateSearchQuery = '';

  @observable
  TemplateCategory? templateFilterCategory;

  // Feedback
  @observable
  String? actionMessageKey;

  @observable
  bool actionWasSuccess = true;

  @observable
  String? errorMessage;

  // Facebook admin
  @observable
  FacebookAdminState facebookAdmin = const FacebookAdminState(
    status: FacebookAdminStatus.notConnected,
  );

  @observable
  String facebookAccessTokenDraft = '';

  // --- Computed ---
  @computed
  bool get isLoadingOverview =>
      fetchOverviewFuture?.status == FutureStatus.pending;

  @computed
  bool get isSubmitting => actionFuture?.status == FutureStatus.pending;

  @computed
  List<MarketingTemplate> get filteredTemplates =>
      templates.where((t) {
        final matchesSearch =
            templateSearchQuery.isEmpty ||
            t.name.toLowerCase().contains(templateSearchQuery.toLowerCase());
        final matchesCategory =
            templateFilterCategory == null ||
            t.category == templateFilterCategory;
        return matchesSearch && matchesCategory;
      }).toList();

  @computed
  int get runningCampaignCount =>
      campaigns.where((c) => c.status == CampaignStatus.running).length;

  @computed
  int get totalSentCount => campaigns.fold(0, (sum, c) => sum + c.sentCount);

  // --- Actions: fetch ---
  @action
  Future<void> fetchOverview() async {
    errorMessage = null;
    final future = ObservableFuture(
      _getMarketingOverviewUseCase.call(params: null),
    );
    fetchOverviewFuture = future;
    try {
      overview = await future;
      campaigns
        ..clear()
        ..addAll(overview!.campaigns);
      templates
        ..clear()
        ..addAll(overview!.templates);
      facebookAdmin = overview!.facebookAdmin;
      await _syncRealtimeSubscriptions();
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> fetchCampaigns() async {
    errorMessage = null;
    final future = ObservableFuture(_getCampaignsUseCase.call(params: null));
    actionFuture = future;
    try {
      final result = await future;
      campaigns
        ..clear()
        ..addAll(result);
      await _syncRealtimeSubscriptions();
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> fetchTemplates() async {
    errorMessage = null;
    final future = ObservableFuture(_getTemplatesUseCase.call(params: null));
    actionFuture = future;
    try {
      final result = await future;
      templates
        ..clear()
        ..addAll(result);
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  // --- Actions: campaign controls ---
  @action
  Future<void> startCampaign(String id) async {
    errorMessage = null;
    final future = ObservableFuture(
      _startCampaignUseCase.call(params: CampaignIdParams(id: id)),
    );
    actionFuture = future;
    try {
      final result = await future;
      _updateCampaignStatus(result.campaignId, result.newStatus);
      actionMessageKey = result.messageKey;
      actionWasSuccess = result.isSuccess;
    } catch (e) {
      errorMessage = e.toString();
      actionWasSuccess = false;
    }
  }

  @action
  Future<void> stopCampaign(String id) async {
    errorMessage = null;
    final future = ObservableFuture(
      _stopCampaignUseCase.call(params: CampaignIdParams(id: id)),
    );
    actionFuture = future;
    try {
      final result = await future;
      _updateCampaignStatus(result.campaignId, result.newStatus);
      actionMessageKey = result.messageKey;
      actionWasSuccess = result.isSuccess;
    } catch (e) {
      errorMessage = e.toString();
      actionWasSuccess = false;
    }
  }

  @action
  Future<void> resumeCampaign(String id) async {
    errorMessage = null;
    final future = ObservableFuture(
      _resumeCampaignUseCase.call(params: CampaignIdParams(id: id)),
    );
    actionFuture = future;
    try {
      final result = await future;
      _updateCampaignStatus(result.campaignId, result.newStatus);
      actionMessageKey = result.messageKey;
      actionWasSuccess = result.isSuccess;
    } catch (e) {
      errorMessage = e.toString();
      actionWasSuccess = false;
    }
  }

  void _updateCampaignStatus(String id, CampaignStatus status) {
    final index = campaigns.indexWhere((c) => c.id == id);
    if (index >= 0) {
      campaigns[index] = campaigns[index].copyWith(status: status);
      if (selectedCampaign?.id == id) {
        selectedCampaign = campaigns[index];
      }
      unawaited(_syncRealtimeSubscriptions());
    }
  }

  // --- Actions: campaign CRUD ---
  @action
  Future<void> createCampaign() async {
    errorMessage = null;
    final upsertData = BroadcastUpsertData(
      name: draftCampaignName,
      templateId: draftTemplateId,
      scheduledAt: draftScheduledAt,
    );

    final Future<BroadcastItem> apiCall;
    if (draftBroadcastId.isNotEmpty) {
      apiCall = _updateBroadcastUseCase.call(
        params: UpdateBroadcastParams(
          broadcastId: draftBroadcastId,
          data: upsertData,
        ),
      );
    } else {
      apiCall = _createBroadcastUseCase.call(
        params: CreateBroadcastParams(data: upsertData),
      );
    }

    final future = ObservableFuture(apiCall);
    actionFuture = future;
    try {
      final result = await future;
      _mergeBroadcastIntoCampaigns(result);
      actionMessageKey = 'marketing_success_campaign_created';
      actionWasSuccess = true;
      await _syncRealtimeSubscriptions();
      clearDraft();
    } catch (e) {
      errorMessage = e.toString();
      actionWasSuccess = false;
    }
  }

  void _mergeBroadcastIntoCampaigns(BroadcastItem item) {
    final mappedStatus = _mapBroadcastItemStatus(item.status);
    final campaign = BroadcastCampaign(
      id: item.id,
      name: item.name,
      templateId: item.templateId,
      status: mappedStatus,
      channel: draftChannel,
      targeting: CampaignRecipientTarget(
        filterType: draftFilterType,
        tagValues: List.from(draftTagValues),
        segmentValue: draftSegmentValue.isEmpty ? null : draftSegmentValue,
        channelFilter: draftChannelFilter,
        estimatedCount: draftAudienceTotal,
      ),
      scheduledAt: item.scheduledAt,
      sentCount: item.sentCount,
      deliveredCount: item.deliveredCount,
      failedCount: item.failedCount,
      createdAt: item.createdAt,
    );
    final index = campaigns.indexWhere((c) => c.id == campaign.id);
    if (index >= 0) {
      campaigns[index] = campaign;
    } else {
      campaigns.add(campaign);
    }
  }

  CampaignStatus _mapBroadcastItemStatus(BroadcastStatus status) {
    switch (status) {
      case BroadcastStatus.draft:
        return CampaignStatus.draft;
      case BroadcastStatus.scheduled:
        return CampaignStatus.scheduled;
      case BroadcastStatus.running:
        return CampaignStatus.running;
      case BroadcastStatus.paused:
        return CampaignStatus.paused;
      case BroadcastStatus.completed:
        return CampaignStatus.completed;
      case BroadcastStatus.failed:
        return CampaignStatus.failed;
    }
  }

  void _onRealtimeEvent(BroadcastStatusRealtimeEvent event) {
    final index = campaigns.indexWhere((c) => c.id == event.campaignId);
    if (index < 0) {
      return;
    }

    final current = campaigns[index];
    final mappedStatus = _mapRealtimeStatus(event.status) ?? current.status;

    final updated = current.copyWith(
      status: mappedStatus,
      sentCount: event.sentCount,
      deliveredCount: event.deliveredCount,
      failedCount: event.failedCount,
    );

    campaigns[index] = updated;
    if (selectedCampaign?.id == event.campaignId) {
      selectedCampaign = updated;
    }

    unawaited(_syncRealtimeSubscriptions());
  }

  CampaignStatus? _mapRealtimeStatus(BroadcastStatus? status) {
    switch (status) {
      case BroadcastStatus.draft:
        return CampaignStatus.draft;
      case BroadcastStatus.scheduled:
        return CampaignStatus.scheduled;
      case BroadcastStatus.running:
        return CampaignStatus.running;
      case BroadcastStatus.paused:
        return CampaignStatus.paused;
      case BroadcastStatus.completed:
        return CampaignStatus.completed;
      case BroadcastStatus.failed:
        return CampaignStatus.failed;
      case null:
        return null;
    }
  }

  bool _shouldTrackRealtime(CampaignStatus status) {
    return status == CampaignStatus.running ||
        status == CampaignStatus.paused ||
        status == CampaignStatus.scheduled;
  }

  Future<void> _syncRealtimeSubscriptions() async {
    final activeIds =
        campaigns
            .where((c) => _shouldTrackRealtime(c.status))
            .map((c) => c.id)
            .where((id) => id.isNotEmpty)
            .toSet();

    final toUnsubscribe = _subscribedCampaignIds.difference(activeIds).toList();
    for (final id in toUnsubscribe) {
      await _realtimeService.unsubscribeCampaign(id);
      _subscribedCampaignIds.remove(id);
    }

    final toSubscribe = activeIds.difference(_subscribedCampaignIds).toList();
    for (final id in toSubscribe) {
      await _realtimeService.subscribeCampaign(id);
      _subscribedCampaignIds.add(id);
    }
  }

  Future<void> dispose() async {
    await _statusSub?.cancel();
    _statusSub = null;

    final campaignIds = _subscribedCampaignIds.toList();
    _subscribedCampaignIds.clear();
    for (final id in campaignIds) {
      await _realtimeService.unsubscribeCampaign(id);
    }
  }

  // --- Actions: template CRUD ---
  @action
  Future<void> saveTemplate() async {
    errorMessage = null;
    // Detect variables from content
    final regex = RegExp(r'\{\{(\w+)\}\}');
    final matches = regex.allMatches(draftTemplateContent);
    final vars = matches.map((m) => m.group(1)!).toSet().toList();

    final template = MarketingTemplate(
      id: selectedTemplate?.id ?? '',
      name: draftTemplateName,
      content: draftTemplateContent,
      category: draftTemplateCategory,
      channel: draftTemplateChannel,
      variableKeys: vars,
      isActive: true,
      createdAt: selectedTemplate?.createdAt ?? DateTime.now(),
    );
    final future = ObservableFuture(
      _saveTemplateUseCase.call(params: SaveTemplateParams(template: template)),
    );
    actionFuture = future;
    try {
      final result = await future;
      if (result.isSuccess && result.template != null) {
        final idx = templates.indexWhere((t) => t.id == result.template!.id);
        if (idx >= 0) {
          templates[idx] = result.template!;
        } else {
          templates.add(result.template!);
        }
      }
      actionMessageKey = result.messageKey;
      actionWasSuccess = result.isSuccess;
    } catch (e) {
      errorMessage = e.toString();
      actionWasSuccess = false;
    }
  }

  @action
  Future<void> deleteTemplate(String id) async {
    errorMessage = null;
    final future = ObservableFuture(
      _deleteTemplateUseCase.call(params: DeleteTemplateParams(id: id)),
    );
    actionFuture = future;
    try {
      final result = await future;
      if (result.isSuccess) {
        templates.removeWhere((t) => t.id == id);
      }
      actionMessageKey = result.messageKey;
      actionWasSuccess = result.isSuccess;
    } catch (e) {
      errorMessage = e.toString();
      actionWasSuccess = false;
    }
  }

  // --- Actions: audience estimation ---
  @action
  Future<void> previewAudience() async {
    errorMessage = null;
    actionFuture = ObservableFuture(_previewAudienceFlow());
    try {
      await actionFuture!;
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<void> _previewAudienceFlow() async {
    if (draftBroadcastId.isEmpty) {
      final draftBroadcast = await _createBroadcastUseCase.call(
        params: CreateBroadcastParams(
          data: BroadcastUpsertData(
            name: draftCampaignName.isEmpty
                ? 'Bản nháp ${DateTime.now().millisecondsSinceEpoch}'
                : draftCampaignName,
            templateId: draftTemplateId,
            scheduledAt: draftScheduledAt,
          ),
        ),
      );
      draftBroadcastId = draftBroadcast.id;
    }

    final filter = BroadcastRecipientsFilter(
      tagValues: List.from(draftTagValues),
      segmentValue: draftSegmentValue.isEmpty ? null : draftSegmentValue,
      channel: draftChannelFilter?.name,
    );

    final page = await _getBroadcastRecipientsUseCase.call(
      params: GetBroadcastRecipientsParams(
        query: BroadcastRecipientsQuery(
          broadcastId: draftBroadcastId,
          filter: filter,
          offset: 0,
          limit: 20,
        ),
      ),
    );

    draftAudienceTotal = page.total;
    draftAudienceSample
      ..clear()
      ..addAll(page.items);
  }

  // --- Actions: Facebook Admin ---
  @action
  Future<void> connectFacebookAdmin() async {
    errorMessage = null;
    final future = ObservableFuture(
      _connectFacebookAdminUseCase.call(
        params: ConnectFacebookAdminParams(
          accessToken: facebookAccessTokenDraft,
        ),
      ),
    );
    actionFuture = future;
    try {
      facebookAdmin = await future;
      actionMessageKey = 'marketing_success_facebook_connected';
      actionWasSuccess = true;
    } catch (e) {
      errorMessage = e.toString();
      actionWasSuccess = false;
    }
  }

  @action
  Future<void> disconnectFacebookAdmin() async {
    errorMessage = null;
    final future = ObservableFuture(
      _disconnectFacebookAdminUseCase.call(params: null),
    );
    actionFuture = future;
    try {
      facebookAdmin = await future;
      actionMessageKey = 'marketing_success_facebook_disconnected';
      actionWasSuccess = true;
    } catch (e) {
      errorMessage = e.toString();
      actionWasSuccess = false;
    }
  }

  // --- Actions: setters ---
  @action
  void setDraftCampaignName(String v) => draftCampaignName = v;

  @action
  void setDraftTemplateId(String v) => draftTemplateId = v;

  @action
  void setDraftChannel(CampaignChannel v) => draftChannel = v;

  @action
  void setDraftScheduledAt(DateTime? v) => draftScheduledAt = v;

  @action
  void setDraftFilterType(RecipientFilterType v) => draftFilterType = v;

  @action
  void setDraftSegmentValue(String v) => draftSegmentValue = v;

  @action
  void setDraftChannelFilter(CampaignChannel? v) => draftChannelFilter = v;

  @action
  void toggleDraftTag(String tag) {
    if (draftTagValues.contains(tag)) {
      draftTagValues.remove(tag);
    } else {
      draftTagValues.add(tag);
    }
  }

  @action
  void setTemplateSearchQuery(String v) => templateSearchQuery = v;

  @action
  void setTemplateFilterCategory(TemplateCategory? v) =>
      templateFilterCategory = v;

  @action
  void setDraftTemplateName(String v) => draftTemplateName = v;

  @action
  void setDraftTemplateContent(String v) => draftTemplateContent = v;

  @action
  void setDraftTemplateCategory(TemplateCategory v) =>
      draftTemplateCategory = v;

  @action
  void setDraftTemplateChannel(CampaignChannel v) => draftTemplateChannel = v;

  @action
  void setFacebookAccessTokenDraft(String v) => facebookAccessTokenDraft = v;

  @action
  void selectCampaign(BroadcastCampaign? c) => selectedCampaign = c;

  @action
  void selectTemplate(MarketingTemplate? t) => selectedTemplate = t;

  @action
  void initDraftFromTemplate(MarketingTemplate? t) {
    selectedTemplate = t;
    draftTemplateName = t?.name ?? '';
    draftTemplateContent = t?.content ?? '';
    draftTemplateCategory = t?.category ?? TemplateCategory.promotional;
    draftTemplateChannel = t?.channel ?? CampaignChannel.messenger;
  }

  @action
  void clearDraft() {
    draftCampaignName = '';
    draftTemplateId = '';
    draftChannel = CampaignChannel.messenger;
    draftScheduledAt = null;
    draftFilterType = RecipientFilterType.all;
    draftTagValues.clear();
    draftSegmentValue = '';
    draftChannelFilter = null;
    draftBroadcastId = '';
    draftAudienceTotal = 0;
    draftAudienceSample.clear();
    draftTemplateName = '';
    draftTemplateContent = '';
    draftTemplateCategory = TemplateCategory.promotional;
    draftTemplateChannel = CampaignChannel.messenger;
    selectedTemplate = null;
  }

  @action
  void clearActionFeedback() {
    actionMessageKey = null;
    errorMessage = null;
  }
}
