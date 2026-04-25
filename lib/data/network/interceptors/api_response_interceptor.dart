import 'package:dio/dio.dart';

class ApiResponseInterceptor extends Interceptor {
  // Define all valid success strings from backend's API_STATUS enum
  static const _validSuccessStatuses = ['OK', 'CREATED'];

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final rawData = response.data;

    // Dio already guarantees this is a 2xx HTTP response by the time it hits here.
    if (rawData is Map<String, dynamic> && rawData.containsKey('status')) {
      final status = rawData['status']?.toString().toUpperCase();

      // 1. Validation: Check against a list of valid success statuses
      if (!_validSuccessStatuses.contains(status)) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response, // HelpdeskErrorMapper will process this
          type: DioExceptionType.badResponse,
        );
      }

      // 2. Unwrapping: Safely assign the data field.
      // Use `rawData['data']` if it exists, otherwise keep the `rawData` 
      // (in case an endpoint like 201 doesn't return a 'data' object).
      response.data = rawData.containsKey('data') ? rawData['data'] : rawData;
    }

    handler.next(response);
  }
}