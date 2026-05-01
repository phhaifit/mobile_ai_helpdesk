import 'dart:async';
import 'dart:convert';

import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:dio/dio.dart';

/// Low-level API client for Knowledge Base endpoints.
/// All methods are tenant-scoped; callers must supply [tenantId].
///
/// Sub-task A owns: getSources, deleteSource, reindexSource,
///   updateInterval, importWeb, statusSseStream.
/// Sub-task B will add: importLocalFile, importGoogleDrive, importDatabase,
///   testDatabaseQuery, updateDatabaseQuery.
class KnowledgeApi {
  final Dio _dio;

  KnowledgeApi(DioClient dioClient) : _dio = dioClient.dio;

  // ---------------------------------------------------------------------------
  // GET /api/v1/knowledges/{tenantId}/sources
  // ---------------------------------------------------------------------------

  /// Returns the raw JSON list of sources from the backend.
  Future<List<Map<String, dynamic>>> getSources(String tenantId) async {
    final response = await _dio.get(Endpoints.knowledgeSources(tenantId));
    return _parseList(response.data);
  }

  // ---------------------------------------------------------------------------
  // DELETE /api/v1/knowledges/{tenantId}/sources/{sourceId}
  // ---------------------------------------------------------------------------

  Future<void> deleteSource(String tenantId, String sourceId) async {
    await _dio.delete(Endpoints.knowledgeSource(tenantId, sourceId));
  }

  // ---------------------------------------------------------------------------
  // POST /api/v1/knowledges/{tenantId}/sources/{sourceId}/reindex
  // ---------------------------------------------------------------------------

  Future<void> reindexSource(String tenantId, String sourceId) async {
    await _dio.post(Endpoints.knowledgeReindex(tenantId, sourceId));
  }

  // ---------------------------------------------------------------------------
  // PATCH /api/v1/knowledges/{tenantId}/sources/{sourceId}/interval
  // ---------------------------------------------------------------------------

  Future<void> updateInterval(
    String tenantId,
    String sourceId,
    String apiInterval, // 'ONCE' | 'DAILY' | 'WEEKLY' | 'MONTHLY'
  ) async {
    await _dio.patch(
      Endpoints.knowledgeInterval(tenantId, sourceId),
      data: {'interval': apiInterval},
    );
  }

  // ---------------------------------------------------------------------------
  // POST /api/v1/knowledges/{tenantId}/web
  // Body: { webUrl, interval, type: 'single_url' | 'whole_site' }
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> importWeb({
    required String tenantId,
    required String webUrl,
    required String apiInterval,
    required String importType, // 'single_url' | 'whole_site'
  }) async {
    final response = await _dio.post(
      Endpoints.knowledgeImportWeb(tenantId),
      data: {
        'webUrl': webUrl,
        'interval': apiInterval,
        'type': importType,
      },
    );
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    return {};
  }

  // ---------------------------------------------------------------------------
  // GET /api/v1/knowledges/{tenantId}/sources/{type}
  // type: 'web' | 'whole_site' | 'local_file' | 'google_drive' | 'database_query'
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> getSourcesByType(
    String tenantId,
    String apiType,
  ) async {
    final response =
        await _dio.get(Endpoints.knowledgeSourcesByType(tenantId, apiType));
    return _parseList(response.data);
  }

  // ---------------------------------------------------------------------------
  // PATCH /api/v1/knowledges/{tenantId}/sources/{sourceId}/status
  // Body: { status: 'completed' | 'processing' | 'pending' | 'failed' }
  // ---------------------------------------------------------------------------

  Future<void> updateSourceStatus(
    String tenantId,
    String sourceId,
    String apiStatus,
  ) async {
    await _dio.patch(
      Endpoints.knowledgeSourceStatus(tenantId, sourceId),
      data: {'status': apiStatus},
    );
  }

  // ---------------------------------------------------------------------------
  // GET /api/v1/knowledges/{tenantId}/status-sse  (Server-Sent Events)
  // Yields: Map<sourceId, newStatus> for each SSE event.
  // ---------------------------------------------------------------------------

  /// Opens an SSE connection and emits status-update maps as they arrive.
  ///
  /// Each emitted map has the shape: `{ '<sourceId>': KnowledgeSourceStatus }`.
  /// The stream completes when the server closes the connection.
  /// Errors are propagated so callers can handle reconnection if needed.
  Stream<Map<String, KnowledgeSourceStatus>> statusSseStream(
    String tenantId,
  ) async* {
    final response = await _dio.get(
      Endpoints.knowledgeStatusSse(tenantId),
      options: Options(responseType: ResponseType.stream),
    );

    final responseBody = response.data as ResponseBody;
    final buffer = StringBuffer();

    await for (final bytes in responseBody.stream) {
      buffer.write(utf8.decode(bytes));
      final raw = buffer.toString();
      final lines = raw.split('\n');
      buffer.clear();

      // All lines except the last are complete; keep the last partial line.
      for (int i = 0; i < lines.length - 1; i++) {
        final line = lines[i].trim();
        if (!line.startsWith('data:')) continue;

        final payload = line.substring(5).trim();
        if (payload.isEmpty || payload == '[DONE]') continue;

        try {
          final parsed = jsonDecode(payload);
          final result = _parseSseEvent(parsed);
          if (result != null) yield result;
        } catch (_) {
          // Malformed JSON — skip.
        }
      }

      // Retain last incomplete line for the next chunk.
      if (lines.isNotEmpty) buffer.write(lines.last);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  List<Map<String, dynamic>> _parseList(dynamic data) {
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().toList();
    }
    if (data is Map && data['data'] is List) {
      return (data['data'] as List).whereType<Map<String, dynamic>>().toList();
    }
    return const [];
  }

  /// Parses a single SSE event payload into a { sourceId → status } map.
  ///
  /// Handles both object `{"sourceId":"x","status":"completed"}` and
  /// array `[{"id":"x","status":"processing"}, ...]` formats.
  Map<String, KnowledgeSourceStatus>? _parseSseEvent(dynamic parsed) {
    if (parsed is Map<String, dynamic>) {
      final id = (parsed['sourceId'] ?? parsed['id']) as String?;
      final statusStr = parsed['status'] as String?;
      if (id == null || statusStr == null) return null;
      return {id: statusStr.toKnowledgeSourceStatus()};
    }

    if (parsed is List) {
      final result = <String, KnowledgeSourceStatus>{};
      for (final item in parsed.whereType<Map<String, dynamic>>()) {
        final id = (item['sourceId'] ?? item['id']) as String?;
        final statusStr = item['status'] as String?;
        if (id != null && statusStr != null) {
          result[id] = statusStr.toKnowledgeSourceStatus();
        }
      }
      return result.isNotEmpty ? result : null;
    }

    return null;
  }
}
