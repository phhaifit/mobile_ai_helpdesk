import '/core/data/network/dio/dio_client.dart';
import '/data/network/apis/api_response_parser.dart';
import '/data/network/constants/endpoints.dart';
import '/domain/entity/invitation/invitation.dart';
import '/domain/entity/team_member/team_member.dart';

class InvitationApi {
  InvitationApi(this._dioClient);

  final DioClient _dioClient;

  Future<List<Invitation>> getInvitations(String tenantId) async {
    final response = await _dioClient.dio.get(Endpoints.tenantInvitations(tenantId));
    final items = ApiResponseParser.asMapList(response.data);
    return items.map(Invitation.fromJson).toList(growable: false);
  }

  Future<Invitation> inviteMember({
    required String tenantId,
    required String email,
    required TeamRole role,
    required String invitedByMemberId,
  }) async {
    final response = await _dioClient.dio.post(
      Endpoints.tenantInvitations(tenantId),
      data: {
        'email': email,
        'role': role.name,
        'invitedByMemberId': invitedByMemberId,
      },
    );
    return Invitation.fromJson(ApiResponseParser.asMap(response.data));
  }

  Future<Invitation> resendInvitation(String invitationId) async {
    final response = await _dioClient.dio.post(
      Endpoints.resendInvitation(invitationId),
    );
    return Invitation.fromJson(ApiResponseParser.asMap(response.data));
  }

  Future<Invitation> acceptInvitation(String invitationId) async {
    final response = await _dioClient.dio.post(
      Endpoints.acceptInvitation(invitationId),
    );
    return Invitation.fromJson(ApiResponseParser.asMap(response.data));
  }

  Future<Invitation> declineInvitation(String invitationId) async {
    final response = await _dioClient.dio.post(
      Endpoints.declineInvitation(invitationId),
    );
    return Invitation.fromJson(ApiResponseParser.asMap(response.data));
  }
}
