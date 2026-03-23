import 'package:ai_helpdesk/domain/entity/team_member/team_member.dart';

abstract class TeamRepository {
  Future<List<TeamMember>> getMembers(String tenantId);

  Future<TeamMember?> getMemberById(String id);

  Future<TeamMember> createMember(TeamMember member);

  Future<TeamMember?> updateMember(TeamMember member);

  Future<bool> deleteMember(String id);
}
