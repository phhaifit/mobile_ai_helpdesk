import '/core/data/network/dio/dio_client.dart';
import '/data/network/apis/api_response_parser.dart';
import '/data/network/constants/endpoints.dart';
import '/domain/entity/invitation/invitation.dart';
import '/domain/entity/team_member/team_member.dart';
import 'package:dio/dio.dart';

class InvitationApi {
  InvitationApi(this._dioClient);

  final DioClient _dioClient;

  Options _tenantOptions(String? tenantId) {
    if (tenantId == null || tenantId.trim().isEmpty) {
      return Options();
    }
    return Options(headers: <String, dynamic>{'tenantID': tenantId});
  }

  Future<List<Invitation>> getAccountInvitations() async {
    final response = await _dioClient.dio.get(Endpoints.invitations());
    final items = ApiResponseParser.asMapList(response.data);
    return items.map(Invitation.fromJson).toList(growable: false);
  }

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
      Endpoints.sendTenantInvitation(),
      data: {
        'email': email,
        'role': role.name.toUpperCase(),
        'channelIDs': <String>[],
      },
    );
    return Invitation.fromJson(ApiResponseParser.asMap(response.data));
  }

  Future<Invitation> resendInvitation(
    String invitationId, {
    String? tenantId,
  }) async {
    final response = await _dioClient.dio.post(
      Endpoints.resendInvitation(),
      options: _tenantOptions(tenantId),
      data: <String, dynamic>{'invitationID': invitationId},
    );
    return Invitation.fromJson(ApiResponseParser.asMap(response.data));
  }

  Future<Invitation> acceptInvitation(
    String invitationId, {
    String? tenantId,
  }) async {
    final response = await _dioClient.dio.post(
      Endpoints.acceptInvitation(),
      options: _tenantOptions(tenantId),
      data: <String, dynamic>{'invitationID': invitationId},
    );
    return Invitation.fromJson(ApiResponseParser.asMap(response.data));
  }

  Future<Invitation> declineInvitation(
    String invitationId, {
    String? tenantId,
  }) async {
    final response = await _dioClient.dio.post(
      Endpoints.declineInvitation(),
      options: _tenantOptions(tenantId),
      data: <String, dynamic>{'invitationID': invitationId},
    );
    return Invitation.fromJson(ApiResponseParser.asMap(response.data));
  }

  Future<bool> deleteInvitation(String invitationId) async {
    final response = await _dioClient.dio.delete(
      Endpoints.deleteInvitation(invitationId),
    );
    return ApiResponseParser.asDeleteSuccess(response.data);
  }
}
