import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:dio/dio.dart';

/// Thin wrapper around the Stack Auth REST API. Throws raw [DioException]s;
/// the repository is responsible for mapping those into typed failures.
class StackAuthApi {
  final DioClient _client;

  StackAuthApi(this._client);

  Dio get _dio => _client.dio;

  /// Sends a one-time code to the given email and returns the server nonce.
  Future<Map<String, dynamic>> sendSignInCode({
    required String email,
    required String callbackUrl,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.authSendSignInCode,
      data: <String, dynamic>{
        'email': email,
        'callback_url': callbackUrl,
      },
    );
    return response.data ?? <String, dynamic>{};
  }

  /// Exchanges `code.toLowerCase() + nonce` for a session payload.
  Future<Map<String, dynamic>> signInWithCode({
    required String concatenatedCode,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.authOtpSignIn,
      data: <String, dynamic>{'code': concatenatedCode},
    );
    return response.data ?? <String, dynamic>{};
  }

  /// Rotates the access token. Must be called with a non-empty refresh token.
  /// Marked as `skipRefresh` so it cannot accidentally recurse through the
  /// 401-handling interceptor on the helpdesk client.
  Future<Map<String, dynamic>> refreshSession({
    required String refreshToken,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.authRefreshSession,
      options: Options(
        headers: <String, dynamic>{'x-stack-refresh-token': refreshToken},
        extra: const <String, dynamic>{'skipRefresh': true},
      ),
    );
    return response.data ?? <String, dynamic>{};
  }

  /// Invalidates the current session on the backend.
  Future<void> signOutCurrent({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _dio.delete<void>(
      Endpoints.authCurrentSession,
      options: Options(
        headers: <String, dynamic>{
          'Authorization': 'Bearer $accessToken',
          'x-stack-refresh-token': refreshToken,
        },
        extra: const <String, dynamic>{'skipRefresh': true},
      ),
    );
  }
}
