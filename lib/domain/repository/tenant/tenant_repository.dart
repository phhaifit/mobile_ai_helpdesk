import 'package:mobile_ai_helpdesk/domain/entity/tenant/tenant.dart';

abstract class TenantRepository {
  Future<List<Tenant>> getTenants();

  Future<Tenant?> getTenantById(String id);

  Future<Tenant> createTenant(Tenant tenant);

  Future<Tenant?> updateTenant(Tenant tenant);

  Future<bool> deleteTenant(String id);
}
