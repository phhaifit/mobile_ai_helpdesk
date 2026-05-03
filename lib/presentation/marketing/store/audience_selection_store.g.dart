// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audience_selection_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AudienceSelectionStore on _AudienceSelectionStoreBase, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(
            () => super.isLoading,
            name: '_AudienceSelectionStoreBase.isLoading',
          ))
          .value;
  Computed<int>? _$recipientCountComputed;

  @override
  int get recipientCount =>
      (_$recipientCountComputed ??= Computed<int>(
            () => super.recipientCount,
            name: '_AudienceSelectionStoreBase.recipientCount',
          ))
          .value;
  Computed<bool>? _$hasRecipientsComputed;

  @override
  bool get hasRecipients =>
      (_$hasRecipientsComputed ??= Computed<bool>(
            () => super.hasRecipients,
            name: '_AudienceSelectionStoreBase.hasRecipients',
          ))
          .value;
  Computed<bool>? _$canProceedWithCampaignComputed;

  @override
  bool get canProceedWithCampaign =>
      (_$canProceedWithCampaignComputed ??= Computed<bool>(
            () => super.canProceedWithCampaign,
            name: '_AudienceSelectionStoreBase.canProceedWithCampaign',
          ))
          .value;

  late final _$fetchFutureAtom = Atom(
    name: '_AudienceSelectionStoreBase.fetchFuture',
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

  late final _$recipientsPageAtom = Atom(
    name: '_AudienceSelectionStoreBase.recipientsPage',
    context: context,
  );

  @override
  BroadcastPage<BroadcastRecipient>? get recipientsPage {
    _$recipientsPageAtom.reportRead();
    return super.recipientsPage;
  }

  @override
  set recipientsPage(BroadcastPage<BroadcastRecipient>? value) {
    _$recipientsPageAtom.reportWrite(value, super.recipientsPage, () {
      super.recipientsPage = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_AudienceSelectionStoreBase.errorMessage',
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

  late final _$selectedSegmentValueAtom = Atom(
    name: '_AudienceSelectionStoreBase.selectedSegmentValue',
    context: context,
  );

  @override
  String? get selectedSegmentValue {
    _$selectedSegmentValueAtom.reportRead();
    return super.selectedSegmentValue;
  }

  @override
  set selectedSegmentValue(String? value) {
    _$selectedSegmentValueAtom.reportWrite(
      value,
      super.selectedSegmentValue,
      () {
        super.selectedSegmentValue = value;
      },
    );
  }

  late final _$selectedChannelAtom = Atom(
    name: '_AudienceSelectionStoreBase.selectedChannel',
    context: context,
  );

  @override
  String? get selectedChannel {
    _$selectedChannelAtom.reportRead();
    return super.selectedChannel;
  }

  @override
  set selectedChannel(String? value) {
    _$selectedChannelAtom.reportWrite(value, super.selectedChannel, () {
      super.selectedChannel = value;
    });
  }

  late final _$selectedTagsAtom = Atom(
    name: '_AudienceSelectionStoreBase.selectedTags',
    context: context,
  );

  @override
  ObservableList<String> get selectedTags {
    _$selectedTagsAtom.reportRead();
    return super.selectedTags;
  }

  @override
  set selectedTags(ObservableList<String> value) {
    _$selectedTagsAtom.reportWrite(value, super.selectedTags, () {
      super.selectedTags = value;
    });
  }

  late final _$offsetAtom = Atom(
    name: '_AudienceSelectionStoreBase.offset',
    context: context,
  );

  @override
  int get offset {
    _$offsetAtom.reportRead();
    return super.offset;
  }

  @override
  set offset(int value) {
    _$offsetAtom.reportWrite(value, super.offset, () {
      super.offset = value;
    });
  }

  late final _$limitAtom = Atom(
    name: '_AudienceSelectionStoreBase.limit',
    context: context,
  );

  @override
  int get limit {
    _$limitAtom.reportRead();
    return super.limit;
  }

  @override
  set limit(int value) {
    _$limitAtom.reportWrite(value, super.limit, () {
      super.limit = value;
    });
  }

  late final _$fetchRecipientsAsyncAction = AsyncAction(
    '_AudienceSelectionStoreBase.fetchRecipients',
    context: context,
  );

  @override
  Future<void> fetchRecipients({required String broadcastId}) {
    return _$fetchRecipientsAsyncAction.run(
      () => super.fetchRecipients(broadcastId: broadcastId),
    );
  }

  late final _$nextPageAsyncAction = AsyncAction(
    '_AudienceSelectionStoreBase.nextPage',
    context: context,
  );

  @override
  Future<void> nextPage({required String broadcastId}) {
    return _$nextPageAsyncAction.run(
      () => super.nextPage(broadcastId: broadcastId),
    );
  }

  late final _$previousPageAsyncAction = AsyncAction(
    '_AudienceSelectionStoreBase.previousPage',
    context: context,
  );

  @override
  Future<void> previousPage({required String broadcastId}) {
    return _$previousPageAsyncAction.run(
      () => super.previousPage(broadcastId: broadcastId),
    );
  }

  late final _$_AudienceSelectionStoreBaseActionController = ActionController(
    name: '_AudienceSelectionStoreBase',
    context: context,
  );

  @override
  void setSegmentValue(String? value) {
    final _$actionInfo = _$_AudienceSelectionStoreBaseActionController
        .startAction(name: '_AudienceSelectionStoreBase.setSegmentValue');
    try {
      return super.setSegmentValue(value);
    } finally {
      _$_AudienceSelectionStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setChannel(String? value) {
    final _$actionInfo = _$_AudienceSelectionStoreBaseActionController
        .startAction(name: '_AudienceSelectionStoreBase.setChannel');
    try {
      return super.setChannel(value);
    } finally {
      _$_AudienceSelectionStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleTag(String tag) {
    final _$actionInfo = _$_AudienceSelectionStoreBaseActionController
        .startAction(name: '_AudienceSelectionStoreBase.toggleTag');
    try {
      return super.toggleTag(tag);
    } finally {
      _$_AudienceSelectionStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearFilters() {
    final _$actionInfo = _$_AudienceSelectionStoreBaseActionController
        .startAction(name: '_AudienceSelectionStoreBase.clearFilters');
    try {
      return super.clearFilters();
    } finally {
      _$_AudienceSelectionStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_AudienceSelectionStoreBaseActionController
        .startAction(name: '_AudienceSelectionStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$_AudienceSelectionStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchFuture: ${fetchFuture},
recipientsPage: ${recipientsPage},
errorMessage: ${errorMessage},
selectedSegmentValue: ${selectedSegmentValue},
selectedChannel: ${selectedChannel},
selectedTags: ${selectedTags},
offset: ${offset},
limit: ${limit},
isLoading: ${isLoading},
recipientCount: ${recipientCount},
hasRecipients: ${hasRecipients},
canProceedWithCampaign: ${canProceedWithCampaign}
    ''';
  }
}
