import '/data/network/apis/tenant/tenant_api.dart';
import '/domain/entity/tenant/tenant.dart';
import '/domain/entity/tenant_settings/tenant_settings.dart';
import '/domain/repository/tenant/tenant_repository.dart';

class TenantRepositoryImpl implements TenantRepository {
  TenantRepositoryImpl(this._tenantApi);

  final TenantApi _tenantApi;

  @override
  Future<List<Tenant>> getTenants() => _tenantApi.getTenants();

  @override
  Future<Tenant?> getTenantById(String id) async {
    await _tenantApi.switchTenant(id);
    return _tenantApi.getTenantById(id);
  }

  @override
  Future<Tenant> createTenant(Tenant tenant) => _tenantApi.createTenant(tenant);

  @override
  Future<Tenant> createTenantOnFirstLogin({required String name}) {
    return _tenantApi.createTenantOnFirstLogin(name: name);
  }

  @override
  Future<Tenant?> updateTenant(Tenant tenant) => _tenantApi.updateTenant(tenant);

  @override
  Future<bool> deleteTenant(String id) => _tenantApi.deleteTenant(id);

  @override
  Future<TenantSettings> getTenantSettings(String tenantId) {
    return _tenantApi.getTenantSettings(tenantId);
  }

  @override
  Future<TenantSettings> updateTenantSettings({
    required String tenantId,
    required bool autoResolutionEnabled,
    required int autoResolutionTimeoutHours,
  }) {
    return _tenantApi.updateTenantSettings(
      tenantId: tenantId,
      payload: {
        'autoResolutionEnabled': autoResolutionEnabled,
        'autoResolutionTimeoutHours': autoResolutionTimeoutHours,
      },
    );
  }

  @override
  Future<Map<String, dynamic>> getTenantJoinInfo() {
    return _tenantApi.getTenantJoinInfo();
  }
}
