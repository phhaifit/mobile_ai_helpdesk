import 'package:dio/dio.dart';

import 'package:ai_helpdesk/core/domain/error/failure.dart';

/// Helper class to convert DioExceptions to domain failures
class NetworkExceptions {
  static Failure getDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const NetworkFailure(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.sendTimeout:
        return const NetworkFailure('Send timeout. Please try again.');
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Receive timeout. Please try again.');
      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);
      case DioExceptionType.cancel:
        return const NetworkFailure('Request cancelled.');
      case DioExceptionType.connectionError:
        return const NetworkFailure(
          'Connection error. Please check your internet connection.',
        );
      case DioExceptionType.badCertificate:
        return const NetworkFailure(
          'Bad certificate. Security error occurred.',
        );
      case DioExceptionType.unknown:
        return const NetworkFailure(
          'An unknown error occurred. Please try again.',
        );
    }
  }

  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return const ServerFailure('Server error: No response received');
    }

    final statusCode = response.statusCode ?? 0;
    final message = _getErrorMessage(response.data);

    switch (statusCode) {
      case 400:
        return ValidationFailure(message);
      case 401:
        return const ServerFailure('Unauthorized. Please login again.');
      case 403:
        return const ServerFailure('Forbidden. You do not have permission.');
      case 404:
        return ServerFailure(message);
      case 500:
      case 502:
      case 503:
      case 504:
        return const ServerFailure('Server error. Please try again later.');
      default:
        return ServerFailure(message);
    }
  }

  static String _getErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['error'] ?? 'An error occurred';
    }
    return 'An error occurred';
  }
}
