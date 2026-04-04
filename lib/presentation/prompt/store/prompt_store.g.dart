// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PromptStore on _PromptStore, Store {
  Computed<List<Prompt>>? _$filteredPromptsComputed;

  @override
  List<Prompt> get filteredPrompts =>
      (_$filteredPromptsComputed ??= Computed<List<Prompt>>(
        () => super.filteredPrompts,
        name: '_PromptStore.filteredPrompts',
      )).value;

  late final _$promptsAtom = Atom(
    name: '_PromptStore.prompts',
    context: context,
  );

  @override
  ObservableList<Prompt> get prompts {
    _$promptsAtom.reportRead();
    return super.prompts;
  }

  @override
  set prompts(ObservableList<Prompt> value) {
    _$promptsAtom.reportWrite(value, super.prompts, () {
      super.prompts = value;
    });
  }

  late final _$searchQueryAtom = Atom(
    name: '_PromptStore.searchQuery',
    context: context,
  );

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$selectedCategoryIdAtom = Atom(
    name: '_PromptStore.selectedCategoryId',
    context: context,
  );

  @override
  String get selectedCategoryId {
    _$selectedCategoryIdAtom.reportRead();
    return super.selectedCategoryId;
  }

  @override
  set selectedCategoryId(String value) {
    _$selectedCategoryIdAtom.reportWrite(value, super.selectedCategoryId, () {
      super.selectedCategoryId = value;
    });
  }

  late final _$favoritesOnlyAtom = Atom(
    name: '_PromptStore.favoritesOnly',
    context: context,
  );

  @override
  bool get favoritesOnly {
    _$favoritesOnlyAtom.reportRead();
    return super.favoritesOnly;
  }

  @override
  set favoritesOnly(bool value) {
    _$favoritesOnlyAtom.reportWrite(value, super.favoritesOnly, () {
      super.favoritesOnly = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_PromptStore.isLoading',
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

  late final _$errorMessageAtom = Atom(
    name: '_PromptStore.errorMessage',
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

  late final _$loadPromptsAsyncAction = AsyncAction(
    '_PromptStore.loadPrompts',
    context: context,
  );

  @override
  Future<void> loadPrompts({bool useNetworkDelay = true}) {
    return _$loadPromptsAsyncAction.run(
      () => super.loadPrompts(useNetworkDelay: useNetworkDelay),
    );
  }

  late final _$toggleFavoriteAsyncAction = AsyncAction(
    '_PromptStore.toggleFavorite',
    context: context,
  );

  @override
  Future<void> toggleFavorite(String promptId) {
    return _$toggleFavoriteAsyncAction.run(
      () => super.toggleFavorite(promptId),
    );
  }

  late final _$upsertPrivatePromptAsyncAction = AsyncAction(
    '_PromptStore.upsertPrivatePrompt',
    context: context,
  );

  @override
  Future<void> upsertPrivatePrompt(Prompt prompt) {
    return _$upsertPrivatePromptAsyncAction.run(
      () => super.upsertPrivatePrompt(prompt),
    );
  }

  late final _$incrementUsageAsyncAction = AsyncAction(
    '_PromptStore.incrementUsage',
    context: context,
  );

  @override
  Future<void> incrementUsage(String promptId) {
    return _$incrementUsageAsyncAction.run(
      () => super.incrementUsage(promptId),
    );
  }

  late final _$_PromptStoreActionController = ActionController(
    name: '_PromptStore',
    context: context,
  );

  @override
  void setSearchQuery(String value) {
    final _$actionInfo = _$_PromptStoreActionController.startAction(
      name: '_PromptStore.setSearchQuery',
    );
    try {
      return super.setSearchQuery(value);
    } finally {
      _$_PromptStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCategoryFilter(String categoryId) {
    final _$actionInfo = _$_PromptStoreActionController.startAction(
      name: '_PromptStore.setCategoryFilter',
    );
    try {
      return super.setCategoryFilter(categoryId);
    } finally {
      _$_PromptStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFavoritesOnly(bool value) {
    final _$actionInfo = _$_PromptStoreActionController.startAction(
      name: '_PromptStore.setFavoritesOnly',
    );
    try {
      return super.setFavoritesOnly(value);
    } finally {
      _$_PromptStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
prompts: ${prompts},
searchQuery: ${searchQuery},
selectedCategoryId: ${selectedCategoryId},
favoritesOnly: ${favoritesOnly},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
filteredPrompts: ${filteredPrompts}
    ''';
  }
}
