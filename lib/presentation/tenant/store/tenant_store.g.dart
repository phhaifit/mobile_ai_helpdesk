// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TenantStore on _TenantStore, Store {
  late final _$currentTenantAtom = Atom(
    name: '_TenantStore.currentTenant',
    context: context,
  );

  @override
  Tenant? get currentTenant {
    _$currentTenantAtom.reportRead();
    return super.currentTenant;
  }

  @override
  set currentTenant(Tenant? value) {
    _$currentTenantAtom.reportWrite(value, super.currentTenant, () {
      super.currentTenant = value;
    });
  }

  late final _$tenantListAtom = Atom(
    name: '_TenantStore.tenantList',
    context: context,
  );

  @override
  ObservableList<Tenant> get tenantList {
    _$tenantListAtom.reportRead();
    return super.tenantList;
  }

  @override
  set tenantList(ObservableList<Tenant> value) {
    _$tenantListAtom.reportWrite(value, super.tenantList, () {
      super.tenantList = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_TenantStore.isLoading',
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

  late final _$loadTenantsAsyncAction = AsyncAction(
    '_TenantStore.loadTenants',
    context: context,
  );

  @override
  Future<void> loadTenants() {
    return _$loadTenantsAsyncAction.run(() => super.loadTenants());
  }

  late final _$switchTenantAsyncAction = AsyncAction(
    '_TenantStore.switchTenant',
    context: context,
  );

  @override
  Future<void> switchTenant(String tenantId) {
    return _$switchTenantAsyncAction.run(() => super.switchTenant(tenantId));
  }

  late final _$createTenantAsyncAction = AsyncAction(
    '_TenantStore.createTenant',
    context: context,
  );

  @override
  Future<void> createTenant(Tenant tenant) {
    return _$createTenantAsyncAction.run(() => super.createTenant(tenant));
  }

  late final _$deleteTenantAsyncAction = AsyncAction(
    '_TenantStore.deleteTenant',
    context: context,
  );

  @override
  Future<void> deleteTenant(String id) {
    return _$deleteTenantAsyncAction.run(() => super.deleteTenant(id));
  }

  @override
  String toString() {
    return '''
currentTenant: ${currentTenant},
tenantList: ${tenantList},
isLoading: ${isLoading}
    ''';
  }
}
