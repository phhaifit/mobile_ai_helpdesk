import 'package:mobile_ai_helpdesk/core/stores/error/error_store.dart';
import 'package:mobile_ai_helpdesk/domain/entity/tenant/tenant.dart';
import 'package:mobile_ai_helpdesk/domain/repository/tenant/tenant_repository.dart';
import 'package:mobx/mobx.dart';

part 'tenant_store.g.dart';

class TenantStore = _TenantStore with _$TenantStore;

abstract class _TenantStore with Store {
  _TenantStore(this._tenantRepository, this._errorStore) {
    loadTenants();
  }

  final TenantRepository _tenantRepository;
  final ErrorStore _errorStore;

  @observable
  Tenant? currentTenant;

  @observable
  ObservableList<Tenant> tenantList = ObservableList<Tenant>();

  @observable
  bool isLoading = false;

  @action
  Future<void> loadTenants() async {
    isLoading = true;
    try {
      final list = await _tenantRepository.getTenants();
      tenantList
        ..clear()
        ..addAll(list);
      currentTenant ??= tenantList.isNotEmpty ? tenantList.first : null;
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> switchTenant(String tenantId) async {
    isLoading = true;
    try {
      final t = await _tenantRepository.getTenantById(tenantId);
      if (t != null) {
        currentTenant = t;
      }
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> createTenant(Tenant tenant) async {
    isLoading = true;
    try {
      final created = await _tenantRepository.createTenant(tenant);
      tenantList.add(created);
      currentTenant = created;
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> deleteTenant(String id) async {
    isLoading = true;
    try {
      final ok = await _tenantRepository.deleteTenant(id);
      if (!ok) {
        return;
      }
      tenantList.removeWhere((t) => t.id == id);
      if (currentTenant?.id == id) {
        currentTenant = tenantList.isNotEmpty ? tenantList.first : null;
      }
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoading = false;
    }
  }

  void dispose() {}
}
