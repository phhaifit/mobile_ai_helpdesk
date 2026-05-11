import 'dart:io';

import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/apis/api_response_parser.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/domain/entity/team_member/team_member.dart';
import 'package:ai_helpdesk/domain/entity/permission/permission.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

/// Calls against the Helpdesk API — bearer + tenantID are injected by
/// interceptors on the helpdesk Dio client.
class AccountApi {
  final DioClient _client;

  AccountApi(this._client);

  Dio get _dio => _client.dio;

  /// SSO validation: fetches the logged-in account (including `tenantID`).
  /// Marked `skipTenant` because tenantID is unknown until this call succeeds.
  Future<Map<String, dynamic>> ssoValidate() async {
    final response = await _dio.get<Map<String, dynamic>>(
      Endpoints.accountSsoValidate,
      options: Options(extra: const <String, dynamic>{'skipTenant': true}),
    );
    return response.data ?? <String, dynamic>{};
  }

  /// Returns the tenant-scoped employee list from `/api/account`.
  /// The helpdesk Dio client injects `tenantID` via interceptor.
  Future<List<TeamMember>> getTenantMembers() async {
    final response = await _dio.get(Endpoints.accountList);
    final items = ApiResponseParser.asMapList(response.data);
    // The Helpdesk `/api/account` response uses different field names and
    // conventions than our `TeamMember` model (e.g. `accountID`, `tenantID`,
    // uppercase role values, `fullname`, `profilePicture`, `isBlocked`).
    // Map each raw item into a `TeamMember` with the expected fields.
    return items.map((item) {
      final id = (item['accountID'] ?? item['accountId'] ?? item['id']) as String?;
      final tenantId = (item['tenantID'] ?? item['tenantId'] ?? '') as String?;
      final email = (item['email'] ?? '') as String;
      final displayName = (item['fullname'] ?? item['displayName']) as String?;
      final roleRaw = (item['role'] ?? '') as String? ?? '';
      final roleStr = roleRaw.toLowerCase();
      final role = roleStr == 'admin' || roleStr == 'administrator'
          ? TeamRole.admin
          : TeamRole.customer_support;
      // API doesn't return permission objects — populate an empty list here.
      final permissions = <dynamic>[];
      final isBlocked = item['isBlocked'];
      final isActive = isBlocked is bool ? !isBlocked : true;
      final createdAtRaw = item['createdAt'] ?? item['created_at'];
      final createdAt = createdAtRaw is String
          ? DateTime.parse(createdAtRaw)
          : DateTime.now();
      final phoneNumber = (item['phoneNumber'] ?? item['phone']) as String?;
      final avatarUrl = (item['profilePicture'] ?? item['avatarUrl']) as String? ?? '';

      return TeamMember(
        id: id ?? '',
        tenantId: tenantId ?? '',
        email: email,
        displayName: (displayName != null && displayName.isNotEmpty)
            ? displayName
            : null,
        role: role,
        permissions: List<Permission>.from(
            permissions.whereType<Map<String, dynamic>>().map(Permission.fromJson)),
        isActive: isActive,
        createdAt: createdAt,
        phoneNumber: (phoneNumber != null && phoneNumber.isNotEmpty)
            ? phoneNumber
            : null,
        avatarUrl: avatarUrl,
      );
    }).toList(growable: false);
  }

  /// The Helpdesk API uses POST (not PATCH) for profile updates — `curl
  /// --data-raw` in the spec defaults to POST.
  Future<Map<String, dynamic>> updateMe(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.accountMe,
      data: body,
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> uploadAvatar(File file) async {
    final form = FormData.fromMap(<String, dynamic>{
      'avatar': await MultipartFile.fromFile(
        file.path,
        filename: p.basename(file.path),
      ),
    });
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.accountAvatar,
      data: form,
    );
    return response.data ?? <String, dynamic>{};
  }
}
