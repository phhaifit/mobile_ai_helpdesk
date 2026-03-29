// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CustomerStore on _CustomerStore, Store {
  late final _$isLoadingAtom = Atom(
    name: '_CustomerStore.isLoading',
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

  late final _$isSavingAtom = Atom(
    name: '_CustomerStore.isSaving',
    context: context,
  );

  @override
  bool get isSaving {
    _$isSavingAtom.reportRead();
    return super.isSaving;
  }

  @override
  set isSaving(bool value) {
    _$isSavingAtom.reportWrite(value, super.isSaving, () {
      super.isSaving = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_CustomerStore.errorMessage',
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

  late final _$customersAtom = Atom(
    name: '_CustomerStore.customers',
    context: context,
  );

  @override
  ObservableList<Customer> get customers {
    _$customersAtom.reportRead();
    return super.customers;
  }

  @override
  set customers(ObservableList<Customer> value) {
    _$customersAtom.reportWrite(value, super.customers, () {
      super.customers = value;
    });
  }

  late final _$availableTagsAtom = Atom(
    name: '_CustomerStore.availableTags',
    context: context,
  );

  @override
  ObservableList<Tag> get availableTags {
    _$availableTagsAtom.reportRead();
    return super.availableTags;
  }

  @override
  set availableTags(ObservableList<Tag> value) {
    _$availableTagsAtom.reportWrite(value, super.availableTags, () {
      super.availableTags = value;
    });
  }

  late final _$searchQueryAtom = Atom(
    name: '_CustomerStore.searchQuery',
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

  late final _$selectedTagIdsAtom = Atom(
    name: '_CustomerStore.selectedTagIds',
    context: context,
  );

  @override
  ObservableList<String> get selectedTagIds {
    _$selectedTagIdsAtom.reportRead();
    return super.selectedTagIds;
  }

  @override
  set selectedTagIds(ObservableList<String> value) {
    _$selectedTagIdsAtom.reportWrite(value, super.selectedTagIds, () {
      super.selectedTagIds = value;
    });
  }

  late final _$_initAsyncAction = AsyncAction(
    '_CustomerStore._init',
    context: context,
  );

  @override
  Future<void> _init() {
    return _$_initAsyncAction.run(() => super._init());
  }

  late final _$loadCustomersAsyncAction = AsyncAction(
    '_CustomerStore.loadCustomers',
    context: context,
  );

  @override
  Future<void> loadCustomers() {
    return _$loadCustomersAsyncAction.run(() => super.loadCustomers());
  }

  late final _$saveCustomerAsyncAction = AsyncAction(
    '_CustomerStore.saveCustomer',
    context: context,
  );

  @override
  Future<bool> saveCustomer(Customer customer) {
    return _$saveCustomerAsyncAction.run(() => super.saveCustomer(customer));
  }

  late final _$deleteCustomerAsyncAction = AsyncAction(
    '_CustomerStore.deleteCustomer',
    context: context,
  );

  @override
  Future<bool> deleteCustomer(String id) {
    return _$deleteCustomerAsyncAction.run(() => super.deleteCustomer(id));
  }

  late final _$mergeCustomersAsyncAction = AsyncAction(
    '_CustomerStore.mergeCustomers',
    context: context,
  );

  @override
  Future<bool> mergeCustomers({
    required String targetId,
    required String sourceId,
  }) {
    return _$mergeCustomersAsyncAction.run(
      () => super.mergeCustomers(targetId: targetId, sourceId: sourceId),
    );
  }

  late final _$createNewTagAsyncAction = AsyncAction(
    '_CustomerStore.createNewTag',
    context: context,
  );

  @override
  Future<Tag?> createNewTag(String name) {
    return _$createNewTagAsyncAction.run(() => super.createNewTag(name));
  }

  late final _$addTagToCustomerAsyncAction = AsyncAction(
    '_CustomerStore.addTagToCustomer',
    context: context,
  );

  @override
  Future<bool> addTagToCustomer(String customerId, String tagId) {
    return _$addTagToCustomerAsyncAction.run(
      () => super.addTagToCustomer(customerId, tagId),
    );
  }

  late final _$removeTagFromCustomerAsyncAction = AsyncAction(
    '_CustomerStore.removeTagFromCustomer',
    context: context,
  );

  @override
  Future<bool> removeTagFromCustomer(String customerId, String tagId) {
    return _$removeTagFromCustomerAsyncAction.run(
      () => super.removeTagFromCustomer(customerId, tagId),
    );
  }

  late final _$updateCustomerContactAsyncAction = AsyncAction(
    '_CustomerStore.updateCustomerContact',
    context: context,
  );

  @override
  Future<bool> updateCustomerContact(
    String customerId, {
    String? email,
    String? phone,
    String? zalo,
    String? messenger,
  }) {
    return _$updateCustomerContactAsyncAction.run(
      () => super.updateCustomerContact(
        customerId,
        email: email,
        phone: phone,
        zalo: zalo,
        messenger: messenger,
      ),
    );
  }

  late final _$removeCustomerContactAsyncAction = AsyncAction(
    '_CustomerStore.removeCustomerContact',
    context: context,
  );

  @override
  Future<bool> removeCustomerContact(
    String customerId, {
    String? email,
    String? phone,
    String? zalo,
    String? messenger,
  }) {
    return _$removeCustomerContactAsyncAction.run(
      () => super.removeCustomerContact(
        customerId,
        email: email,
        phone: phone,
        zalo: zalo,
        messenger: messenger,
      ),
    );
  }

  late final _$_CustomerStoreActionController = ActionController(
    name: '_CustomerStore',
    context: context,
  );

  @override
  void setSearchQuery(String query) {
    final _$actionInfo = _$_CustomerStoreActionController.startAction(
      name: '_CustomerStore.setSearchQuery',
    );
    try {
      return super.setSearchQuery(query);
    } finally {
      _$_CustomerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleTagFilter(String tagId) {
    final _$actionInfo = _$_CustomerStoreActionController.startAction(
      name: '_CustomerStore.toggleTagFilter',
    );
    try {
      return super.toggleTagFilter(tagId);
    } finally {
      _$_CustomerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void applyFilters() {
    final _$actionInfo = _$_CustomerStoreActionController.startAction(
      name: '_CustomerStore.applyFilters',
    );
    try {
      return super.applyFilters();
    } finally {
      _$_CustomerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearFilters() {
    final _$actionInfo = _$_CustomerStoreActionController.startAction(
      name: '_CustomerStore.clearFilters',
    );
    try {
      return super.clearFilters();
    } finally {
      _$_CustomerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isSaving: ${isSaving},
errorMessage: ${errorMessage},
customers: ${customers},
availableTags: ${availableTags},
searchQuery: ${searchQuery},
selectedTagIds: ${selectedTagIds}
    ''';
  }
}
