import 'dart:async';

import 'package:ai_helpdesk/domain/entity/permission/permission.dart';
import 'package:ai_helpdesk/domain/entity/team_member/team_member.dart';
import 'package:ai_helpdesk/domain/repository/team/team_repository.dart';

class MockTeamRepositoryImpl implements TeamRepository {
  MockTeamRepositoryImpl() {
    _members.addAll(_seedMembers);
  }

  final List<TeamMember> _members = [];
  int _nextId = 500;

  static const List<Permission> _ownerPermissions = [
    Permission(
      code: 'tenant:settings:write',
      description: 'Edit tenant settings',
    ),
    Permission(code: 'tenant:members:manage'),
    Permission(code: 'tickets:read'),
    Permission(code: 'tickets:write'),
  ];

  static const List<Permission> _adminPermissions = [
    Permission(code: 'tenant:members:invite'),
    Permission(code: 'tickets:read'),
    Permission(code: 'tickets:write'),
  ];

  static const List<Permission> _memberPermissions = [
    Permission(code: 'tickets:read'),
    Permission(code: 'tickets:write'),
  ];

  static const List<Permission> _viewerPermissions = [
    Permission(code: 'tickets:read'),
  ];

  static final List<TeamMember> _seedMembers = [
    TeamMember(
      id: 'mem-001',
      tenantId: 'tn-001',
      email: 'alice.owner@acme.example',
      displayName: 'Alice Owner',
      role: TeamRole.owner,
      permissions: _ownerPermissions,
      isActive: true,
      createdAt: DateTime(2025, 1, 10, 9, 0),
    ),
    TeamMember(
      id: 'mem-002',
      tenantId: 'tn-001',
      email: 'bob.admin@acme.example',
      displayName: 'Bob Admin',
      role: TeamRole.admin,
      permissions: _adminPermissions,
      isActive: true,
      createdAt: DateTime(2025, 1, 12, 10, 30),
    ),
    TeamMember(
      id: 'mem-003',
      tenantId: 'tn-001',
      email: 'carol.member@acme.example',
      displayName: 'Carol Member',
      role: TeamRole.member,
      permissions: _memberPermissions,
      isActive: true,
      createdAt: DateTime(2025, 1, 20, 8, 15),
    ),
    TeamMember(
      id: 'mem-004',
      tenantId: 'tn-002',
      email: 'dana.owner@beta.example',
      displayName: 'Dana Owner',
      role: TeamRole.owner,
      permissions: _ownerPermissions,
      isActive: true,
      createdAt: DateTime(2025, 2, 3, 14, 30),
    ),
    TeamMember(
      id: 'mem-005',
      tenantId: 'tn-002',
      email: 'eric.viewer@beta.example',
      displayName: 'Eric Viewer',
      role: TeamRole.member,
      permissions: _viewerPermissions,
      isActive: false,
      createdAt: DateTime(2025, 2, 10, 16, 0),
    ),
    TeamMember(
      id: 'mem-006',
      tenantId: 'tn-003',
      email: 'frank.admin@gamma.example',
      displayName: 'Frank Admin',
      role: TeamRole.admin,
      permissions: _adminPermissions,
      isActive: true,
      createdAt: DateTime(2025, 3, 1, 11, 15),
    ),
  ];

  Future<void> _delay([int milliseconds = 450]) =>
      Future<void>.delayed(Duration(milliseconds: milliseconds));

  @override
  Future<List<TeamMember>> getMembers(String tenantId) async {
    await _delay(480);
    return _members
        .where((m) => m.tenantId == tenantId)
        .toList(growable: false);
  }

  @override
  Future<TeamMember?> getMemberById(String id) async {
    await _delay(310);
    try {
      return _members.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<TeamMember> createMember(TeamMember member) async {
    await _delay(560);
    final created = TeamMember(
      id: 'mem-${_nextId++}',
      tenantId: member.tenantId,
      email: member.email,
      displayName: member.displayName,
      role: member.role,
      permissions: List<Permission>.from(member.permissions),
      isActive: member.isActive,
      createdAt: member.createdAt,
    );
    _members.add(created);
    return created;
  }

  @override
  Future<TeamMember?> updateMember(TeamMember member) async {
    await _delay(530);
    final index = _members.indexWhere((m) => m.id == member.id);
    if (index == -1) {
      return null;
    }
    _members[index] = member;
    return member;
  }

  @override
  Future<bool> deleteMember(String id) async {
    await _delay(490);
    final index = _members.indexWhere((m) => m.id == id);
    if (index == -1) {
      return false;
    }
    _members.removeAt(index);
    return true;
  }
}
