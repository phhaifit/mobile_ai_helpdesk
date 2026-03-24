// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CustomerStore on _CustomerStore, Store {
  Computed<List<Customer>>? _$filteredCustomersComputed;

  @override
  List<Customer> get filteredCustomers =>
      (_$filteredCustomersComputed ??= Computed<List<Customer>>(
            () => super.filteredCustomers,
            name: '_CustomerStore.filteredCustomers',
          ))
          .value;
  Computed<List<Customer>>? _$blockedCustomersComputed;

  @override
  List<Customer> get blockedCustomers =>
      (_$blockedCustomersComputed ??= Computed<List<Customer>>(
            () => super.blockedCustomers,
            name: '_CustomerStore.blockedCustomers',
          ))
          .value;
  Computed<int>? _$totalCountComputed;

  @override
  int get totalCount =>
      (_$totalCountComputed ??= Computed<int>(
            () => super.totalCount,
            name: '_CustomerStore.totalCount',
          ))
          .value;
  Computed<List<String>>? _$allAvailableTagsComputed;

  @override
  List<String> get allAvailableTags =>
      (_$allAvailableTagsComputed ??= Computed<List<String>>(
            () => super.allAvailableTags,
            name: '_CustomerStore.allAvailableTags',
          ))
          .value;

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

  late final _$selectedTagFiltersAtom = Atom(
    name: '_CustomerStore.selectedTagFilters',
    context: context,
  );

  @override
  ObservableList<String> get selectedTagFilters {
    _$selectedTagFiltersAtom.reportRead();
    return super.selectedTagFilters;
  }

  @override
  set selectedTagFilters(ObservableList<String> value) {
    _$selectedTagFiltersAtom.reportWrite(value, super.selectedTagFilters, () {
      super.selectedTagFilters = value;
    });
  }

  late final _$systemTagsAtom = Atom(
    name: '_CustomerStore.systemTags',
    context: context,
  );

  @override
  ObservableList<String> get systemTags {
    _$systemTagsAtom.reportRead();
    return super.systemTags;
  }

  @override
  set systemTags(ObservableList<String> value) {
    _$systemTagsAtom.reportWrite(value, super.systemTags, () {
      super.systemTags = value;
    });
  }

  late final _$fetchCustomersAsyncAction = AsyncAction(
    '_CustomerStore.fetchCustomers',
    context: context,
  );

  @override
  Future<void> fetchCustomers() {
    return _$fetchCustomersAsyncAction.run(() => super.fetchCustomers());
  }

  late final _$addCustomerAsyncAction = AsyncAction(
    '_CustomerStore.addCustomer',
    context: context,
  );

  @override
  Future<void> addCustomer(Customer customer) {
    return _$addCustomerAsyncAction.run(() => super.addCustomer(customer));
  }

  late final _$updateCustomerAsyncAction = AsyncAction(
    '_CustomerStore.updateCustomer',
    context: context,
  );

  @override
  Future<void> updateCustomer(Customer customer) {
    return _$updateCustomerAsyncAction.run(
      () => super.updateCustomer(customer),
    );
  }

  late final _$mergeCustomersAsyncAction = AsyncAction(
    '_CustomerStore.mergeCustomers',
    context: context,
  );

  @override
  Future<void> mergeCustomers(String primaryId, String secondaryId) {
    return _$mergeCustomersAsyncAction.run(
      () => super.mergeCustomers(primaryId, secondaryId),
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
  void toggleTagFilter(String tag) {
    final _$actionInfo = _$_CustomerStoreActionController.startAction(
      name: '_CustomerStore.toggleTagFilter',
    );
    try {
      return super.toggleTagFilter(tag);
    } finally {
      _$_CustomerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearTagFilters() {
    final _$actionInfo = _$_CustomerStoreActionController.startAction(
      name: '_CustomerStore.clearTagFilters',
    );
    try {
      return super.clearTagFilters();
    } finally {
      _$_CustomerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void blockCustomer(String id) {
    final _$actionInfo = _$_CustomerStoreActionController.startAction(
      name: '_CustomerStore.blockCustomer',
    );
    try {
      return super.blockCustomer(id);
    } finally {
      _$_CustomerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void unblockCustomer(String id) {
    final _$actionInfo = _$_CustomerStoreActionController.startAction(
      name: '_CustomerStore.unblockCustomer',
    );
    try {
      return super.unblockCustomer(id);
    } finally {
      _$_CustomerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addTag(String tag) {
    final _$actionInfo = _$_CustomerStoreActionController.startAction(
      name: '_CustomerStore.addTag',
    );
    try {
      return super.addTag(tag);
    } finally {
      _$_CustomerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
customers: ${customers},
isLoading: ${isLoading},
searchQuery: ${searchQuery},
selectedTagFilters: ${selectedTagFilters},
systemTags: ${systemTags},
filteredCustomers: ${filteredCustomers},
blockedCustomers: ${blockedCustomers},
totalCount: ${totalCount},
allAvailableTags: ${allAvailableTags}
    ''';
  }
}
