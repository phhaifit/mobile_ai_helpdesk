import 'dart:async';

import 'package:ai_helpdesk/data/local/auth/auth_local_datasource.dart';
import 'package:ai_helpdesk/data/network/apis/auth/auth_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Intercepts 401 responses and attempts to refresh the access token.
///
/// If refresh succeeds the original request is retried transparently.
/// If refresh fails all queued requests are rejected and the local session is
/// cleared (forcing a re-login through the UI layer).
class TokenRefreshInterceptor extends QueuedInterceptor {
  final AuthApi _authApi;
  final AuthLocalDatasource _localDatasource;
  final Dio _retryDio;

  bool _isRefreshing = false;

  TokenRefreshInterceptor({
    required AuthApi authApi,
    required AuthLocalDatasource localDatasource,
    required Dio retryDio,
  })  : _authApi = authApi,
        _localDatasource = localDatasource,
        _retryDio = retryDio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return super.onError(err, handler);
    }

    // Avoid infinite refresh loops.
    if (_isRefreshing) {
      return super.onError(err, handler);
    }

    try {
      _isRefreshing = true;

      final storedRefreshToken = await _localDatasource.getRefreshToken();
      if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
        await _forceLogout();
        return super.onError(err, handler);
      }

      // Call the refresh endpoint.
      final result = await _authApi.refreshToken(storedRefreshToken);
      final newAccessToken = result['access_token'] as String?;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        await _forceLogout();
        return super.onError(err, handler);
      }

      // Persist the new access token.
      await _localDatasource.saveAuthToken(newAccessToken);

      debugPrint('[TokenRefreshInterceptor] Token refreshed successfully');

      // Retry the original request with the new token.
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newAccessToken';

      final response = await _retryDio.fetch(opts);
      return handler.resolve(response);
    } on DioException catch (refreshError) {
      debugPrint(
        '[TokenRefreshInterceptor] Refresh failed: ${refreshError.message}',
      );
      await _forceLogout();
      return super.onError(err, handler);
    } catch (e) {
      debugPrint('[TokenRefreshInterceptor] Unexpected error: $e');
      await _forceLogout();
      return super.onError(err, handler);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _forceLogout() async {
    try {
      await _localDatasource.clearAllAuthData();
      debugPrint('[TokenRefreshInterceptor] Session cleared — user must login');
    } catch (_) {}
  }
}
