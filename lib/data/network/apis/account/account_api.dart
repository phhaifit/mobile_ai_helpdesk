import 'dart:io';

import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
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
