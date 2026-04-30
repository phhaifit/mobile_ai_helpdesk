// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketing_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MarketingStore on _MarketingStore, Store {
  Computed<bool>? _$isLoadingOverviewComputed;

  @override
  bool get isLoadingOverview =>
      (_$isLoadingOverviewComputed ??= Computed<bool>(
            () => super.isLoadingOverview,
            name: '_MarketingStore.isLoadingOverview',
          ))
          .value;
  Computed<bool>? _$isSubmittingComputed;

  @override
  bool get isSubmitting =>
      (_$isSubmittingComputed ??= Computed<bool>(
            () => super.isSubmitting,
            name: '_MarketingStore.isSubmitting',
          ))
          .value;
  Computed<List<MarketingTemplate>>? _$filteredTemplatesComputed;

  @override
  List<MarketingTemplate> get filteredTemplates =>
      (_$filteredTemplatesComputed ??= Computed<List<MarketingTemplate>>(
            () => super.filteredTemplates,
            name: '_MarketingStore.filteredTemplates',
          ))
          .value;
  Computed<int>? _$runningCampaignCountComputed;

  @override
  int get runningCampaignCount =>
      (_$runningCampaignCountComputed ??= Computed<int>(
            () => super.runningCampaignCount,
            name: '_MarketingStore.runningCampaignCount',
          ))
          .value;
  Computed<int>? _$totalSentCountComputed;

  @override
  int get totalSentCount =>
      (_$totalSentCountComputed ??= Computed<int>(
            () => super.totalSentCount,
            name: '_MarketingStore.totalSentCount',
          ))
          .value;

  late final _$fetchOverviewFutureAtom = Atom(
    name: '_MarketingStore.fetchOverviewFuture',
    context: context,
  );

  @override
  ObservableFuture<MarketingOverview>? get fetchOverviewFuture {
    _$fetchOverviewFutureAtom.reportRead();
    return super.fetchOverviewFuture;
  }

  @override
  set fetchOverviewFuture(ObservableFuture<MarketingOverview>? value) {
    _$fetchOverviewFutureAtom.reportWrite(value, super.fetchOverviewFuture, () {
      super.fetchOverviewFuture = value;
    });
  }

  late final _$actionFutureAtom = Atom(
    name: '_MarketingStore.actionFuture',
    context: context,
  );

  @override
  ObservableFuture<void>? get actionFuture {
    _$actionFutureAtom.reportRead();
    return super.actionFuture;
  }

  @override
  set actionFuture(ObservableFuture<void>? value) {
    _$actionFutureAtom.reportWrite(value, super.actionFuture, () {
      super.actionFuture = value;
    });
  }

  late final _$overviewAtom = Atom(
    name: '_MarketingStore.overview',
    context: context,
  );

  @override
  MarketingOverview? get overview {
    _$overviewAtom.reportRead();
    return super.overview;
  }

  @override
  set overview(MarketingOverview? value) {
    _$overviewAtom.reportWrite(value, super.overview, () {
      super.overview = value;
    });
  }

  late final _$campaignsAtom = Atom(
    name: '_MarketingStore.campaigns',
    context: context,
  );

  @override
  ObservableList<BroadcastCampaign> get campaigns {
    _$campaignsAtom.reportRead();
    return super.campaigns;
  }

  @override
  set campaigns(ObservableList<BroadcastCampaign> value) {
    _$campaignsAtom.reportWrite(value, super.campaigns, () {
      super.campaigns = value;
    });
  }

  late final _$templatesAtom = Atom(
    name: '_MarketingStore.templates',
    context: context,
  );

  @override
  ObservableList<MarketingTemplate> get templates {
    _$templatesAtom.reportRead();
    return super.templates;
  }

  @override
  set templates(ObservableList<MarketingTemplate> value) {
    _$templatesAtom.reportWrite(value, super.templates, () {
      super.templates = value;
    });
  }

  late final _$selectedCampaignAtom = Atom(
    name: '_MarketingStore.selectedCampaign',
    context: context,
  );

  @override
  BroadcastCampaign? get selectedCampaign {
    _$selectedCampaignAtom.reportRead();
    return super.selectedCampaign;
  }

  @override
  set selectedCampaign(BroadcastCampaign? value) {
    _$selectedCampaignAtom.reportWrite(value, super.selectedCampaign, () {
      super.selectedCampaign = value;
    });
  }

  late final _$selectedTemplateAtom = Atom(
    name: '_MarketingStore.selectedTemplate',
    context: context,
  );

  @override
  MarketingTemplate? get selectedTemplate {
    _$selectedTemplateAtom.reportRead();
    return super.selectedTemplate;
  }

  @override
  set selectedTemplate(MarketingTemplate? value) {
    _$selectedTemplateAtom.reportWrite(value, super.selectedTemplate, () {
      super.selectedTemplate = value;
    });
  }

  late final _$draftCampaignNameAtom = Atom(
    name: '_MarketingStore.draftCampaignName',
    context: context,
  );

  @override
  String get draftCampaignName {
    _$draftCampaignNameAtom.reportRead();
    return super.draftCampaignName;
  }

  @override
  set draftCampaignName(String value) {
    _$draftCampaignNameAtom.reportWrite(value, super.draftCampaignName, () {
      super.draftCampaignName = value;
    });
  }

  late final _$draftTemplateIdAtom = Atom(
    name: '_MarketingStore.draftTemplateId',
    context: context,
  );

  @override
  String get draftTemplateId {
    _$draftTemplateIdAtom.reportRead();
    return super.draftTemplateId;
  }

  @override
  set draftTemplateId(String value) {
    _$draftTemplateIdAtom.reportWrite(value, super.draftTemplateId, () {
      super.draftTemplateId = value;
    });
  }

  late final _$draftChannelAtom = Atom(
    name: '_MarketingStore.draftChannel',
    context: context,
  );

  @override
  CampaignChannel get draftChannel {
    _$draftChannelAtom.reportRead();
    return super.draftChannel;
  }

  @override
  set draftChannel(CampaignChannel value) {
    _$draftChannelAtom.reportWrite(value, super.draftChannel, () {
      super.draftChannel = value;
    });
  }

  late final _$draftScheduledAtAtom = Atom(
    name: '_MarketingStore.draftScheduledAt',
    context: context,
  );

  @override
  DateTime? get draftScheduledAt {
    _$draftScheduledAtAtom.reportRead();
    return super.draftScheduledAt;
  }

  @override
  set draftScheduledAt(DateTime? value) {
    _$draftScheduledAtAtom.reportWrite(value, super.draftScheduledAt, () {
      super.draftScheduledAt = value;
    });
  }

  late final _$draftFilterTypeAtom = Atom(
    name: '_MarketingStore.draftFilterType',
    context: context,
  );

  @override
  RecipientFilterType get draftFilterType {
    _$draftFilterTypeAtom.reportRead();
    return super.draftFilterType;
  }

  @override
  set draftFilterType(RecipientFilterType value) {
    _$draftFilterTypeAtom.reportWrite(value, super.draftFilterType, () {
      super.draftFilterType = value;
    });
  }

  late final _$draftTagValuesAtom = Atom(
    name: '_MarketingStore.draftTagValues',
    context: context,
  );

  @override
  ObservableList<String> get draftTagValues {
    _$draftTagValuesAtom.reportRead();
    return super.draftTagValues;
  }

  @override
  set draftTagValues(ObservableList<String> value) {
    _$draftTagValuesAtom.reportWrite(value, super.draftTagValues, () {
      super.draftTagValues = value;
    });
  }

  late final _$draftSegmentValueAtom = Atom(
    name: '_MarketingStore.draftSegmentValue',
    context: context,
  );

  @override
  String get draftSegmentValue {
    _$draftSegmentValueAtom.reportRead();
    return super.draftSegmentValue;
  }

  @override
  set draftSegmentValue(String value) {
    _$draftSegmentValueAtom.reportWrite(value, super.draftSegmentValue, () {
      super.draftSegmentValue = value;
    });
  }

  late final _$draftChannelFilterAtom = Atom(
    name: '_MarketingStore.draftChannelFilter',
    context: context,
  );

  @override
  CampaignChannel? get draftChannelFilter {
    _$draftChannelFilterAtom.reportRead();
    return super.draftChannelFilter;
  }

  @override
  set draftChannelFilter(CampaignChannel? value) {
    _$draftChannelFilterAtom.reportWrite(value, super.draftChannelFilter, () {
      super.draftChannelFilter = value;
    });
  }

  late final _$draftBroadcastIdAtom = Atom(
    name: '_MarketingStore.draftBroadcastId',
    context: context,
  );

  @override
  String get draftBroadcastId {
    _$draftBroadcastIdAtom.reportRead();
    return super.draftBroadcastId;
  }

  @override
  set draftBroadcastId(String value) {
    _$draftBroadcastIdAtom.reportWrite(value, super.draftBroadcastId, () {
      super.draftBroadcastId = value;
    });
  }

  late final _$draftAudienceTotalAtom = Atom(
    name: '_MarketingStore.draftAudienceTotal',
    context: context,
  );

  @override
  int get draftAudienceTotal {
    _$draftAudienceTotalAtom.reportRead();
    return super.draftAudienceTotal;
  }

  @override
  set draftAudienceTotal(int value) {
    _$draftAudienceTotalAtom.reportWrite(value, super.draftAudienceTotal, () {
      super.draftAudienceTotal = value;
    });
  }

  late final _$draftAudienceSampleAtom = Atom(
    name: '_MarketingStore.draftAudienceSample',
    context: context,
  );

  @override
  ObservableList<BroadcastRecipient> get draftAudienceSample {
    _$draftAudienceSampleAtom.reportRead();
    return super.draftAudienceSample;
  }

  @override
  set draftAudienceSample(ObservableList<BroadcastRecipient> value) {
    _$draftAudienceSampleAtom.reportWrite(value, super.draftAudienceSample, () {
      super.draftAudienceSample = value;
    });
  }

  late final _$draftTemplateNameAtom = Atom(
    name: '_MarketingStore.draftTemplateName',
    context: context,
  );

  @override
  String get draftTemplateName {
    _$draftTemplateNameAtom.reportRead();
    return super.draftTemplateName;
  }

  @override
  set draftTemplateName(String value) {
    _$draftTemplateNameAtom.reportWrite(value, super.draftTemplateName, () {
      super.draftTemplateName = value;
    });
  }

  late final _$draftTemplateContentAtom = Atom(
    name: '_MarketingStore.draftTemplateContent',
    context: context,
  );

  @override
  String get draftTemplateContent {
    _$draftTemplateContentAtom.reportRead();
    return super.draftTemplateContent;
  }

  @override
  set draftTemplateContent(String value) {
    _$draftTemplateContentAtom.reportWrite(
      value,
      super.draftTemplateContent,
      () {
        super.draftTemplateContent = value;
      },
    );
  }

  late final _$draftTemplateCategoryAtom = Atom(
    name: '_MarketingStore.draftTemplateCategory',
    context: context,
  );

  @override
  TemplateCategory get draftTemplateCategory {
    _$draftTemplateCategoryAtom.reportRead();
    return super.draftTemplateCategory;
  }

  @override
  set draftTemplateCategory(TemplateCategory value) {
    _$draftTemplateCategoryAtom.reportWrite(
      value,
      super.draftTemplateCategory,
      () {
        super.draftTemplateCategory = value;
      },
    );
  }

  late final _$draftTemplateChannelAtom = Atom(
    name: '_MarketingStore.draftTemplateChannel',
    context: context,
  );

  @override
  CampaignChannel get draftTemplateChannel {
    _$draftTemplateChannelAtom.reportRead();
    return super.draftTemplateChannel;
  }

  @override
  set draftTemplateChannel(CampaignChannel value) {
    _$draftTemplateChannelAtom.reportWrite(
      value,
      super.draftTemplateChannel,
      () {
        super.draftTemplateChannel = value;
      },
    );
  }

  late final _$templateSearchQueryAtom = Atom(
    name: '_MarketingStore.templateSearchQuery',
    context: context,
  );

  @override
  String get templateSearchQuery {
    _$templateSearchQueryAtom.reportRead();
    return super.templateSearchQuery;
  }

  @override
  set templateSearchQuery(String value) {
    _$templateSearchQueryAtom.reportWrite(value, super.templateSearchQuery, () {
      super.templateSearchQuery = value;
    });
  }

  late final _$templateFilterCategoryAtom = Atom(
    name: '_MarketingStore.templateFilterCategory',
    context: context,
  );

  @override
  TemplateCategory? get templateFilterCategory {
    _$templateFilterCategoryAtom.reportRead();
    return super.templateFilterCategory;
  }

  @override
  set templateFilterCategory(TemplateCategory? value) {
    _$templateFilterCategoryAtom.reportWrite(
      value,
      super.templateFilterCategory,
      () {
        super.templateFilterCategory = value;
      },
    );
  }

  late final _$actionMessageKeyAtom = Atom(
    name: '_MarketingStore.actionMessageKey',
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
    name: '_MarketingStore.actionWasSuccess',
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
    name: '_MarketingStore.errorMessage',
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

  late final _$facebookAdminAtom = Atom(
    name: '_MarketingStore.facebookAdmin',
    context: context,
  );

  @override
  FacebookAdminState get facebookAdmin {
    _$facebookAdminAtom.reportRead();
    return super.facebookAdmin;
  }

  @override
  set facebookAdmin(FacebookAdminState value) {
    _$facebookAdminAtom.reportWrite(value, super.facebookAdmin, () {
      super.facebookAdmin = value;
    });
  }

  late final _$facebookAccessTokenDraftAtom = Atom(
    name: '_MarketingStore.facebookAccessTokenDraft',
    context: context,
  );

  @override
  String get facebookAccessTokenDraft {
    _$facebookAccessTokenDraftAtom.reportRead();
    return super.facebookAccessTokenDraft;
  }

  @override
  set facebookAccessTokenDraft(String value) {
    _$facebookAccessTokenDraftAtom.reportWrite(
      value,
      super.facebookAccessTokenDraft,
      () {
        super.facebookAccessTokenDraft = value;
      },
    );
  }

  late final _$fetchOverviewAsyncAction = AsyncAction(
    '_MarketingStore.fetchOverview',
    context: context,
  );

  @override
  Future<void> fetchOverview() {
    return _$fetchOverviewAsyncAction.run(() => super.fetchOverview());
  }

  late final _$fetchCampaignsAsyncAction = AsyncAction(
    '_MarketingStore.fetchCampaigns',
    context: context,
  );

  @override
  Future<void> fetchCampaigns() {
    return _$fetchCampaignsAsyncAction.run(() => super.fetchCampaigns());
  }

  late final _$fetchTemplatesAsyncAction = AsyncAction(
    '_MarketingStore.fetchTemplates',
    context: context,
  );

  @override
  Future<void> fetchTemplates() {
    return _$fetchTemplatesAsyncAction.run(() => super.fetchTemplates());
  }

  late final _$startCampaignAsyncAction = AsyncAction(
    '_MarketingStore.startCampaign',
    context: context,
  );

  @override
  Future<void> startCampaign(String id) {
    return _$startCampaignAsyncAction.run(() => super.startCampaign(id));
  }

  late final _$stopCampaignAsyncAction = AsyncAction(
    '_MarketingStore.stopCampaign',
    context: context,
  );

  @override
  Future<void> stopCampaign(String id) {
    return _$stopCampaignAsyncAction.run(() => super.stopCampaign(id));
  }

  late final _$resumeCampaignAsyncAction = AsyncAction(
    '_MarketingStore.resumeCampaign',
    context: context,
  );

  @override
  Future<void> resumeCampaign(String id) {
    return _$resumeCampaignAsyncAction.run(() => super.resumeCampaign(id));
  }

  late final _$createCampaignAsyncAction = AsyncAction(
    '_MarketingStore.createCampaign',
    context: context,
  );

  @override
  Future<void> createCampaign() {
    return _$createCampaignAsyncAction.run(() => super.createCampaign());
  }

  late final _$saveTemplateAsyncAction = AsyncAction(
    '_MarketingStore.saveTemplate',
    context: context,
  );

  @override
  Future<void> saveTemplate() {
    return _$saveTemplateAsyncAction.run(() => super.saveTemplate());
  }

  late final _$deleteTemplateAsyncAction = AsyncAction(
    '_MarketingStore.deleteTemplate',
    context: context,
  );

  @override
  Future<void> deleteTemplate(String id) {
    return _$deleteTemplateAsyncAction.run(() => super.deleteTemplate(id));
  }

  late final _$previewAudienceAsyncAction = AsyncAction(
    '_MarketingStore.previewAudience',
    context: context,
  );

  @override
  Future<void> previewAudience() {
    return _$previewAudienceAsyncAction.run(() => super.previewAudience());
  }

  late final _$connectFacebookAdminAsyncAction = AsyncAction(
    '_MarketingStore.connectFacebookAdmin',
    context: context,
  );

  @override
  Future<void> connectFacebookAdmin() {
    return _$connectFacebookAdminAsyncAction.run(
      () => super.connectFacebookAdmin(),
    );
  }

  late final _$disconnectFacebookAdminAsyncAction = AsyncAction(
    '_MarketingStore.disconnectFacebookAdmin',
    context: context,
  );

  @override
  Future<void> disconnectFacebookAdmin() {
    return _$disconnectFacebookAdminAsyncAction.run(
      () => super.disconnectFacebookAdmin(),
    );
  }

  late final _$_MarketingStoreActionController = ActionController(
    name: '_MarketingStore',
    context: context,
  );

  @override
  void setDraftCampaignName(String v) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.setDraftCampaignName',
    );
    try {
      return super.setDraftCampaignName(v);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDraftTemplateId(String v) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.setDraftTemplateId',
    );
    try {
      return super.setDraftTemplateId(v);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDraftChannel(CampaignChannel v) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.setDraftChannel',
    );
    try {
      return super.setDraftChannel(v);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDraftScheduledAt(DateTime? v) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.setDraftScheduledAt',
    );
    try {
      return super.setDraftScheduledAt(v);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDraftFilterType(RecipientFilterType v) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.setDraftFilterType',
    );
    try {
      return super.setDraftFilterType(v);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDraftSegmentValue(String v) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.setDraftSegmentValue',
    );
    try {
      return super.setDraftSegmentValue(v);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDraftChannelFilter(CampaignChannel? v) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.setDraftChannelFilter',
    );
    try {
      return super.setDraftChannelFilter(v);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleDraftTag(String tag) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.toggleDraftTag',
    );
    try {
      return super.toggleDraftTag(tag);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTemplateSearchQuery(String v) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.setTemplateSearchQuery',
    );
    try {
      return super.setTemplateSearchQuery(v);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTemplateFilterCategory(TemplateCategory? v) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.setTemplateFilterCategory',
    );
    try {
      return super.setTemplateFilterCategory(v);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDraftTemplateName(String v) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.setDraftTemplateName',
    );
    try {
      return super.setDraftTemplateName(v);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDraftTemplateContent(String v) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.setDraftTemplateContent',
    );
    try {
      return super.setDraftTemplateContent(v);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDraftTemplateCategory(TemplateCategory v) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.setDraftTemplateCategory',
    );
    try {
      return super.setDraftTemplateCategory(v);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDraftTemplateChannel(CampaignChannel v) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.setDraftTemplateChannel',
    );
    try {
      return super.setDraftTemplateChannel(v);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFacebookAccessTokenDraft(String v) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.setFacebookAccessTokenDraft',
    );
    try {
      return super.setFacebookAccessTokenDraft(v);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectCampaign(BroadcastCampaign? c) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.selectCampaign',
    );
    try {
      return super.selectCampaign(c);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectTemplate(MarketingTemplate? t) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.selectTemplate',
    );
    try {
      return super.selectTemplate(t);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initDraftFromTemplate(MarketingTemplate? t) {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.initDraftFromTemplate',
    );
    try {
      return super.initDraftFromTemplate(t);
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearDraft() {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.clearDraft',
    );
    try {
      return super.clearDraft();
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearActionFeedback() {
    final _$actionInfo = _$_MarketingStoreActionController.startAction(
      name: '_MarketingStore.clearActionFeedback',
    );
    try {
      return super.clearActionFeedback();
    } finally {
      _$_MarketingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchOverviewFuture: ${fetchOverviewFuture},
actionFuture: ${actionFuture},
overview: ${overview},
campaigns: ${campaigns},
templates: ${templates},
selectedCampaign: ${selectedCampaign},
selectedTemplate: ${selectedTemplate},
draftCampaignName: ${draftCampaignName},
draftTemplateId: ${draftTemplateId},
draftChannel: ${draftChannel},
draftScheduledAt: ${draftScheduledAt},
draftFilterType: ${draftFilterType},
draftTagValues: ${draftTagValues},
draftSegmentValue: ${draftSegmentValue},
draftChannelFilter: ${draftChannelFilter},
draftBroadcastId: ${draftBroadcastId},
draftAudienceTotal: ${draftAudienceTotal},
draftAudienceSample: ${draftAudienceSample},
draftTemplateName: ${draftTemplateName},
draftTemplateContent: ${draftTemplateContent},
draftTemplateCategory: ${draftTemplateCategory},
draftTemplateChannel: ${draftTemplateChannel},
templateSearchQuery: ${templateSearchQuery},
templateFilterCategory: ${templateFilterCategory},
actionMessageKey: ${actionMessageKey},
actionWasSuccess: ${actionWasSuccess},
errorMessage: ${errorMessage},
facebookAdmin: ${facebookAdmin},
facebookAccessTokenDraft: ${facebookAccessTokenDraft},
isLoadingOverview: ${isLoadingOverview},
isSubmitting: ${isSubmitting},
filteredTemplates: ${filteredTemplates},
runningCampaignCount: ${runningCampaignCount},
totalSentCount: ${totalSentCount}
    ''';
  }
}
