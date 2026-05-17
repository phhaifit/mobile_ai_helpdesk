import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptor extends Interceptor {
  final AsyncValueGetter<String?> accessToken;

  AuthInterceptor({
    required this.accessToken,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String token = await accessToken() ?? '';
    final isAiAgentOrPlayground =
        options.path.contains('/api/v1/ai-agents/');
    if (token.isNotEmpty) {
      options.headers.putIfAbsent('Authorization', () => 'Bearer $token');
      // AI-Services routes also require x-access-token (forwarded by BE).
      options.headers.putIfAbsent('x-access-token', () => token);
      if (isAiAgentOrPlayground) {
        debugPrint('[AuthInterceptor] bearer token: $token');
      }
    } else if (isAiAgentOrPlayground) {
      debugPrint('[AuthInterceptor] bearer token is empty');
    }

    super.onRequest(options, handler);
  }
}
