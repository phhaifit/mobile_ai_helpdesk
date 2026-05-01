// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PromptStore on _PromptStore, Store {
  Computed<List<ResponseTemplate>>? _$filteredTemplatesComputed;

  @override
  List<ResponseTemplate> get filteredTemplates =>
      (_$filteredTemplatesComputed ??= Computed<List<ResponseTemplate>>(
            () => super.filteredTemplates,
            name: '_PromptStore.filteredTemplates',
          ))
          .value;

  late final _$templatesAtom = Atom(
    name: '_PromptStore.templates',
    context: context,
  );

  @override
  ObservableList<ResponseTemplate> get templates {
    _$templatesAtom.reportRead();
    return super.templates;
  }

  @override
  set templates(ObservableList<ResponseTemplate> value) {
    _$templatesAtom.reportWrite(value, super.templates, () {
      super.templates = value;
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

  late final _$filterAssistantIdAtom = Atom(
    name: '_PromptStore.filterAssistantId',
    context: context,
  );

  @override
  String? get filterAssistantId {
    _$filterAssistantIdAtom.reportRead();
    return super.filterAssistantId;
  }

  @override
  set filterAssistantId(String? value) {
    _$filterAssistantIdAtom.reportWrite(value, super.filterAssistantId, () {
      super.filterAssistantId = value;
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

  late final _$loadTemplatesAsyncAction = AsyncAction(
    '_PromptStore.loadTemplates',
    context: context,
  );

  @override
  Future<void> loadTemplates({String? assistantId}) {
    return _$loadTemplatesAsyncAction.run(
      () => super.loadTemplates(assistantId: assistantId),
    );
  }

  late final _$createTemplateAsyncAction = AsyncAction(
    '_PromptStore.createTemplate',
    context: context,
  );

  @override
  Future<void> createTemplate(CreateResponseTemplateDto dto) {
    return _$createTemplateAsyncAction.run(() => super.createTemplate(dto));
  }

  late final _$updateTemplateAsyncAction = AsyncAction(
    '_PromptStore.updateTemplate',
    context: context,
  );

  @override
  Future<void> updateTemplate(
    String templateId,
    UpdateResponseTemplateDto dto,
  ) {
    return _$updateTemplateAsyncAction.run(
      () => super.updateTemplate(templateId, dto),
    );
  }

  late final _$deleteTemplateAsyncAction = AsyncAction(
    '_PromptStore.deleteTemplate',
    context: context,
  );

  @override
  Future<void> deleteTemplate(String templateId) {
    return _$deleteTemplateAsyncAction.run(
      () => super.deleteTemplate(templateId),
    );
  }

  late final _$toggleActiveAsyncAction = AsyncAction(
    '_PromptStore.toggleActive',
    context: context,
  );

  @override
  Future<void> toggleActive(String templateId) {
    return _$toggleActiveAsyncAction.run(() => super.toggleActive(templateId));
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
  void setFilterAssistantId(String? assistantId) {
    final _$actionInfo = _$_PromptStoreActionController.startAction(
      name: '_PromptStore.setFilterAssistantId',
    );
    try {
      return super.setFilterAssistantId(assistantId);
    } finally {
      _$_PromptStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
templates: ${templates},
searchQuery: ${searchQuery},
filterAssistantId: ${filterAssistantId},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
filteredTemplates: ${filteredTemplates}
    ''';
  }
}
