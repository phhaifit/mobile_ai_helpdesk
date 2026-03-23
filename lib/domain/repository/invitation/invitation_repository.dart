import 'package:mobile_ai_helpdesk/domain/entity/invitation/invitation.dart';
import 'package:mobile_ai_helpdesk/domain/entity/team_member/team_member.dart';

abstract class InvitationRepository {
  Future<List<Invitation>> getInvitations(String tenantId);

  Future<Invitation> inviteMember({
    required String tenantId,
    required String email,
    required TeamRole role,
    required String invitedByMemberId,
  });

  Future<Invitation?> resendInvitation(String invitationId);

  Future<Invitation?> acceptInvitation(String invitationId);

  Future<Invitation?> declineInvitation(String invitationId);
}
