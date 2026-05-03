import 'package:ai_helpdesk/core/data/network/exceptions/network_exceptions.dart';
import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_failure.dart';
import 'package:dio/dio.dart';

/// Maps a `DioException` coming from Stack Auth or Helpdesk API into a typed
/// [Failure]. Recognises the `{code, error, details}` envelope the backend
/// returns on 4xx errors and produces auth-specific failures where
/// appropriate. Everything unknown falls back to [NetworkExceptions].
class StackErrorMapper {
  const StackErrorMapper._();

  static Failure map(DioException error) {
    final response = error.response;
    final data = response?.data;
    final statusCode = response?.statusCode ?? 0;

    if (data is Map<String, dynamic>) {
      final code = data['code'];
      final messageFromBackend = _extractMessage(data);

      if (code is String) {
        switch (code) {
          case 'VERIFICATION_CODE_ALREADY_USED':
            return OtpAlreadyUsedFailure(
              messageFromBackend ??
                  const OtpAlreadyUsedFailure().message,
            );
          case 'VERIFICATION_CODE_NOT_FOUND':
          case 'VERIFICATION_CODE_EXPIRED':
          case 'VERIFICATION_CODE_MAX_ATTEMPTS_REACHED':
            return OtpNotFoundFailure(
              messageFromBackend ?? const OtpNotFoundFailure().message,
            );
          case 'SCHEMA_ERROR':
            return InvalidOtpFormatFailure(
              messageFromBackend ??
                  const InvalidOtpFormatFailure().message,
            );
          case 'REFRESH_TOKEN_NOT_FOUND_OR_EXPIRED':
          case 'ACCESS_TOKEN_EXPIRED':
            return SessionExpiredFailure(
              messageFromBackend ?? const SessionExpiredFailure().message,
            );
          case 'TOO_MANY_REQUESTS':
          case 'RATE_LIMIT_EXCEEDED':
            return RateLimitFailure(
              messageFromBackend ?? const RateLimitFailure().message,
            );
        }
      }

      // Unknown code, but backend returned structured error — surface message.
      if (statusCode == 401) {
        return UnauthorizedFailure(
          messageFromBackend ?? const UnauthorizedFailure().message,
        );
      }
      if (statusCode == 429) {
        return RateLimitFailure(
          messageFromBackend ?? const RateLimitFailure().message,
        );
      }
      if (statusCode >= 500) {
        return ServerFailure(
          messageFromBackend ?? 'common_error_server',
        );
      }
      if (statusCode >= 400) {
        return ValidationFailure(
          messageFromBackend ?? 'common_error_unknown',
        );
      }
    }

    return NetworkExceptions.getDioException(error);
  }

  static String? _extractMessage(Map<String, dynamic> data) {
    final details = data['details'];
    if (details is Map<String, dynamic>) {
      final msg = details['message'];
      if (msg is String && msg.isNotEmpty) return msg;
    }
    final err = data['error'];
    if (err is String && err.isNotEmpty) return err;
    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;
    return null;
  }
}
