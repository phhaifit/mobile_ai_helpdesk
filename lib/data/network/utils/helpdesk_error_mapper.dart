import 'package:ai_helpdesk/core/data/network/exceptions/network_exceptions.dart';
import 'package:ai_helpdesk/core/domain/error/api_failure.dart';
import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:dio/dio.dart';

/// Maps Helpdesk API `DioException`s into typed [Failure]s using the backend
/// error contract documented in `API_Error_Response`.
///
/// Parsing rules (must-haves):
/// - Always decide by HTTP status code first, then refine by backend strings.
/// - Never surface raw backend message for 5xx.
class HelpdeskErrorMapper {
  const HelpdeskErrorMapper._();

  static Failure map(DioException err) {
    // Non-HTTP / connectivity errors: keep existing mapping.
    if (err.type != DioExceptionType.badResponse) {
      return NetworkExceptions.getDioException(err);
    }

    final int http = err.response?.statusCode ?? 0;
    final dynamic data = err.response?.data;

    final Map<String, dynamic> body =
        data is Map<String, dynamic> ? data : const <String, dynamic>{};

    final String status = (body['status'] is String) ? body['status'] as String : '';
    final String code = (body['code'] is String) ? body['code'] as String : '';
    final String message =
        (body['message'] is String) ? body['message'] as String : '';
    // final dynamic details = body['details'];  // Chi tiết bổ sung (chỉ có khi BE ném kèm details)

    // ----- 401: Auth -----
    if (http == 401) {
      if (status == 'TOKEN_EXPIRED') {
        return ApiFailure(
          kind: ApiErrorKind.tokenExpired,
        );
      }
      return ApiFailure(
        kind: ApiErrorKind.unauthenticated,
      );
    }

    // ----- 403: Permission / Subscription -----
    if (http == 403) {
      if (code == 'SUBSCRIPTION_REQUIRED') {
        return ApiFailure(
          kind: ApiErrorKind.subscriptionRequired,
          safeMessage: message.isNotEmpty ? message : null,
        );
      }
      return ApiFailure(
        kind: ApiErrorKind.forbidden,
        safeMessage: message.isNotEmpty ? message : null,
      );
    }

    // ----- 400: Validation -----
    if (http == 400) {
      if (status == 'INVALID_INPUT') {
        return ApiFailure(
          kind: ApiErrorKind.invalidInput,
          safeMessage: message.isNotEmpty ? message : null,
        );
      }
      if (status == 'EXISTED') {
        return ApiFailure(
          kind: ApiErrorKind.duplicate,
          safeMessage: message.isNotEmpty ? message : null,
        );
      }
      return ApiFailure(
        kind: ApiErrorKind.badRequest,
        safeMessage: message.isNotEmpty ? message : null,
      );
    }

    // ----- 404 -----
    if (http == 404) {
      return ApiFailure(
        kind: ApiErrorKind.notFound,
        safeMessage: message.isNotEmpty ? message : null,
      );
    }

    // ----- 409 -----
    if (http == 409) {
      return ApiFailure(
        kind: ApiErrorKind.conflict,
        safeMessage: message.isNotEmpty ? message : null,
      );
    }

    // ----- 422 -----
    if (http == 422) {
      return ApiFailure(
        kind: ApiErrorKind.validationFailed,
        safeMessage: message.isNotEmpty ? message : null,
      );
    }

    // ----- 429 -----
    if (http == 429) {
      return ApiFailure(
        kind: ApiErrorKind.rateLimited,
      );
    }

    // ----- 5xx: do not show message from backend -----
    if (http >= 500) {
      return ApiFailure(
        kind: ApiErrorKind.serverError,
      );
    }

    // ----- Unknown -----
    return ApiFailure(
      kind: ApiErrorKind.unknown,
      safeMessage: http >= 400 && http < 500 && message.isNotEmpty ? message : null,
    );
  }
}

