import '/core/data/network/dio/dio_client.dart';
import '/data/network/apis/api_response_parser.dart';
import '/data/network/constants/endpoints.dart';
import '/domain/entity/team_member/team_member.dart';

class TeamApi {
  TeamApi(this._dioClient);

  final DioClient _dioClient;

  /// Fetches all team members for the current tenant.
  /// tenantId is injected via TenantHeaderInterceptor.
  Future<List<TeamMember>> getMembers(String tenantId) async {
    final response = await _dioClient.dio.get(Endpoints.members());
    final items = ApiResponseParser.asMapList(response.data);
    return items.map(TeamMember.fromJson).toList(growable: false);
  }

  /// Fetches a specific team member by ID.
  /// tenantId is injected via TenantHeaderInterceptor.
  Future<TeamMember> getMemberById({
    required String tenantId,
    required String memberId,
  }) async {
    final response = await _dioClient.dio.get(
      Endpoints.member(memberId),
    );
    return TeamMember.fromJson(ApiResponseParser.asMap(response.data));
  }

  /// Creates a new team member.
  /// tenantId is injected via TenantHeaderInterceptor.
  Future<TeamMember> createMember(TeamMember member) async {
    final response = await _dioClient.dio.post(
      Endpoints.members(),
      data: member.toJson(),
    );
    return TeamMember.fromJson(ApiResponseParser.asMap(response.data));
  }

  /// Updates an existing team member.
  /// tenantId is injected via TenantHeaderInterceptor.
  Future<TeamMember> updateMember(TeamMember member) async {
    final payload = <String, dynamic>{
      'role': member.role.name,
      'displayName': member.displayName,
      'phoneNumber': member.phoneNumber,
      'avatarUrl': member.avatarUrl,
      'permissions': member.permissions.map((permission) => permission.toJson()).toList(),
    };
    final response = await _dioClient.dio.patch(
      Endpoints.member(member.id),
      data: payload,
    );
    return TeamMember.fromJson(ApiResponseParser.asMap(response.data));
  }

  /// Deletes a team member.
  /// tenantId is injected via TenantHeaderInterceptor.
  Future<bool> deleteMember({
    required String tenantId,
    required String memberId,
  }) async {
    final response = await _dioClient.dio.delete(
      Endpoints.member(memberId),
    );
    return ApiResponseParser.asDeleteSuccess(response.data);
  }
}
