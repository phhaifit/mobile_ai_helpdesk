import 'package:dio/dio.dart';

/// Injects the Stack Auth project-level headers on every request to
/// `auth-api.jarvis.cx`. These are constant per project and independent of
/// the signed-in user.
class StackHeadersInterceptor extends Interceptor {
  final String projectId;
  final String publishableClientKey;
  final String accessType;

  StackHeadersInterceptor({
    required this.projectId,
    required this.publishableClientKey,
    this.accessType = 'client',
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers
      ..putIfAbsent('X-Stack-Publishable-Client-Key', () => publishableClientKey)
      ..putIfAbsent('x-stack-project-id', () => projectId)
      ..putIfAbsent('x-stack-access-type', () => accessType);
    handler.next(options);
  }
}
