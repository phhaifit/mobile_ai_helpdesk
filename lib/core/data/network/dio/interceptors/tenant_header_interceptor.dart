import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Attaches the `tenantID` header required by every non-auth Helpdesk
/// endpoint once the user has signed in. Callers may override per-request
/// via `options.extra['skipTenant'] = true`.
class TenantHeaderInterceptor extends Interceptor {
  final AsyncValueGetter<String?> tenantId;

  TenantHeaderInterceptor({required this.tenantId});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipTenant'] == true) {
      return handler.next(options);
    }
    final id = await tenantId();
    if (id != null && id.isNotEmpty) {
      options.headers.putIfAbsent('tenantID', () => id);
    }
    handler.next(options);
  }
}
