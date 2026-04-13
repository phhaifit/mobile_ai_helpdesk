import '/data/network/apis/tenant/tenant_api.dart';
import '/domain/entity/tenant/tenant.dart';
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
  Future<Tenant?> updateTenant(Tenant tenant) => _tenantApi.updateTenant(tenant);

  @override
  Future<bool> deleteTenant(String id) => _tenantApi.deleteTenant(id);
}
