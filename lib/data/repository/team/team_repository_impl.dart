import '/data/network/apis/team/team_api.dart';
import '/domain/entity/team_member/team_member.dart';
import '/domain/repository/team/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  TeamRepositoryImpl(this._teamApi);

  final TeamApi _teamApi;
  final Map<String, TeamMember> _memberCacheById = <String, TeamMember>{};

  @override
  Future<List<TeamMember>> getMembers(String tenantId) async {
    final members = await _teamApi.getMembers(tenantId);
    for (final member in members) {
      _memberCacheById[member.id] = member;
    }
    return members;
  }

  @override
  Future<TeamMember?> getMemberById(String id) async {
    return _memberCacheById[id];
  }

  @override
  Future<TeamMember> createMember(TeamMember member) async {
    final created = await _teamApi.createMember(member);
    _memberCacheById[created.id] = created;
    return created;
  }

  @override
  Future<TeamMember?> updateMember(TeamMember member) async {
    final updated = await _teamApi.updateMember(member);
    _memberCacheById[updated.id] = updated;
    return updated;
  }

  @override
  Future<bool> deleteMember(String id) async {
    final member = _memberCacheById[id];
    if (member == null) {
      return false;
    }
    final deleted = await _teamApi.deleteMember(
      tenantId: member.tenantId,
      memberId: member.id,
    );
    if (deleted) {
      _memberCacheById.remove(id);
    }
    return deleted;
  }
}
