import 'package:ai_helpdesk/core/domain/error/failure.dart';

/// Typed API error kinds for Helpdesk backend.
///
/// Important: Always determine the kind by HTTP status code first, then
/// refine by backend `status`/`code` fields.
enum ApiErrorKind {
  tokenExpired,
  unauthenticated,
  forbidden,
  subscriptionRequired,
  invalidInput,
  duplicate,
  badRequest,
  notFound,
  conflict,
  validationFailed,
  rateLimited,
  serverError,
  unknown,
}

/// Failure produced from Helpdesk API errors.
///
/// - For **4xx** errors, [safeMessage] can surface backend Vietnamese messages.
/// - For **5xx** errors, [safeMessage] must be null and UI should show a safe
///   generic fallback (avoid leaking internal stack/DB details).
class ApiFailure extends Failure {
  final ApiErrorKind kind;
  final String? safeMessage;

  ApiFailure({
    required this.kind,
    this.safeMessage,
  }) : super(safeMessage ?? _defaultMessageFor(kind));

  static String _defaultMessageFor(ApiErrorKind kind) {
    switch (kind) {
      case ApiErrorKind.tokenExpired:
        return 'auth_error_session_expired';
      case ApiErrorKind.unauthenticated:
        return 'auth_error_unauthorized';
      case ApiErrorKind.forbidden:
        return 'common_error_forbidden';
      case ApiErrorKind.subscriptionRequired:
        return 'common_error_subscription_required';
      case ApiErrorKind.conflict:
        return 'common_error_conflict';
      case ApiErrorKind.rateLimited:
        return 'common_error_rate_limited';
      case ApiErrorKind.serverError:
        return 'common_error_server';
      case ApiErrorKind.invalidInput:
      case ApiErrorKind.duplicate:
      case ApiErrorKind.badRequest:
      case ApiErrorKind.notFound:
      case ApiErrorKind.validationFailed:
      case ApiErrorKind.unknown:
        return 'common_error_unknown';
    }
  }
}

