import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:dio/dio.dart';

/// Low-level HTTP client for the 14 Knowledge Base endpoints.
///
/// Returns raw JSON (or void) — semantic mapping into domain entities lives in
/// the repository implementation.  All endpoints are tenant-scoped except
/// `testDatabaseQuery` and `pollStatus`, which are global.
class KnowledgeApi {
  final Dio _dio;

  KnowledgeApi(DioClient dioClient) : _dio = dioClient.dio;

  // ---------------------------------------------------------------------------
  // 1. GET /sources
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> getSources(
    String tenantId, {
    List<String>? ids,
    String? query,
  }) async {
    // Page through results until BE reports hasNext=false.  BE caps each
    // response at 100 items per page even when we ask for more, so paging
    // is the only way to surface the full source list.
    final all = <Map<String, dynamic>>[];
    var offset = 0;
    const pageSize = 100;
    const maxPages = 50; // safety cap (5000 sources)

    for (var page = 0; page < maxPages; page++) {
      final response = await _dio.get(
        Endpoints.knowledgeSources(tenantId),
        queryParameters: {
          'offset': offset,
          'limit': pageSize,
          if (ids != null && ids.isNotEmpty) 'ids': ids.join(','),
          if (query != null && query.isNotEmpty) 'query': query,
        },
      );
      final data = response.data;
      all.addAll(_asListOfMaps(data));
      final hasNext = data is Map && data['hasNext'] == true;
      if (!hasNext) break;
      offset += pageSize;
    }
    return all;
  }

  // ---------------------------------------------------------------------------
  // 2. GET /sources/{type}
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> getSourcesByType(
    String tenantId,
    String apiType,
  ) async {
    final response = await _dio.get(
      Endpoints.knowledgeSourcesByType(tenantId, apiType),
    );
    return _asListOfMaps(response.data);
  }

  // ---------------------------------------------------------------------------
  // 3. PATCH /sources/{sourceId}      (update status)
  // ---------------------------------------------------------------------------

  Future<void> updateSourceStatus(
    String tenantId,
    String sourceId,
    String apiStatus,
  ) async {
    await _dio.patch(
      Endpoints.knowledgeSource(tenantId, sourceId),
      data: {'status': apiStatus},
    );
  }

  // ---------------------------------------------------------------------------
  // 4. DELETE /sources/{sourceId}
  // ---------------------------------------------------------------------------

  Future<void> deleteSource(String tenantId, String sourceId) async {
    await _dio.delete(Endpoints.knowledgeSource(tenantId, sourceId));
  }

  // ---------------------------------------------------------------------------
  // 5. POST /sources/{sourceId}/reindex
  // ---------------------------------------------------------------------------

  Future<void> reindexSource(String tenantId, String sourceId) async {
    await _dio.post(Endpoints.knowledgeReindex(tenantId, sourceId));
  }

  // ---------------------------------------------------------------------------
  // 6. PATCH /sources/{sourceId}/interval
  // ---------------------------------------------------------------------------

  Future<void> updateInterval(
    String tenantId,
    String sourceId,
    String apiInterval,
  ) async {
    await _dio.patch(
      Endpoints.knowledgeInterval(tenantId, sourceId),
      data: {'interval': apiInterval},
    );
  }

  // ---------------------------------------------------------------------------
  // 7. POST /web      (single URL or whole site)
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> importWeb({
    required String tenantId,
    required String webUrl,
    required String apiInterval,
    required String webImportType, // 'single_page' | 'whole_sites'
  }) async {
    final response = await _dio.post(
      Endpoints.knowledgeImportWeb(tenantId),
      data: {
        'webUrl': webUrl,
        'interval': apiInterval,
        'type': webImportType,
      },
    );
    return _asMap(response.data);
  }

