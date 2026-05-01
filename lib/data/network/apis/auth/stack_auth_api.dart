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

  /// Builds the absolute URL the user agent must visit to start Stack Auth's
  /// Google OAuth (PKCE) flow. We hand this URL to the in-app browser; Stack
  /// Auth then 302-chains through Google and back to [redirectUri].
  String buildGoogleAuthorizeUrl({
    required String clientId,
    required String publishableClientKey,
    required String redirectUri,
    required String state,
    required String codeChallenge,
    required String errorRedirectUri,
  }) {
    // NOTE: Stack Auth's authorize endpoint validates query params against a
    // strict allow-list — passing standard Google OAuth params like
    // `prompt=select_account` triggers a SCHEMA_ERROR. Account-switch UX is
    // therefore implemented entirely on the client side by clearing the
    // WebView's cookies/storage before the next authorize navigation.
    final base = Uri.parse(_dio.options.baseUrl);
    return base
        .replace(
          path: Endpoints.authOauthAuthorizeGoogle,
          queryParameters: <String, String>{
            'client_id': clientId,
            'client_secret': publishableClientKey,
            'redirect_uri': redirectUri,
            'response_type': 'code',
            'scope': 'legacy',
            'grant_type': 'authorization_code',
            'state': state,
            'code_challenge': codeChallenge,
            'code_challenge_method': 'S256',
            'type': 'authenticate',
            'error_redirect_url': errorRedirectUri,
          },
        )
        .toString();
  }

  /// Exchanges the OAuth `code` returned via the redirect callback for a
  /// session payload (same shape as the OTP `sign-in` response → consumable
  /// by [AuthSession.fromJson]).
  Future<Map<String, dynamic>> exchangeOAuthCode({
    required String code,
    required String redirectUri,
    required String clientId,
    required String publishableClientKey,
    required String codeVerifier,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.authOauthToken,
      data: <String, String>{
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
        'client_id': clientId,
        'client_secret': publishableClientKey,
        'code_verifier': codeVerifier,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        extra: const <String, dynamic>{'skipRefresh': true},
      ),
    );
    return response.data ?? <String, dynamic>{};
  }
}
