class ApiResponseParser {
  ApiResponseParser._();

  static dynamic unwrap(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      for (final key in const ['data', 'result', 'payload', 'item']) {
        if (payload.containsKey(key)) {
          return payload[key];
        }
      }
    }
    return payload;
  }

  static Map<String, dynamic> asMap(dynamic payload) {
    final unwrapped = unwrap(payload);
    if (unwrapped is Map<String, dynamic>) {
      return unwrapped;
    }
    throw StateError('Expected response map but got: ${unwrapped.runtimeType}');
  }

  static List<Map<String, dynamic>> asMapList(dynamic payload) {
    final unwrapped = unwrap(payload);
    if (unwrapped is List) {
        return unwrapped
          .whereType<Map<String, dynamic>>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList(growable: false);
    }
    if (unwrapped is Map<String, dynamic>) {
      for (final key in const ['items', 'results', 'records']) {
        final value = unwrapped[key];
        if (value is List) {
            return value
              .whereType<Map<String, dynamic>>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList(growable: false);
        }
      }
    }
    throw StateError('Expected response list but got: ${unwrapped.runtimeType}');
  }

  static bool asDeleteSuccess(dynamic payload) {
    final unwrapped = unwrap(payload);
    if (unwrapped is bool) {
      return unwrapped;
    }
    if (unwrapped is Map<String, dynamic>) {
      final success = unwrapped['success'];
      if (success is bool) {
        return success;
      }
      final deleted = unwrapped['deleted'];
      if (deleted is bool) {
        return deleted;
      }
    }
    return true;
  }
}
