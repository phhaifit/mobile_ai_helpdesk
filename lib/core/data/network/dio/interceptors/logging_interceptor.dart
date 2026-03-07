import 'dart:convert';

import 'package:dio/dio.dart';

enum Level {
  none,
  basic,
  headers,
  body,
}

class LoggingInterceptor extends Interceptor {
  final Level level;
  void Function(Object object) logPrint;
  final bool compact;

  final JsonDecoder decoder = const JsonDecoder();
  final JsonEncoder encoder = const JsonEncoder.withIndent('  ');

  LoggingInterceptor({
    this.level = Level.body,
    this.compact = false,
    this.logPrint = print,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (level == Level.none) {
      return handler.next(options);
    }

    logPrint('--> ${options.method} ${options.uri}');

    if (level == Level.basic) {
      return handler.next(options);
    }

    logPrint('[DIO][HEADERS]');
    options.headers.forEach((key, value) {
      logPrint('$key:$value');
    });

    if (level == Level.headers) {
      logPrint('[DIO][HEADERS]--> END ${options.method}');
      return handler.next(options);
    }

    final data = options.data;
    if (data != null) {
      if (data is Map) {
        if (compact) {
          logPrint('$data');
        } else {
          _prettyPrintJson(data);
        }
      } else if (data is! FormData) {
        logPrint(data.toString());
      }
    }

    logPrint('[DIO]--> END ${options.method}');

    return handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (level == Level.none) {
      return handler.next(response);
    }

    logPrint('<-- ${response.statusCode} ${response.requestOptions.uri}');

    if (level == Level.basic) {
      return handler.next(response);
    }

    logPrint('[DIO][HEADER]');
    response.headers.forEach((key, value) {
      logPrint('$key:$value');
    });

    if (level == Level.headers) {
      return handler.next(response);
    }

    final Object? data = response.data;
    if (data != null) {
      if (compact) {
        logPrint('$data');
      } else if (data is Map || data is List) {
        _prettyPrintJson(data);
      } else {
        logPrint(data.toString());
      }
    }

    logPrint('<-- END HTTP');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logPrint('<-- Error -->');
    logPrint('${err.error}');
    logPrint('${err.message}');
    return handler.next(err);
  }

  void _prettyPrintJson(Object input) {
    try {
      final prettyString = encoder.convert(input);
      prettyString.split('\n').forEach((element) => logPrint(element));
    } catch (_) {
      logPrint(input.toString());
    }
  }
}
