import 'dart:convert';

import 'package:ai_helpdesk/data/models/auth/change_password_request.dart';
import 'package:ai_helpdesk/data/models/auth/login_request.dart';
import 'package:ai_helpdesk/data/models/auth/register_request.dart';
import 'package:ai_helpdesk/data/models/auth/reset_password_request.dart';
import 'package:ai_helpdesk/data/network/apis/auth/auth_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Real implementation of [AuthApi].
///
/// All 5 real auth endpoints go through the Apidog web proxy at
/// `https://web-proxy.apidog.com/api/v1/request` because calling
/// `auth-api.jarvis.cx` / `api.jarvis.cx` directly always times out.
///
/// The 5 stub endpoints (changePassword, forgotPassword, resetPassword,
/// updateProfile, uploadAvatar) return mock data.
class RealAuthApi implements AuthApi {
  // ignore: unused_field
  final Dio _authDio;
  // ignore: unused_field
  final Dio _apiDio;

  /// Standalone Dio — no interceptors, no base URL.
  final Dio _dio = Dio();

  static const _proxy = 'https://web-proxy.apidog.com/api/v1/request';

  static const _stackH0Base =
      'X-Stack-Access-Type=client, '
      'X-Stack-Project-Id=45a1e2fd-77ee-4872-9fb7-987b8c119633, '
      'X-Stack-Publishable-Client-Key=pck_7wjweasxxnfspvr20dvmyd9pjj0p9kp755bxxcm4ae1er, '
      'User-Agent=Apidog/1.0.0 (https://apidog.com), '
      'Content-Type=application/json, '
      'Accept=*/*, '
      'Cache-Control=no-cache, '
      'Host=auth-api.jarvis.cx, '
      'Accept-Encoding=gzip%2C deflate%2C br, '
      'Connection=keep-alive';

  RealAuthApi({required Dio authDio, required Dio apiDio})
      : _authDio = authDio,
        _apiDio = apiDio;

  /// The proxy may return data as a raw JSON string instead of a parsed Map.
  /// Also checks for API-level errors (proxy returns 200 even on API errors).
  Map<String, dynamic> _parseResponse(dynamic data) {
    Map<String, dynamic> map;
    if (data is Map) {
      map = Map<String, dynamic>.from(data);
    } else if (data is String) {
      map = Map<String, dynamic>.from(jsonDecode(data) as Map);
    } else {
      throw FormatException('Unexpected response type: ${data.runtimeType}');
    }

    // The proxy always returns HTTP 200. Detect real API errors by checking
    // for the `code` field that Stack Auth includes in every error response.
    if (map.containsKey('code') && map.containsKey('error')) {
      final code = map['code'] as String;
      final error = map['error'] as String;
      throw Exception(_friendlyError(code, error));
    }

    return map;
  }

