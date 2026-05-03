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
      if (isAiAgentOrPlayground) {
        debugPrint('[AuthInterceptor] bearer token: $token');
      }
    } else if (isAiAgentOrPlayground) {
      debugPrint('[AuthInterceptor] bearer token is empty');
    }

    super.onRequest(options, handler);
  }
}
