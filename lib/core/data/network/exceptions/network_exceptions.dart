import 'package:dio/dio.dart';

import 'package:ai_helpdesk/core/domain/error/failure.dart';

/// Helper class to convert DioExceptions to domain failures
class NetworkExceptions {
  static Failure getDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkFailure(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.sendTimeout:
        return NetworkFailure('Send timeout. Please try again.');
      case DioExceptionType.receiveTimeout:
        return NetworkFailure('Receive timeout. Please try again.');
      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);
      case DioExceptionType.cancel:
        return NetworkFailure('Request cancelled.');
      case DioExceptionType.connectionError:
        return NetworkFailure(
          'Connection error. Please check your internet connection.',
        );
      case DioExceptionType.badCertificate:
        return NetworkFailure('Bad certificate. Security error occurred.');
      case DioExceptionType.unknown:
        return NetworkFailure('An unknown error occurred. Please try again.');
    }
  }

  static Failure _handleBadResponse(Response<dynamic>? response) {
    if (response == null) {
      return ServerFailure('Server error: No response received');
    }

    final statusCode = response.statusCode ?? 0;
    final message = _getErrorMessage(response.data);

    switch (statusCode) {
      case 400:
        return ValidationFailure(message);
      case 401:
        return ServerFailure('Unauthorized. Please login again.');
      case 403:
        return ServerFailure('Forbidden. You do not have permission.');
      case 404:
        return ServerFailure(message);
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerFailure('Server error. Please try again later.');
      default:
        return ServerFailure(message);
    }
  }

  static String _getErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
      final error = data['error'];
      if (error is String && error.isNotEmpty) {
        return error;
      }
    }
    return 'An error occurred';
  }
}