  /// Map Stack Auth error codes to user-friendly messages.
  static String _friendlyError(String code, String fallback) {
    switch (code) {
      case 'EMAIL_PASSWORD_MISMATCH':
        return 'Wrong email or password.';
      case 'USER_EMAIL_ALREADY_EXISTS':
        return 'An account with this email already exists.';
      case 'USER_NOT_FOUND':
        return 'No account found with this email.';
      case 'PASSWORD_TOO_SHORT':
        return 'Password is too short. Use at least 8 characters.';
      case 'PASSWORD_TOO_LONG':
        return 'Password is too long.';
      case 'EMAIL_VERIFICATION_REQUIRED':
        return 'Please verify your email before signing in.';
      case 'REFRESH_TOKEN_NOT_FOUND_OR_EXPIRED':
        return 'Session expired. Please sign in again.';
      default:
        return fallback;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Real endpoints — via web-proxy.apidog.com
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Future<Map<String, dynamic>> login(LoginRequest request) async {
    final response = await _dio.post(
      _proxy,
      data: {
        'email': request.email,
        'password': request.password,
      },
      options: Options(
        headers: {
          'accept': '*/*',
          'api-h0': _stackH0Base,
          'api-o0':
              'method=POST, timings=true, timeout=300000, rejectUnauthorized=false, followRedirect=true',
          'api-u':
              'https://auth-api.jarvis.cx/api/v1/auth/password/sign-in',
          'authorization': 'anonymous',
          'content-type': 'application/json',
          'origin': 'https://share.apidog.com',
          'referer': 'https://share.apidog.com/',
        },
      ),
    );
    debugPrint('[RealAuthApi] login response type: ${response.data.runtimeType}');
    debugPrint('[RealAuthApi] login response data: ${response.data}');
    return _parseResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> register(RegisterRequest request) async {
    final response = await _dio.post(
      _proxy,
      data: {
        'email': request.email,
        'password': request.password,
        'verification_callback_url':
            'https://auth.jarvis.cx/handler/email-verification?after_auth_return_to=%2Fauth%2Fsignin%3Fclient_id%3Djarvis_chat%26redirect%3Dhttps%253A%252F%252Fchat.jarvis.cx%252Fauth%252Foauth%252Fsuccess',
      },
      options: Options(
        headers: {
          'accept': '*/*',
          'api-h0': _stackH0Base,
          'api-o0':
              'method=POST, timings=true, timeout=300000, rejectUnauthorized=false, followRedirect=true',
          'api-u':
              'https://auth-api.jarvis.cx/api/v1/auth/password/sign-up',
          'authorization': 'anonymous',
          'content-type': 'application/json',
          'origin': 'https://share.apidog.com',
          'referer': 'https://share.apidog.com/',
        },
      ),
    );
    return _parseResponse(response.data);
  }

  @override
  Future<Map<String, dynamic>> getCurrentUser(String accessToken) async {
    final response = await _dio.post(
      _proxy,
      options: Options(
        headers: {
          'accept': '*/*',
          'api-h0':
              'Authorization=Bearer $accessToken, '
              'User-Agent=Apidog/1.0.0 (https://apidog.com), '
              'Accept=*/*, '
              'Cache-Control=no-cache, '
              'Host=api.jarvis.cx, '
              'Accept-Encoding=gzip%2C deflate%2C br, '
              'Connection=keep-alive',
          'api-o0':
              'method=GET, timings=true, timeout=300000, rejectUnauthorized=false, followRedirect=true',
          'api-u': 'https://api.jarvis.cx/api/v1/auth/me',
          'authorization': 'anonymous',
          'content-type': 'application/json',
          'content-length': '0',
          'origin': 'https://share.apidog.com',
          'referer': 'https://share.apidog.com/',
        },
      ),
    );
    return _parseResponse(response.data);
  }

  @override
  Future<void> logout(String accessToken, String refreshToken) async {
    await _dio.post(
      _proxy,
      data: {},
      options: Options(
        headers: {
          'accept': '*/*',
          'api-h0':
              'Authorization=Bearer $accessToken, '
              '$_stackH0Base, '
              'X-Stack-Refresh-Token=$refreshToken',
          'api-o0':
              'method=DELETE, timings=true, timeout=300000, rejectUnauthorized=false, followRedirect=true',
          'api-u':
              'https://auth-api.jarvis.cx/api/v1/auth/sessions/current',
          'authorization': 'anonymous',
          'content-type': 'application/json',
          'origin': 'https://share.apidog.com',
          'referer': 'https://share.apidog.com/',
        },
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      _proxy,
      options: Options(
        headers: {
          'accept': '*/*',
          'api-h0':
              '$_stackH0Base, '
              'X-Stack-Refresh-Token=$refreshToken',
          'api-o0':
              'method=POST, timings=true, timeout=300000, rejectUnauthorized=false, followRedirect=true',
          'api-u':
              'https://auth-api.jarvis.cx/api/v1/auth/sessions/current/refresh',
          'authorization': 'anonymous',
          'content-type': 'application/json',
          'content-length': '0',
          'origin': 'https://share.apidog.com',
          'referer': 'https://share.apidog.com/',
        },
      ),
    );
    return _parseResponse(response.data);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Stub endpoints — replace method bodies when real APIs are available.
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Future<void> changePassword(
    ChangePasswordRequest request,
    String accessToken,
  ) async {
    // TODO: Replace with real API call:
    //   await _apiDio.post(Endpoints.changePassword,
    //     data: request.toJson(),
    //     options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    //   );
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('[RealAuthApi] changePassword — stub (mock)');
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    // TODO: Replace with real API call:
    //   await _apiDio.post(Endpoints.forgotPassword, data: {'email': email});
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('[RealAuthApi] requestPasswordReset — stub (mock)');
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    // TODO: Replace with real API call:
    //   await _apiDio.post(Endpoints.resetPassword, data: request.toJson());
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('[RealAuthApi] resetPassword — stub (mock)');
  }

  @override
  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> fields,
    String accessToken,
  ) async {
    // TODO: Replace with real API call:
    //   final response = await _apiDio.patch(Endpoints.updateProfile,
    //     data: fields,
    //     options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    //   );
    //   return Map<String, dynamic>.from(response.data as Map);
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('[RealAuthApi] updateProfile — stub (mock)');
    return fields;
  }

  @override
  Future<Map<String, dynamic>> uploadAvatar(
    String filePath,
    String accessToken,
  ) async {
    // TODO: Replace with real API call:
    //   final formData = FormData.fromMap({
    //     'avatar': await MultipartFile.fromFile(filePath),
    //   });
    //   final response = await _apiDio.post(Endpoints.uploadAvatar,
    //     data: formData,
    //     options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    //   );
    //   return Map<String, dynamic>.from(response.data as Map);
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('[RealAuthApi] uploadAvatar — stub (mock)');
    return {'avatar': 'https://via.placeholder.com/150'};
  }
}
