import 'dart:async';

import 'package:ai_helpdesk/domain/entity/team_member/team_member.dart';
import 'package:ai_helpdesk/domain/entity/tenant/tenant.dart';
import 'package:ai_helpdesk/domain/entity/tenant_settings/tenant_settings.dart';
import 'package:ai_helpdesk/domain/repository/tenant/tenant_repository.dart';

class MockTenantRepositoryImpl implements TenantRepository {
  MockTenantRepositoryImpl() {
    _tenants.addAll(_seedTenants);
  }

  final List<Tenant> _tenants = [];
  int _nextId = 100;

  static final List<Tenant> _seedTenants = [
    Tenant(
      id: 'tn-001',
      name: 'Acme Corporation',
      slug: 'acme',
      settings: const TenantSettings(
        allowInvitations: true,
        defaultRole: TeamRole.member,
        enableAuditLog: true,
      ),
      createdAt: DateTime(2025, 1, 10, 9, 0),
    ),
    Tenant(
      id: 'tn-002',
      name: 'Beta Labs',
      slug: 'beta-labs',
      settings: const TenantSettings(
        allowInvitations: false,
        defaultRole: TeamRole.member,
        enableAuditLog: false,
      ),
      createdAt: DateTime(2025, 2, 3, 14, 30),
    ),
    Tenant(
      id: 'tn-003',
      name: 'Gamma Industries',
      slug: null,
      settings: const TenantSettings(
        allowInvitations: true,
        defaultRole: TeamRole.admin,
        enableAuditLog: false,
      ),
      createdAt: DateTime(2025, 3, 1, 11, 15),
    ),
  ];

  Future<void> _delay([int milliseconds = 450]) =>
      Future<void>.delayed(Duration(milliseconds: milliseconds));

  @override
  Future<List<Tenant>> getTenants() async {
    await _delay(500);
    return List<Tenant>.unmodifiable(_tenants);
  }

  @override
  Future<Tenant?> getTenantById(String id) async {
    await _delay(320);
    try {
      return _tenants.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Tenant> createTenant(Tenant tenant) async {
    await _delay(550);
    final created = Tenant(
      id: 'tn-${_nextId++}',
      name: tenant.name,
      slug: tenant.slug,
      settings: tenant.settings,
      createdAt: tenant.createdAt,
    );
    _tenants.add(created);
    return created;
  }

  @override
  Future<Tenant?> updateTenant(Tenant tenant) async {
    await _delay(520);
    final index = _tenants.indexWhere((t) => t.id == tenant.id);
    if (index == -1) {
      return null;
    }
    _tenants[index] = tenant;
    return tenant;
  }

  @override
  Future<bool> deleteTenant(String id) async {
    await _delay(480);
    final index = _tenants.indexWhere((t) => t.id == id);
    if (index == -1) {
      return false;
    }
    _tenants.removeAt(index);
    return true;
  }

  @override
  Future<TenantSettings> getTenantSettings(String tenantId) async {
    await _delay(320);
    final tenant = await getTenantById(tenantId);
    if (tenant == null) {
      throw StateError('Tenant not found: $tenantId');
    }
    return tenant.settings;
  }

  @override
  Future<TenantSettings> updateTenantSettings({
    required String tenantId,
    required bool autoResolutionEnabled,
    required int autoResolutionTimeoutHours,
  }) async {
    await _delay(420);
    final index = _tenants.indexWhere((t) => t.id == tenantId);
    if (index == -1) {
      throw StateError('Tenant not found: $tenantId');
    }

    final tenant = _tenants[index];
    final updatedSettings = TenantSettings(
      allowInvitations: tenant.settings.allowInvitations,
      defaultRole: tenant.settings.defaultRole,
      enableAuditLog: tenant.settings.enableAuditLog,
      autoResolutionEnabled: autoResolutionEnabled,
      autoResolutionTimeoutHours: autoResolutionTimeoutHours,
    );

    _tenants[index] = Tenant(
      id: tenant.id,
      name: tenant.name,
      slug: tenant.slug,
      settings: updatedSettings,
      createdAt: tenant.createdAt,
    );

    return updatedSettings;
  }
}
