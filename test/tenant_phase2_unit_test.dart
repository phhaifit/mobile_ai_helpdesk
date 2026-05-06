import 'package:ai_helpdesk/core/stores/error/error_store.dart';
import 'package:ai_helpdesk/data/repository/team/mock_team_repository_impl.dart';
import 'package:ai_helpdesk/domain/entity/permission/permission.dart';
import 'package:ai_helpdesk/domain/entity/team_member/team_member.dart';
import 'package:ai_helpdesk/domain/entity/tenant/tenant.dart';
import 'package:ai_helpdesk/domain/entity/tenant_settings/tenant_settings.dart';
import 'package:ai_helpdesk/domain/repository/tenant/tenant_repository.dart';
import 'package:ai_helpdesk/presentation/tenant/store/tenant_store.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTenantRepository implements TenantRepository {
  FakeTenantRepository(this._tenants, {this.cachedId});

  final List<Tenant> _tenants;
  String? cachedId;
  String? savedId;

  @override
  Future<List<Tenant>> getTenants() async => _tenants;

  @override
  Future<Tenant?> getTenantById(String id) async {
    for (final tenant in _tenants) {
      if (tenant.id == id) {
        return tenant;
      }
    }
    return null;
  }

  @override
  Future<Tenant> createTenant(Tenant tenant) async => tenant;

  @override
  Future<Tenant> createTenantOnFirstLogin({required String name}) async {
    return Tenant(
      id: 'tn-first',
      name: name,
      slug: name.toLowerCase(),
      settings: const TenantSettings(
        allowInvitations: true,
        defaultRole: TeamRole.member,
        enableAuditLog: false,
      ),
      createdAt: DateTime(2026, 1, 1),
    );
  }

  @override
  Future<Tenant?> updateTenant(Tenant tenant) async => tenant;

  @override
  Future<bool> deleteTenant(String id) async => true;

  @override
  Future<TenantSettings> getTenantSettings(String tenantId) async {
    return const TenantSettings(
      allowInvitations: true,
      defaultRole: TeamRole.member,
      enableAuditLog: false,
    );
  }

  @override
  Future<TenantSettings> updateTenantSettings({
    required String tenantId,
    required bool autoResolutionEnabled,
    required int autoResolutionTimeoutHours,
  }) async {
    return TenantSettings(
      allowInvitations: true,
      defaultRole: TeamRole.member,
      enableAuditLog: false,
      autoResolutionEnabled: autoResolutionEnabled,
      autoResolutionTimeoutHours: autoResolutionTimeoutHours,
    );
  }

  @override
  Future<String?> getCachedTenantId() async => cachedId;

  @override
  Future<void> saveCachedTenantId(String? tenantId) async {
    savedId = tenantId;
    cachedId = tenantId;
  }

  @override
  Future<Map<String, dynamic>> getTenantJoinInfo() async => <String, dynamic>{};
}

void main() {
  group('TenantStore cached tenant', () {
    test('uses cached tenant when available', () async {
      final tenants = [
        Tenant(
          id: 'tn-001',
          name: 'Acme',
          slug: 'acme',
          settings: const TenantSettings(
            allowInvitations: true,
            defaultRole: TeamRole.member,
            enableAuditLog: false,
          ),
          createdAt: DateTime(2026, 1, 1),
        ),
        Tenant(
          id: 'tn-002',
          name: 'Beta',
          slug: 'beta',
          settings: const TenantSettings(
            allowInvitations: true,
            defaultRole: TeamRole.member,
            enableAuditLog: false,
          ),
          createdAt: DateTime(2026, 1, 2),
        ),
      ];
      final repo = FakeTenantRepository(tenants, cachedId: 'tn-002');
      final store = TenantStore(repo, ErrorStore());

      await store.loadTenants();

      expect(store.currentTenant?.id, 'tn-002');
      expect(repo.savedId, 'tn-002');
    });

    test('falls back to first tenant when cached id is missing', () async {
      final tenants = [
        Tenant(
          id: 'tn-001',
          name: 'Acme',
          slug: 'acme',
          settings: const TenantSettings(
            allowInvitations: true,
            defaultRole: TeamRole.member,
            enableAuditLog: false,
          ),
          createdAt: DateTime(2026, 1, 1),
        ),
      ];
      final repo = FakeTenantRepository(tenants, cachedId: 'tn-999');
      final store = TenantStore(repo, ErrorStore());

      await store.loadTenants();

      expect(store.currentTenant?.id, 'tn-001');
      expect(repo.savedId, 'tn-001');
    });
  });

  group('MockTeamRepositoryImpl permission rules', () {
    test('prevents owner demotion', () async {
      final repo = MockTeamRepositoryImpl();
      final members = await repo.getMembers('tn-001');
      final owner = members.firstWhere((m) => m.role == TeamRole.owner);

      final result = await repo.updateMember(
        TeamMember(
          id: owner.id,
          tenantId: owner.tenantId,
          email: owner.email,
          displayName: owner.displayName,
          role: TeamRole.admin,
          permissions: owner.permissions,
          isActive: owner.isActive,
          createdAt: owner.createdAt,
          phoneNumber: owner.phoneNumber,
          avatarUrl: owner.avatarUrl,
        ),
      );

      expect(result, isNull);
    });

    test('rejects owner promotion when another owner exists', () async {
      final repo = MockTeamRepositoryImpl();
      final members = await repo.getMembers('tn-001');
      final admin = members.firstWhere((m) => m.role == TeamRole.admin);

      final result = await repo.updateMember(
        TeamMember(
          id: admin.id,
          tenantId: admin.tenantId,
          email: admin.email,
          displayName: admin.displayName,
          role: TeamRole.owner,
          permissions: admin.permissions,
          isActive: admin.isActive,
          createdAt: admin.createdAt,
          phoneNumber: admin.phoneNumber,
          avatarUrl: admin.avatarUrl,
        ),
      );

      expect(result, isNull);
    });

    test('normalizes permissions to role defaults', () async {
      final repo = MockTeamRepositoryImpl();
      final members = await repo.getMembers('tn-001');
      final admin = members.firstWhere((m) => m.role == TeamRole.admin);

      final result = await repo.updateMember(
        TeamMember(
          id: admin.id,
          tenantId: admin.tenantId,
          email: admin.email,
          displayName: admin.displayName,
          role: TeamRole.admin,
          permissions: const [
            Permission(code: 'tenant:settings:write'),
          ],
          isActive: admin.isActive,
          createdAt: admin.createdAt,
          phoneNumber: admin.phoneNumber,
          avatarUrl: admin.avatarUrl,
        ),
      );

      expect(result, isNotNull);
      final codes = result!.permissions.map((p) => p.code).toList();
      expect(codes.contains('tenant:settings:write'), isFalse);
      expect(codes, contains('tenant:members:invite'));
    });
  });
}
