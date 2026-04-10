import 'package:ai_helpdesk/core/stores/error/error_store.dart';
import 'package:ai_helpdesk/domain/entity/invitation/invitation.dart';
import 'package:ai_helpdesk/domain/entity/permission/permission.dart';
import 'package:ai_helpdesk/domain/entity/team_member/team_member.dart';
import 'package:ai_helpdesk/domain/repository/invitation/invitation_repository.dart';
import 'package:ai_helpdesk/domain/repository/team/team_repository.dart';
import 'package:ai_helpdesk/presentation/tenant/store/tenant_store.dart';
import 'package:mobx/mobx.dart';

part 'team_store.g.dart';

class TeamStore = _TeamStore with _$TeamStore;

abstract class _TeamStore with Store {
  _TeamStore(
    this._teamRepository,
    this._invitationRepository,
    this._tenantStore,
    this._errorStore,
  ) {
    _tenantReaction = reaction((_) => _tenantStore.currentTenant?.id, (
      String? tenantId,
    ) {
      if (tenantId != null) {
        loadTeamData();
      } else {
        _clearTeamData();
      }
    });
    if (_tenantStore.currentTenant != null) {
      loadTeamData();
    }
  }

  final TeamRepository _teamRepository;
  final InvitationRepository _invitationRepository;
  final TenantStore _tenantStore;
  final ErrorStore _errorStore;

  late final ReactionDisposer _tenantReaction;

  @observable
  ObservableList<TeamMember> teamMembers = ObservableList<TeamMember>();

  @observable
  ObservableList<Invitation> invitations = ObservableList<Invitation>();

  @observable
  bool isLoading = false;

  @action
  void _clearTeamData() {
    teamMembers.clear();
    invitations.clear();
  }

  Future<void> _syncListsFromRepository() async {
    final tenantId = _tenantStore.currentTenant?.id;
    if (tenantId == null) {
      runInAction(() {
        teamMembers.clear();
        invitations.clear();
      });
      return;
    }
    final members = await _teamRepository.getMembers(tenantId);
    final invs = await _invitationRepository.getInvitations(tenantId);
    runInAction(() {
      teamMembers
        ..clear()
        ..addAll(members);
      invitations
        ..clear()
        ..addAll(invs);
    });
  }

  @action
  Future<void> loadTeamData() async {
    final tenantId = _tenantStore.currentTenant?.id;
    if (tenantId == null) {
      _clearTeamData();
      return;
    }
    isLoading = true;
    try {
      await _syncListsFromRepository();
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> inviteMember({
    required String email,
    required TeamRole role,
    required String invitedByMemberId,
  }) async {
    final tenantId = _tenantStore.currentTenant?.id;
    if (tenantId == null) {
      return;
    }
    isLoading = true;
    try {
      await _invitationRepository.inviteMember(
        tenantId: tenantId,
        email: email,
        role: role,
        invitedByMemberId: invitedByMemberId,
      );
      await _syncListsFromRepository();
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> resendInvitation(String invitationId) async {
    isLoading = true;
    try {
      await _invitationRepository.resendInvitation(invitationId);
      await _syncListsFromRepository();
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> acceptInvitation(String invitationId) async {
    isLoading = true;
    try {
      await _invitationRepository.acceptInvitation(invitationId);
      await _syncListsFromRepository();
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> declineInvitation(String invitationId) async {
    isLoading = true;
    try {
      await _invitationRepository.declineInvitation(invitationId);
      await _syncListsFromRepository();
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoading = false;
    }
  }

  static const List<Permission> _ownerPermissionSet = [
    Permission(
      code: 'tenant:settings:write',
      description: 'Edit tenant settings',
    ),
    Permission(code: 'tenant:members:manage'),
    Permission(code: 'tickets:read'),
    Permission(code: 'tickets:write'),
  ];

  static const List<Permission> _adminPermissionSet = [
    Permission(code: 'tenant:members:invite'),
    Permission(code: 'tickets:read'),
    Permission(code: 'tickets:write'),
  ];

  static const List<Permission> _memberPermissionSet = [
    Permission(code: 'tickets:read'),
    Permission(code: 'tickets:write'),
  ];

  List<Permission> _permissionsForRole(TeamRole role) {
    switch (role) {
      case TeamRole.owner:
        return List<Permission>.from(_ownerPermissionSet);
      case TeamRole.admin:
        return List<Permission>.from(_adminPermissionSet);
      case TeamRole.member:
        return List<Permission>.from(_memberPermissionSet);
    }
  }

  @action
  Future<bool> updateMemberProfile({
    required String memberId,
    required TeamRole role,
    String? displayName,
    String? phoneNumber,
  }) async {
    final tenantId = _tenantStore.currentTenant?.id;
    if (tenantId == null) {
      return false;
    }
    isLoading = true;
    try {
      final existing = await _teamRepository.getMemberById(memberId);
      if (existing == null) {
        return false;
      }
      final permissions = existing.role == role
          ? List<Permission>.from(existing.permissions)
          : _permissionsForRole(role);
      final trimmed = displayName?.trim();
      final phone = phoneNumber?.trim();
      final updated = await _teamRepository.updateMember(
        TeamMember(
          id: existing.id,
          tenantId: existing.tenantId,
          email: existing.email,
          displayName: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
          phoneNumber: (phone == null || phone.isEmpty) ? null : phone,
          avatarUrl: existing.avatarUrl,
          role: role,
          permissions: permissions,
          isActive: existing.isActive,
          createdAt: existing.createdAt,
        ),
      );
      if (updated != null) {
        runInAction(() {
          final i = teamMembers.indexWhere((m) => m.id == memberId);
          if (i >= 0) {
            teamMembers[i] = updated;
          }
        });
      }
      return updated != null;
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> removeMember(String memberId) async {
    isLoading = true;
    try {
      final ok = await _teamRepository.deleteMember(memberId);
      if (ok) {
        runInAction(() {
          teamMembers.removeWhere((m) => m.id == memberId);
        });
      }
      return ok;
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> updatePermissions({
    required String memberId,
    required List<Permission> permissions,
  }) async {
    try {
      isLoading = true;
      final existing = await _teamRepository.getMemberById(memberId);
      if (existing == null) {
        return;
      }
      final updated = await _teamRepository.updateMember(
        TeamMember(
          id: existing.id,
          tenantId: existing.tenantId,
          email: existing.email,
          displayName: existing.displayName,
          role: existing.role,
          permissions: permissions,
          isActive: existing.isActive,
          createdAt: existing.createdAt,
        ),
      );
      if (updated != null) {
        runInAction(() {
          final i = teamMembers.indexWhere((m) => m.id == memberId);
          if (i >= 0) {
            teamMembers[i] = updated;
          }
        });
      }
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoading = false;
    }
  }

  void dispose() {
    _tenantReaction();
  }
}
