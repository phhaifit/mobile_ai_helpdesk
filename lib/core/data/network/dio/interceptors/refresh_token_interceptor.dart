import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Refresh-on-401 for the Helpdesk Dio client.
///
/// Invariants:
///   * The refresh call itself does not pass through this interceptor — it
///     targets the Stack Auth host via a different [Dio] instance.
///   * A request is retried at most once (`extra['retried']`).
///   * Requests that opt out (`extra['skipRefresh']`) are forwarded as-is.
///   * Concurrent 401s share a single refresh call via a [Completer] mutex.
///   * If the refresh fails, `onRefreshFailed` fires once and queued waiters
///     receive the original 401 — they are never retried with a stale token.
class RefreshTokenInterceptor extends Interceptor {
  /// Performs a refresh and returns the new access token, or `null` on any
  /// failure (expired/revoked refresh token, network error, …).
  final Future<String?> Function() refresh;

  /// Called exactly once per failed refresh cycle so the app can clear local
  /// state and route the user back to sign-in.
  final VoidCallback onRefreshFailed;

  /// Lazy accessor for the helpdesk Dio (to retry the original request).
  final Dio Function() dio;

  Completer<void>? _inFlight;

  RefreshTokenInterceptor({
    required this.refresh,
    required this.onRefreshFailed,
    required this.dio,
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final options = err.requestOptions;

    if (statusCode != 401 ||
        options.extra['skipRefresh'] == true ||
        options.extra['retried'] == true) {
      return handler.next(err);
    }

    // Wait for an in-flight refresh, or kick one off.
    final inFlight = _inFlight;
    if (inFlight != null) {
      try {
        await inFlight.future;
      } catch (_) {
        return handler.next(err);
      }
    } else {
      final completer = Completer<void>();
      _inFlight = completer;
      try {
        final newToken = await refresh();
        if (newToken == null || newToken.isEmpty) {
          throw StateError('refresh_failed');
        }
        completer.complete();
      } catch (error, stack) {
        completer.completeError(error, stack);
        _inFlight = null;
        onRefreshFailed();
        return handler.next(err);
      }
      _inFlight = null;
    }

    // Retry the original request exactly once with the freshly rotated token.
    try {
      options.extra['retried'] = true;
      // Let AuthInterceptor re-inject the bearer; strip the stale one first.
      options.headers.remove('Authorization');
      final retried = await dio().fetch<dynamic>(options);
      return handler.resolve(retried);
    } on DioException catch (retryErr) {
      return handler.next(retryErr);
    }
  }
}
