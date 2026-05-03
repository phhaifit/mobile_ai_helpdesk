import 'package:dio/dio.dart';

/// User-friendly exception raised by [KnowledgeRepositoryImpl].
///
/// Stores can match on [code] for typed recovery flows; otherwise [message] is
/// safe to display directly in a snackbar/banner.
class KnowledgeException implements Exception {
  final String message;
  final KnowledgeErrorCode code;
  final Object? cause;

  const KnowledgeException(this.message, this.code, [this.cause]);

  @override
  String toString() => message;

  /// Maps a [DioException] (or any error) to a user-friendly [KnowledgeException].
  factory KnowledgeException.from(Object error) {
    if (error is KnowledgeException) return error;
    if (error is DioException) {
      final status = error.response?.statusCode ?? 0;
      final body = error.response?.data;

      // Try to extract a backend message.
      final backendMsg = _extractMessage(body);

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return KnowledgeException(
          'Kết nối quá chậm. Vui lòng thử lại.',
          KnowledgeErrorCode.timeout,
          error,
        );
      }
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.unknown) {
        return KnowledgeException(
          'Không thể kết nối tới máy chủ. Kiểm tra kết nối mạng.',
          KnowledgeErrorCode.network,
          error,
        );
      }
      if (status == 401 || status == 403) {
        return KnowledgeException(
          backendMsg ?? 'Phiên đăng nhập đã hết hạn.',
          KnowledgeErrorCode.unauthorized,
          error,
        );
      }
      if (status == 404) {
        return KnowledgeException(
          backendMsg ?? 'Không tìm thấy tài nguyên.',
          KnowledgeErrorCode.notFound,
          error,
        );
      }
      if (status == 413) {
        return KnowledgeException(
          backendMsg ?? 'Tệp tải lên vượt quá kích thước cho phép.',
          KnowledgeErrorCode.payloadTooLarge,
          error,
        );
      }
      if (status >= 400 && status < 500) {
        return KnowledgeException(
          backendMsg ?? 'Yêu cầu không hợp lệ.',
          KnowledgeErrorCode.badRequest,
          error,
        );
      }
      if (status >= 500) {
        return KnowledgeException(
          backendMsg ?? 'Máy chủ đang gặp sự cố. Vui lòng thử lại sau.',
          KnowledgeErrorCode.server,
          error,
        );
      }
      return KnowledgeException(
        backendMsg ?? error.message ?? 'Đã xảy ra lỗi.',
        KnowledgeErrorCode.unknown,
        error,
      );
    }
    return KnowledgeException(
      error.toString(),
      KnowledgeErrorCode.unknown,
      error,
    );
  }

  static String? _extractMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      final m = body['message'] ?? body['error'];
      if (m is String && m.isNotEmpty) return m;
      final details = body['details'];
      if (details is Map<String, dynamic>) {
        final dm = details['message'];
        if (dm is String && dm.isNotEmpty) return dm;
      }
    }
    return null;
  }
}

enum KnowledgeErrorCode {
  /// Stack Auth session valid but the user has no tenant assigned on BE.
  /// UI surfaces a dedicated empty state with manual tenant-id entry.
  tenantMissing,
  unauthorized,
  notFound,
  badRequest,
  payloadTooLarge,
  timeout,
  network,
  server,
  unknown,
}
