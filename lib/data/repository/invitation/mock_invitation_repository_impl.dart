import 'dart:async';

import 'package:mobile_ai_helpdesk/domain/entity/invitation/invitation.dart';
import 'package:mobile_ai_helpdesk/domain/entity/permission/permission.dart';
import 'package:mobile_ai_helpdesk/domain/entity/team_member/team_member.dart';
import 'package:mobile_ai_helpdesk/domain/repository/invitation/invitation_repository.dart';
import 'package:mobile_ai_helpdesk/domain/repository/team/team_repository.dart';

class MockInvitationRepositoryImpl implements InvitationRepository {
  MockInvitationRepositoryImpl(this._teamRepository) {
    _invitations.addAll(_seedInvitations);
  }

  final TeamRepository _teamRepository;

  final List<Invitation> _invitations = [];
  int _nextId = 700;

  static const List<Permission> _memberPermissions = [
    Permission(code: 'tickets:read'),
    Permission(code: 'tickets:write'),
  ];

  static final List<Invitation> _seedInvitations = [
    Invitation(
      id: 'inv-001',
      tenantId: 'tn-001',
      email: 'pending.user@acme.example',
      role: TeamRole.member,
      status: InvitationStatus.pending,
      invitedByMemberId: 'mem-002',
      createdAt: DateTime(2026, 3, 10, 12, 0),
      expiresAt: DateTime(2026, 4, 10, 12, 0),
    ),
    Invitation(
      id: 'inv-002',
      tenantId: 'tn-001',
      email: 'viewer.invite@acme.example',
      role: TeamRole.viewer,
      status: InvitationStatus.pending,
      invitedByMemberId: 'mem-001',
      createdAt: DateTime(2026, 3, 18, 9, 30),
      expiresAt: DateTime(2026, 4, 18, 9, 30),
    ),
  ];

  Future<void> _delay([int milliseconds = 420]) =>
      Future<void>.delayed(Duration(milliseconds: milliseconds));

  List<Permission> _permissionsForRole(TeamRole role) {
    switch (role) {
      case TeamRole.viewer:
        return const [Permission(code: 'tickets:read')];
      case TeamRole.owner:
      case TeamRole.admin:
      case TeamRole.member:
        return List<Permission>.from(_memberPermissions);
    }
  }

  @override
  Future<List<Invitation>> getInvitations(String tenantId) async {
    await _delay(400);
    return _invitations.where((i) => i.tenantId == tenantId).toList();
  }

  @override
  Future<Invitation> inviteMember({
    required String tenantId,
    required String email,
    required TeamRole role,
    required String invitedByMemberId,
  }) async {
    await _delay(520);
    final now = DateTime.now();
    final invitation = Invitation(
      id: 'inv-${_nextId++}',
      tenantId: tenantId,
      email: email,
      role: role,
      status: InvitationStatus.pending,
      invitedByMemberId: invitedByMemberId,
      createdAt: now,
      expiresAt: now.add(const Duration(days: 14)),
    );
    _invitations.add(invitation);
    return invitation;
  }

  @override
  Future<Invitation?> resendInvitation(String invitationId) async {
    await _delay(380);
    final index = _invitations.indexWhere((i) => i.id == invitationId);
    if (index == -1) {
      return null;
    }
    final existing = _invitations[index];
    if (existing.status != InvitationStatus.pending) {
      return null;
    }
    final updated = Invitation(
      id: existing.id,
      tenantId: existing.tenantId,
      email: existing.email,
      role: existing.role,
      status: existing.status,
      invitedByMemberId: existing.invitedByMemberId,
      createdAt: existing.createdAt,
      expiresAt: DateTime.now().add(const Duration(days: 14)),
      acceptedAt: existing.acceptedAt,
    );
    _invitations[index] = updated;
    return updated;
  }

  @override
  Future<Invitation?> acceptInvitation(String invitationId) async {
    await _delay(540);
    final index = _invitations.indexWhere((i) => i.id == invitationId);
    if (index == -1) {
      return null;
    }
    final existing = _invitations[index];
    if (existing.status != InvitationStatus.pending) {
      return null;
    }
    if (DateTime.now().isAfter(existing.expiresAt)) {
      return null;
    }
    final now = DateTime.now();
    final accepted = Invitation(
      id: existing.id,
      tenantId: existing.tenantId,
      email: existing.email,
      role: existing.role,
      status: InvitationStatus.accepted,
      invitedByMemberId: existing.invitedByMemberId,
      createdAt: existing.createdAt,
      expiresAt: existing.expiresAt,
      acceptedAt: now,
    );
    _invitations[index] = accepted;

    await _teamRepository.createMember(
      TeamMember(
        id: 'mem-placeholder',
        tenantId: existing.tenantId,
        email: existing.email,
        displayName: existing.email.split('@').first,
        role: existing.role,
        permissions: _permissionsForRole(existing.role),
        isActive: true,
        createdAt: now,
      ),
    );

    return accepted;
  }

  @override
  Future<Invitation?> declineInvitation(String invitationId) async {
    await _delay(360);
    final index = _invitations.indexWhere((i) => i.id == invitationId);
    if (index == -1) {
      return null;
    }
    final existing = _invitations[index];
    if (existing.status != InvitationStatus.pending) {
      return null;
    }
    final declined = Invitation(
      id: existing.id,
      tenantId: existing.tenantId,
      email: existing.email,
      role: existing.role,
      status: InvitationStatus.revoked,
      invitedByMemberId: existing.invitedByMemberId,
      createdAt: existing.createdAt,
      expiresAt: existing.expiresAt,
      acceptedAt: existing.acceptedAt,
    );
    _invitations[index] = declined;
    return declined;
  }
}
