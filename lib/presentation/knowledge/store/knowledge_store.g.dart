// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$KnowledgeStore on _KnowledgeStore, Store {
  Computed<List<KnowledgeSource>>? _$filteredSourcesComputed;

  @override
  List<KnowledgeSource> get filteredSources =>
      (_$filteredSourcesComputed ??= Computed<List<KnowledgeSource>>(
            () => super.filteredSources,
            name: '_KnowledgeStore.filteredSources',
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

  late final _$apiFilteredSourcesAtom = Atom(
    name: '_KnowledgeStore.apiFilteredSources',
    context: context,
  );

  @override
  ObservableList<KnowledgeSource>? get apiFilteredSources {
    _$apiFilteredSourcesAtom.reportRead();
    return super.apiFilteredSources;
  }

  @override
  set apiFilteredSources(ObservableList<KnowledgeSource>? value) {
    _$apiFilteredSourcesAtom.reportWrite(value, super.apiFilteredSources, () {
      super.apiFilteredSources = value;
    });
  }

  late final _$selectedCategoryAtom = Atom(
    name: '_KnowledgeStore.selectedCategory',
    context: context,
  );

  @override
  String? get selectedCategory {
    _$selectedCategoryAtom.reportRead();
    return super.selectedCategory;
  }

  @override
  set selectedCategory(String? value) {
    _$selectedCategoryAtom.reportWrite(value, super.selectedCategory, () {
      super.selectedCategory = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_KnowledgeStore.isLoading',
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

  late final _$isTestingAtom = Atom(
    name: '_KnowledgeStore.isTesting',
    context: context,
  );

  @override
  bool get isTesting {
    _$isTestingAtom.reportRead();
    return super.isTesting;
  }

  @override
  set isTesting(bool value) {
    _$isTestingAtom.reportWrite(value, super.isTesting, () {
      super.isTesting = value;
    });
  }

  late final _$connectionTestSuccessAtom = Atom(
    name: '_KnowledgeStore.connectionTestSuccess',
    context: context,
  );

  @override
  bool? get connectionTestSuccess {
    _$connectionTestSuccessAtom.reportRead();
    return super.connectionTestSuccess;
  }

  @override
  set connectionTestSuccess(bool? value) {
    _$connectionTestSuccessAtom.reportWrite(
      value,
      super.connectionTestSuccess,
      () {
        super.connectionTestSuccess = value;
      },
    );
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

  late final _$loadSourcesAsyncAction = AsyncAction(
    '_KnowledgeStore.loadSources',
    context: context,
  );

  @override
  Future<void> loadSources() {
    return _$loadSourcesAsyncAction.run(() => super.loadSources());
  }

  late final _$filterByCategoryAsyncAction = AsyncAction(
    '_KnowledgeStore.filterByCategory',
    context: context,
  );

  @override
  Future<void> filterByCategory(String? category) {
    return _$filterByCategoryAsyncAction.run(
      () => super.filterByCategory(category),
    );
  }

  late final _$updateSourceStatusAsyncAction = AsyncAction(
    '_KnowledgeStore.updateSourceStatus',
    context: context,
  );

  @override
  Future<void> updateSourceStatus(String id, KnowledgeSourceStatus status) {
    return _$updateSourceStatusAsyncAction.run(
      () => super.updateSourceStatus(id, status),
    );
  }

  late final _$addSourceAsyncAction = AsyncAction(
    '_KnowledgeStore.addSource',
    context: context,
  );

  @override
  Future<void> addSource(KnowledgeSource source) {
    return _$addSourceAsyncAction.run(() => super.addSource(source));
  }

  late final _$deleteSourceAsyncAction = AsyncAction(
    '_KnowledgeStore.deleteSource',
    context: context,
  );

  @override
  Future<void> deleteSource(String id) {
    return _$deleteSourceAsyncAction.run(() => super.deleteSource(id));
  }

  late final _$reindexSourceAsyncAction = AsyncAction(
    '_KnowledgeStore.reindexSource',
    context: context,
  );

  @override
  Future<void> reindexSource(String id) {
    return _$reindexSourceAsyncAction.run(() => super.reindexSource(id));
  }

  late final _$updateSourceCrawlIntervalAsyncAction = AsyncAction(
    '_KnowledgeStore.updateSourceCrawlInterval',
    context: context,
  );

  @override
  Future<void> updateSourceCrawlInterval(
    String id,
    CrawlInterval crawlInterval,
  ) {
    return _$updateSourceCrawlIntervalAsyncAction.run(
      () => super.updateSourceCrawlInterval(id, crawlInterval),
    );
  }

  late final _$testConnectionAsyncAction = AsyncAction(
    '_KnowledgeStore.testConnection',
    context: context,
  );

  @override
  Future<void> testConnection(Map<String, dynamic> config) {
    return _$testConnectionAsyncAction.run(() => super.testConnection(config));
  }

  late final _$_KnowledgeStoreActionController = ActionController(
    name: '_KnowledgeStore',
    context: context,
  );

  @override
  void resetConnectionTest() {
    final _$actionInfo = _$_KnowledgeStoreActionController.startAction(
      name: '_KnowledgeStore.resetConnectionTest',
    );
    try {
      return super.resetConnectionTest();
    } finally {
      _$_KnowledgeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
sources: ${sources},
apiFilteredSources: ${apiFilteredSources},
selectedCategory: ${selectedCategory},
isLoading: ${isLoading},
isTesting: ${isTesting},
connectionTestSuccess: ${connectionTestSuccess},
errorMessage: ${errorMessage},
filteredSources: ${filteredSources}
    ''';
  }
}
