import '/core/data/network/dio/dio_client.dart';
import '/data/network/apis/api_response_parser.dart';
import '/data/network/constants/endpoints.dart';
import '/domain/entity/team_member/team_member.dart';

class TeamApi {
  TeamApi(this._dioClient);

  final DioClient _dioClient;

  Future<List<TeamMember>> getMembers(String tenantId) async {
    final response = await _dioClient.dio.get(Endpoints.tenantMembers(tenantId));
    final items = ApiResponseParser.asMapList(response.data);
    return items.map(TeamMember.fromJson).toList(growable: false);
  }

  Future<TeamMember> getMemberById({
    required String tenantId,
    required String memberId,
  }) async {
    final response = await _dioClient.dio.get(
      Endpoints.tenantMember(tenantId, memberId),
    );
    return TeamMember.fromJson(ApiResponseParser.asMap(response.data));
  }

  Future<TeamMember> createMember(TeamMember member) async {
    final response = await _dioClient.dio.post(
      Endpoints.tenantMembers(member.tenantId),
      data: member.toJson(),
    );
    return TeamMember.fromJson(ApiResponseParser.asMap(response.data));
  }

  Future<TeamMember> updateMember(TeamMember member) async {
    final payload = <String, dynamic>{
      'role': member.role.name,
      'displayName': member.displayName,
      'phoneNumber': member.phoneNumber,
      'avatarUrl': member.avatarUrl,
      'permissions': member.permissions.map((permission) => permission.toJson()).toList(),
    };
    final response = await _dioClient.dio.patch(
      Endpoints.tenantMember(member.tenantId, member.id),
      data: payload,
    );
    return TeamMember.fromJson(ApiResponseParser.asMap(response.data));
  }

  Future<bool> deleteMember({
    required String tenantId,
    required String memberId,
  }) async {
    final response = await _dioClient.dio.delete(
      Endpoints.tenantMember(tenantId, memberId),
    );
    return ApiResponseParser.asDeleteSuccess(response.data);
  }
}
