import 'package:ai_helpdesk/domain/entity/tenant/tenant.dart';
import 'package:ai_helpdesk/domain/entity/tenant_settings/tenant_settings.dart';

abstract class TenantRepository {
  Future<List<Tenant>> getTenants();

  Future<Tenant?> getTenantById(String id);

  Future<Tenant> createTenant(Tenant tenant);

  Future<Tenant?> updateTenant(Tenant tenant);

  Future<bool> deleteTenant(String id);

  Future<TenantSettings> getTenantSettings(String tenantId);

  Future<TenantSettings> updateTenantSettings({
    required String tenantId,
    required bool autoResolutionEnabled,
    required int autoResolutionTimeoutHours,
  });
}
