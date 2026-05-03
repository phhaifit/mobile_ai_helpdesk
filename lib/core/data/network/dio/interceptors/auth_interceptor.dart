import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptor extends Interceptor {
  final AsyncValueGetter<String?> accessToken;
  final AsyncValueGetter<String?> tenantId;

  AuthInterceptor({
    required this.accessToken,
    required this.tenantId,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String token = await accessToken() ?? '';
    if (token.isNotEmpty) {
      options.headers.putIfAbsent('Authorization', () => 'Bearer $token');
    }

    final String tenant = await tenantId() ?? '';
    if (tenant.isNotEmpty) {
      options.headers.putIfAbsent('X-Tenant-Id', () => tenant);
    }

    super.onRequest(options, handler);
  }
}
