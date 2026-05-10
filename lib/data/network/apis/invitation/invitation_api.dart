import '/core/data/network/dio/dio_client.dart';
import '/data/network/apis/api_response_parser.dart';
import '/data/network/constants/endpoints.dart';
import '/domain/entity/invitation/invitation.dart';
import '/domain/entity/team_member/team_member.dart';

class InvitationApi {
  InvitationApi(this._dioClient);

  final DioClient _dioClient;

  /// Fetches invitations for the current user account (not tenant-specific).
  Future<List<Invitation>> getAccountInvitations() async {
    final response = await _dioClient.dio.get(Endpoints.invitations());
    final items = ApiResponseParser.asMapList(response.data);
    return items.map(Invitation.fromJson).toList(growable: false);
  }

  /// Fetches invitations for the current tenant.
  /// tenantId is injected via TenantHeaderInterceptor.
  Future<List<Invitation>> getInvitations(String tenantId) async {
    final response = await _dioClient.dio.get(Endpoints.invitations());
    final items = ApiResponseParser.asMapList(response.data);
    return items.map(Invitation.fromJson).toList(growable: false);
  }

  /// Sends an invitation to a new team member.
  /// tenantId is injected via TenantHeaderInterceptor.
  Future<Invitation> inviteMember({
    required String tenantId,
    required String email,
    required TeamRole role,
    required String invitedByMemberId,
  }) async {
    final response = await _dioClient.dio.post(
      Endpoints.sendInvitation(),
      data: {
        'email': email,
        'role': role.name.toUpperCase(),
        'channelIDs': <String>[],
      },
    );
    return Invitation.fromJson(ApiResponseParser.asMap(response.data));
  }

  /// Resends an invitation.
  /// tenantId is injected via TenantHeaderInterceptor (optional parameter kept for compatibility).
  Future<Invitation> resendInvitation(
    String invitationId, {
    String? tenantId,
  }) async {
    final response = await _dioClient.dio.post(
      Endpoints.resendInvitation(),
      data: <String, dynamic>{'invitationID': invitationId},
    );
    return Invitation.fromJson(ApiResponseParser.asMap(response.data));
  }

  /// Accepts an invitation.
  /// tenantId is injected via TenantHeaderInterceptor (optional parameter kept for compatibility).
  Future<Invitation> acceptInvitation(
    String invitationId, {
    String? tenantId,
  }) async {
    final response = await _dioClient.dio.post(
      Endpoints.acceptInvitation(),
      data: <String, dynamic>{'invitationID': invitationId},
    );
    return Invitation.fromJson(ApiResponseParser.asMap(response.data));
  }

  /// Declines an invitation.
  /// tenantId is injected via TenantHeaderInterceptor (optional parameter kept for compatibility).
  Future<Invitation> declineInvitation(
    String invitationId, {
    String? tenantId,
  }) async {
    final response = await _dioClient.dio.post(
      Endpoints.declineInvitation(),
      data: <String, dynamic>{'invitationID': invitationId},
    );
    return Invitation.fromJson(ApiResponseParser.asMap(response.data));
  }

  /// Deletes an invitation.
  Future<bool> deleteInvitation(String invitationId) async {
    final response = await _dioClient.dio.delete(
      Endpoints.deleteInvitation(invitationId),
    );
    return ApiResponseParser.asDeleteSuccess(response.data);
  }
}