  // ---------------------------------------------------------------------------
  // 8. POST /local-file      (multipart)
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> importLocalFile({
    required String tenantId,
    required File file,
    required String fileName,
    void Function(int sent, int total)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });
    final response = await _dio.post(
      Endpoints.knowledgeImportLocalFile(tenantId),
      data: formData,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
      // BE indexes the file synchronously before responding — large files or
      // slow indexing can blow past the default 15s receive timeout, leaving
      // the upload "stuck" with no response.  Give it 5 minutes here.
      options: Options(
        contentType: 'multipart/form-data',
        sendTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 5),
      ),
    );
    return _asMap(response.data);
  }

  // ---------------------------------------------------------------------------
  // 9. POST /google-drive
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> importGoogleDrive({
    required String tenantId,
    required String name,
    required List<String> includePaths,
    required String customerSupportId,
    required Map<String, dynamic> credentials,
    required String apiInterval,
  }) async {
    final response = await _dio.post(
      Endpoints.knowledgeImportGoogleDrive(tenantId),
      data: {
        'name': name,
        'includePaths': includePaths,
        'customerSupportID': customerSupportId,
        'credentials': credentials,
        'interval': apiInterval,
      },
    );
    return _asMap(response.data);
  }

  // ---------------------------------------------------------------------------
  // 10. POST /database-query
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> importDatabaseQuery({
    required String tenantId,
    required String name,
    required String query,
    required String uri,
    required String apiInterval,
  }) async {
    final response = await _dio.post(
      Endpoints.knowledgeImportDatabaseQuery(tenantId),
      data: {
        'name': name,
        'query': query,
        'uri': uri,
        'interval': apiInterval,
      },
    );
    return _asMap(response.data);
  }

  // ---------------------------------------------------------------------------
  // 11. PATCH /database-query/{sourceId}
  // ---------------------------------------------------------------------------

  Future<void> updateDatabaseQuery({
    required String tenantId,
    required String sourceId,
    required String query,
    required String uri,
  }) async {
    await _dio.patch(
      Endpoints.knowledgeUpdateDatabaseQuery(tenantId, sourceId),
      data: {'query': query, 'uri': uri},
    );
  }

  // ---------------------------------------------------------------------------
  // 12. POST /test-database-query
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> testDatabaseQuery({
    required String query,
    required String uri,
  }) async {
    final response = await _dio.post(
      Endpoints.knowledgeTestDatabaseQuery,
      data: {'query': query, 'uri': uri},
    );
    // Backend may return rows as a top-level List instead of Map.
    // Normalize to {'rows': [...]} so _parsePreview works uniformly.
    if (response.data is List) {
      return {'rows': response.data};
    }
    return _asMap(response.data);
  }

  // ---------------------------------------------------------------------------
  // 13. POST /sources/poll-status
  // ---------------------------------------------------------------------------

  Future<Map<String, String>> pollSourceStatus(List<String> sourceIds) async {
    final response = await _dio.post(
      Endpoints.knowledgePollStatus,
      data: {'sourceIds': sourceIds},
    );
    return _parseStatusMap(response.data);
  }

  // ---------------------------------------------------------------------------
  // 14. GET /status-sse  +  GET /whole-sites-sse
  // ---------------------------------------------------------------------------

  /// Yields raw `{sourceId: apiStatus}` maps as SSE events arrive.  Domain
  /// mapping happens in the repository.
  ///
  /// Errors are propagated so callers can implement reconnection.
  Stream<Map<String, String>> statusSseStream(String tenantId) =>
      _sseStream(Endpoints.knowledgeStatusSse(tenantId));

  /// Parallel SSE channel for whole-site crawl progress.  Event payload shape
  /// matches [statusSseStream] (BE sends connected/heartbeat events the
  /// parser silently drops).
  Stream<Map<String, String>> wholeSitesSseStream(String tenantId) =>
      _sseStream(Endpoints.knowledgeWholeSitesSse(tenantId));

  Stream<Map<String, String>> _sseStream(String path) async* {
    final response = await _dio.get(
      path,
      options: Options(
        responseType: ResponseType.stream,
        headers: {'Accept': 'text/event-stream'},
      ),
    );

    final body = response.data as ResponseBody;
    final buffer = StringBuffer();

    await for (final chunk in body.stream) {
      buffer.write(utf8.decode(chunk, allowMalformed: true));
      final raw = buffer.toString();
      final lines = raw.split('\n');
      buffer.clear();

      for (var i = 0; i < lines.length - 1; i++) {
        final line = lines[i].trim();
        if (!line.startsWith('data:')) continue;

        final payload = line.substring(5).trim();
        if (payload.isEmpty || payload == '[DONE]') continue;

        final parsed = _safeDecode(payload);
        if (parsed == null) continue;
        final entry = _parseSseEvent(parsed);
        if (entry.isNotEmpty) yield entry;
      }

      if (lines.isNotEmpty) buffer.write(lines.last);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Accepts the BE list envelope shapes we have seen:
  ///   * `[ ... ]`                          (raw list)
  ///   * `{ "data": [ ... ] }`              (legacy/dev wrapper)
  ///   * `{ "items": [ ... ], "total": n }` (paginated AI-services wrapper)
  ///   * `{ "data": { "items": [ ... ] } }` (paginated wrapped in `data`)
  List<Map<String, dynamic>> _asListOfMaps(dynamic data) {
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().toList();
    }
    if (data is Map) {
      if (data['items'] is List) {
        return (data['items'] as List)
            .whereType<Map<String, dynamic>>()
            .toList();
      }
      if (data['data'] is List) {
        return (data['data'] as List)
            .whereType<Map<String, dynamic>>()
            .toList();
      }
      if (data['data'] is Map && (data['data'] as Map)['items'] is List) {
        return ((data['data'] as Map)['items'] as List)
            .whereType<Map<String, dynamic>>()
            .toList();
      }
    }
    return const [];
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map && data['data'] is Map<String, dynamic>) {
      return data['data'] as Map<String, dynamic>;
    }
    return const {};
  }

  /// Parses the response from `POST /poll-status` and `data:` payloads from SSE.
  /// Accepts:
  ///   - `{ "<id>": "<status>", ... }`
  ///   - `[ { "id"|"sourceId": "x", "status": "y" }, ... ]`
  ///   - `{ "sourceId": "x", "status": "y" }`
  Map<String, String> _parseStatusMap(dynamic data) {
    if (data is Map) {
      // Try { id: status } first.
      final flat = <String, String>{};
      var sawNonStatusKey = false;
      data.forEach((k, v) {
        if (v is String && k is String) {
          flat[k] = v;
        } else {
          sawNonStatusKey = true;
        }
      });
      if (flat.isNotEmpty && !sawNonStatusKey) return flat;

      // Try { sourceId, status } shape.
      final id = data['sourceId'] ?? data['id'];
      final status = data['status'];
      if (id is String && status is String) return {id: status};
    }
    if (data is List) {
      final out = <String, String>{};
      for (final item in data.whereType<Map<String, dynamic>>()) {
        final id = item['sourceId'] ?? item['id'];
        final status = item['status'];
        if (id is String && status is String) out[id] = status;
      }
      return out;
    }
    return const {};
  }

  Map<String, String> _parseSseEvent(dynamic parsed) =>
      _parseStatusMap(parsed);

  dynamic _safeDecode(String payload) {
    try {
      return jsonDecode(payload);
    } catch (_) {
      return null;
    }
  }
}
