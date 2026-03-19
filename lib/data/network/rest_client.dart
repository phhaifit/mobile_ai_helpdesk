import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'exceptions/network_exceptions.dart';

class RestClient {
  final JsonDecoder _decoder = const JsonDecoder();

  Future<dynamic> get(String path) {
    return http.get(Uri.parse(path)).then(_createResponse);
  }

  Future<dynamic> post(String path,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return http
        .post(
          Uri.parse(path),
          body: body,
          headers: headers,
          encoding: encoding,
        )
        .then(_createResponse);
  }

  Future<dynamic> put(String path,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return http
        .put(
          Uri.parse(path),
          body: body,
          headers: headers,
          encoding: encoding,
        )
        .then(_createResponse);
  }

  Future<dynamic> delete(String path,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return http
        .delete(
          Uri.parse(path),
          body: body,
          headers: headers,
          encoding: encoding,
        )
        .then(_createResponse);
  }

  dynamic _createResponse(http.Response response) {
    final String res = response.body;
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      throw NetworkException(
          message: 'Error fetching data from server', statusCode: statusCode);
    }

    return _decoder.convert(res);
  }
}
