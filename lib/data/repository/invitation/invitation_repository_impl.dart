import '/data/network/apis/invitation/invitation_api.dart';
import '/domain/entity/invitation/invitation.dart';
import '/domain/entity/team_member/team_member.dart';
import '/domain/repository/invitation/invitation_repository.dart';

class InvitationRepositoryImpl implements InvitationRepository {
  InvitationRepositoryImpl(this._invitationApi);

  final InvitationApi _invitationApi;

  @override
  Future<List<Invitation>> getInvitations(String tenantId) {
    return _invitationApi.getInvitations(tenantId);
  }

  @override
  Future<Invitation> inviteMember({
    required String tenantId,
    required String email,
    required TeamRole role,
    required String invitedByMemberId,
  }) {
    return _invitationApi.inviteMember(
      tenantId: tenantId,
      email: email,
      role: role,
      invitedByMemberId: invitedByMemberId,
    );
  }

  @override
  Future<Invitation?> resendInvitation(String invitationId) {
    return _invitationApi.resendInvitation(invitationId);
  }

  @override
  Future<Invitation?> acceptInvitation(String invitationId) {
    return _invitationApi.acceptInvitation(invitationId);
  }

  @override
  Future<Invitation?> declineInvitation(String invitationId) {
    return _invitationApi.declineInvitation(invitationId);
  }

  @override
  Future<bool> deleteInvitation(String invitationId) {
    return _invitationApi.deleteInvitation(invitationId);
  }
}
