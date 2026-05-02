// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$KnowledgeStore on _KnowledgeStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(
            () => super.isLoading,
            name: '_KnowledgeStore.isLoading',
          ))
          .value;
  Computed<List<KnowledgeSource>>? _$visibleSourcesComputed;

  @override
  List<KnowledgeSource> get visibleSources =>
      (_$visibleSourcesComputed ??= Computed<List<KnowledgeSource>>(
            () => super.visibleSources,
            name: '_KnowledgeStore.visibleSources',
          ))
          .value;
  Computed<bool>? _$hasInFlightSourcesComputed;

  @override
  bool get hasInFlightSources =>
      (_$hasInFlightSourcesComputed ??= Computed<bool>(
            () => super.hasInFlightSources,
            name: '_KnowledgeStore.hasInFlightSources',
          ))
          .value;

  late final _$sourcesAtom = Atom(
    name: '_KnowledgeStore.sources',
    context: context,
  );

  @override
  ObservableList<KnowledgeSource> get sources {
    _$sourcesAtom.reportRead();
    return super.sources;
  }

  @override
  set sources(ObservableList<KnowledgeSource> value) {
    _$sourcesAtom.reportWrite(value, super.sources, () {
      super.sources = value;
    });
  }

  late final _$typeFilterAtom = Atom(
    name: '_KnowledgeStore.typeFilter',
    context: context,
  );

  @override
  KnowledgeSourceType? get typeFilter {
    _$typeFilterAtom.reportRead();
    return super.typeFilter;
  }

  @override
  set typeFilter(KnowledgeSourceType? value) {
    _$typeFilterAtom.reportWrite(value, super.typeFilter, () {
      super.typeFilter = value;
    });
  }

  late final _$loadFutureAtom = Atom(
    name: '_KnowledgeStore.loadFuture',
    context: context,
  );

  @override
  ObservableFuture<void>? get loadFuture {
    _$loadFutureAtom.reportRead();
    return super.loadFuture;
  }

  @override
  set loadFuture(ObservableFuture<void>? value) {
    _$loadFutureAtom.reportWrite(value, super.loadFuture, () {
      super.loadFuture = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_KnowledgeStore.errorMessage',
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

  late final _$tenantMissingAtom = Atom(
    name: '_KnowledgeStore.tenantMissing',
    context: context,
  );

  @override
  bool get tenantMissing {
    _$tenantMissingAtom.reportRead();
    return super.tenantMissing;
  }

  @override
  set tenantMissing(bool value) {
    _$tenantMissingAtom.reportWrite(value, super.tenantMissing, () {
      super.tenantMissing = value;
    });
  }

  late final _$busySourceIdsAtom = Atom(
    name: '_KnowledgeStore.busySourceIds',
    context: context,
  );

  @override
  ObservableSet<String> get busySourceIds {
    _$busySourceIdsAtom.reportRead();
    return super.busySourceIds;
  }

  @override
  set busySourceIds(ObservableSet<String> value) {
    _$busySourceIdsAtom.reportWrite(value, super.busySourceIds, () {
      super.busySourceIds = value;
    });
  }

  late final _$isTestingDbAtom = Atom(
    name: '_KnowledgeStore.isTestingDb',
    context: context,
  );

  @override
  bool get isTestingDb {
    _$isTestingDbAtom.reportRead();
    return super.isTestingDb;
  }

  @override
  set isTestingDb(bool value) {
    _$isTestingDbAtom.reportWrite(value, super.isTestingDb, () {
      super.isTestingDb = value;
    });
  }

  late final _$lastDbPreviewAtom = Atom(
    name: '_KnowledgeStore.lastDbPreview',
    context: context,
  );

  @override
  DatabaseQueryPreview? get lastDbPreview {
    _$lastDbPreviewAtom.reportRead();
    return super.lastDbPreview;
  }

  @override
  set lastDbPreview(DatabaseQueryPreview? value) {
    _$lastDbPreviewAtom.reportWrite(value, super.lastDbPreview, () {
      super.lastDbPreview = value;
    });
  }

  late final _$dbTestErrorAtom = Atom(
    name: '_KnowledgeStore.dbTestError',
    context: context,
  );

  @override
  String? get dbTestError {
    _$dbTestErrorAtom.reportRead();
    return super.dbTestError;
  }

  @override
  set dbTestError(String? value) {
    _$dbTestErrorAtom.reportWrite(value, super.dbTestError, () {
      super.dbTestError = value;
    });
  }

  late final _$uploadProgressAtom = Atom(
    name: '_KnowledgeStore.uploadProgress',
    context: context,
  );

  @override
  double? get uploadProgress {
    _$uploadProgressAtom.reportRead();
    return super.uploadProgress;
  }

  @override
  set uploadProgress(double? value) {
    _$uploadProgressAtom.reportWrite(value, super.uploadProgress, () {
      super.uploadProgress = value;
    });
  }

  late final _$liveStatusModeAtom = Atom(
    name: '_KnowledgeStore.liveStatusMode',
    context: context,
  );

  @override
  LiveStatusMode get liveStatusMode {
    _$liveStatusModeAtom.reportRead();
    return super.liveStatusMode;
  }

  @override
  set liveStatusMode(LiveStatusMode value) {
    _$liveStatusModeAtom.reportWrite(value, super.liveStatusMode, () {
      super.liveStatusMode = value;
    });
  }

  late final _$loadSourcesAsyncAction = AsyncAction(
    '_KnowledgeStore.loadSources',
    context: context,
  );

  @override
  Future<void> loadSources({String? query}) {
    return _$loadSourcesAsyncAction.run(() => super.loadSources(query: query));
  }

  late final _$refreshTenantFromAccountAsyncAction = AsyncAction(
    '_KnowledgeStore.refreshTenantFromAccount',
    context: context,
  );

  @override
  Future<void> refreshTenantFromAccount() {
    return _$refreshTenantFromAccountAsyncAction
        .run(() => super.refreshTenantFromAccount());
  }

  @override
  void setTypeFilter(KnowledgeSourceType? type) {
    final _$actionInfo = _$_KnowledgeStoreActionController.startAction(
      name: '_KnowledgeStore.setTypeFilter',
    );
    try {
      return super.setTypeFilter(type);
    } finally {
      _$_KnowledgeStoreActionController.endAction(_$actionInfo);
    }
  }

  late final _$reindexAsyncAction = AsyncAction(
    '_KnowledgeStore.reindex',
    context: context,
  );

  @override
  Future<void> reindex(String id) {
    return _$reindexAsyncAction.run(() => super.reindex(id));
  }

  late final _$deleteSourceAsyncAction = AsyncAction(
    '_KnowledgeStore.deleteSource',
    context: context,
  );

  @override
  Future<void> deleteSource(String id) {
    return _$deleteSourceAsyncAction.run(() => super.deleteSource(id));
  }

  late final _$updateIntervalAsyncAction = AsyncAction(
    '_KnowledgeStore.updateInterval',
    context: context,
  );

  @override
  Future<void> updateInterval(String id, CrawlInterval interval) {
    return _$updateIntervalAsyncAction.run(
      () => super.updateInterval(id, interval),
    );
  }

  late final _$updateStatusAsyncAction = AsyncAction(
    '_KnowledgeStore.updateStatus',
    context: context,
  );

  @override
  Future<void> updateStatus(String id, KnowledgeSourceStatus status) {
    return _$updateStatusAsyncAction.run(() => super.updateStatus(id, status));
  }

  late final _$updateDatabaseQueryAsyncAction = AsyncAction(
    '_KnowledgeStore.updateDatabaseQuery',
    context: context,
  );

  @override
  Future<void> updateDatabaseQuery({
    required String id,
    required String query,
    required String uri,
  }) {
    return _$updateDatabaseQueryAsyncAction.run(
      () => super.updateDatabaseQuery(id: id, query: query, uri: uri),
    );
  }

  late final _$importWebAsyncAction = AsyncAction(
    '_KnowledgeStore.importWeb',
    context: context,
  );

  @override
  Future<KnowledgeSource?> importWeb({
    required String url,
    required KnowledgeSourceType type,
    required CrawlInterval interval,
  }) {
    return _$importWebAsyncAction.run(
      () => super.importWeb(url: url, type: type, interval: interval),
    );
  }

  late final _$importLocalFileAsyncAction = AsyncAction(
    '_KnowledgeStore.importLocalFile',
    context: context,
  );

  @override
  Future<KnowledgeSource?> importLocalFile({
    required File file,
    required String fileName,
  }) {
    return _$importLocalFileAsyncAction.run(
      () => super.importLocalFile(file: file, fileName: fileName),
    );
  }

  late final _$importGoogleDriveAsyncAction = AsyncAction(
    '_KnowledgeStore.importGoogleDrive',
    context: context,
  );

  @override
  Future<KnowledgeSource?> importGoogleDrive({
    required String name,
    required List<String> includePaths,
    required String customerSupportId,
    required GoogleDriveCredentials credentials,
    required CrawlInterval interval,
  }) {
    return _$importGoogleDriveAsyncAction.run(
      () => super.importGoogleDrive(
        name: name,
        includePaths: includePaths,
        customerSupportId: customerSupportId,
        credentials: credentials,
        interval: interval,
      ),
    );
  }

  late final _$importDatabaseQueryAsyncAction = AsyncAction(
    '_KnowledgeStore.importDatabaseQuery',
    context: context,
  );

  @override
  Future<KnowledgeSource?> importDatabaseQuery({
    required String name,
    required String query,
    required String uri,
    required CrawlInterval interval,
    DatabaseDialect dialect = DatabaseDialect.postgresql,
  }) {
    return _$importDatabaseQueryAsyncAction.run(
      () => super.importDatabaseQuery(
        name: name,
        query: query,
        uri: uri,
        interval: interval,
        dialect: dialect,
      ),
    );
  }

  late final _$testDatabaseQueryAsyncAction = AsyncAction(
    '_KnowledgeStore.testDatabaseQuery',
    context: context,
  );

  @override
  Future<void> testDatabaseQuery({required String query, required String uri}) {
    return _$testDatabaseQueryAsyncAction.run(
      () => super.testDatabaseQuery(query: query, uri: uri),
    );
  }

  late final _$_KnowledgeStoreActionController = ActionController(
    name: '_KnowledgeStore',
    context: context,
  );

  @override
  void resetDbTest() {
    final _$actionInfo = _$_KnowledgeStoreActionController.startAction(
      name: '_KnowledgeStore.resetDbTest',
    );
    try {
      return super.resetDbTest();
    } finally {
      _$_KnowledgeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startLiveStatus() {
    final _$actionInfo = _$_KnowledgeStoreActionController.startAction(
      name: '_KnowledgeStore.startLiveStatus',
    );
    try {
      return super.startLiveStatus();
    } finally {
      _$_KnowledgeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void stopLiveStatus() {
    final _$actionInfo = _$_KnowledgeStoreActionController.startAction(
      name: '_KnowledgeStore.stopLiveStatus',
    );
    try {
      return super.stopLiveStatus();
    } finally {
      _$_KnowledgeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
sources: ${sources},
tenantMissing: ${tenantMissing},
typeFilter: ${typeFilter},
loadFuture: ${loadFuture},
errorMessage: ${errorMessage},
busySourceIds: ${busySourceIds},
isTestingDb: ${isTestingDb},
lastDbPreview: ${lastDbPreview},
dbTestError: ${dbTestError},
uploadProgress: ${uploadProgress},
liveStatusMode: ${liveStatusMode},
isLoading: ${isLoading},
visibleSources: ${visibleSources},
hasInFlightSources: ${hasInFlightSources}
    ''';
  }
}
