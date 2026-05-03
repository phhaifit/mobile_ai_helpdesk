import 'dart:io';

import 'package:ai_helpdesk/data/network/apis/knowledge/knowledge_api.dart';
import 'package:ai_helpdesk/data/repository/knowledge/knowledge_exception.dart';
import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';
import 'package:dio/dio.dart';

/// Real implementation of [KnowledgeRepository] over the 14 backend endpoints.
///
/// All methods catch DioException → throw [KnowledgeException] with a
/// user-friendly message.  Tenant ID is resolved lazily from [TenantStore]
/// at call-time to avoid DI ordering coupling.
class KnowledgeRepositoryImpl implements KnowledgeRepository {
  final KnowledgeApi _api;

  KnowledgeRepositoryImpl(this._api);

  /// Resolves the active tenant ID for the BE path param.
  ///
  /// Single source of truth: [SharedPreferenceHelper.tenantId], which is
  /// populated from `Account.tenantID` after `/api/account/me` succeeds, and
  /// is the same value [TenantHeaderInterceptor] sends in the `tenantID`
  /// header — so path and header always match.
  ///
  /// We deliberately do NOT fall back to [TenantStore] (which is currently
  /// seeded from `MockTenantRepositoryImpl` with fake ids like `tn-001`).
  /// Falling back would silently send an id BE rejects with 400.
  ///
  /// If the logged-in account has no tenant assigned (BE returns
  /// `tenantID: null`), this throws a typed error so the store can surface
  /// "Bạn chưa thuộc tenant nào" to the user instead of hammering BE.
  Future<String> _resolveTenantId() async {
    final id = await getIt<SharedPreferenceHelper>().tenantId;
    if (id != null && id.isNotEmpty) return id;
    throw const KnowledgeException(
      'Tài khoản chưa thuộc tenant nào.',
      KnowledgeErrorCode.tenantMissing,
    );
  }

  // ---------------------------------------------------------------------------
  // Read
  // ---------------------------------------------------------------------------

  @override
  Future<List<KnowledgeSource>> getSources({
    List<String>? ids,
    String? query,
  }) async {
    return _guard(() async {
      final tenantId = await _resolveTenantId();
      final raw = await _api.getSources(tenantId, ids: ids, query: query);
      return raw.map(_fromApi).toList();
    });
  }

  @override
  Future<List<KnowledgeSource>> getSourcesByType(
    KnowledgeSourceType type,
  ) async {
    return _guard(() async {
      final tenantId = await _resolveTenantId();
      final raw = await _api.getSourcesByType(tenantId, type.toApiType());
      return raw.map(_fromApi).toList();
    });
  }

  @override
  Future<Map<String, KnowledgeSourceStatus>> pollSourceStatus(
    List<String> ids,
  ) async {
    if (ids.isEmpty) return const {};
    return _guard(() async {
      final raw = await _api.pollSourceStatus(ids);
      return raw.map(
        (id, status) => MapEntry(id, knowledgeSourceStatusFromApi(status)),
      );
    });
  }

  @override
  Stream<Map<String, KnowledgeSourceStatus>> watchSourceStatuses() async* {
    // Resolve tenant once when the stream starts.
    final tenantId = await _resolveTenantId();
    await for (final raw in _api.statusSseStream(tenantId)) {
      yield raw.map(
        (id, status) => MapEntry(id, knowledgeSourceStatusFromApi(status)),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Mutate
  // ---------------------------------------------------------------------------

  @override
  Future<void> updateSourceStatus(
    String id,
    KnowledgeSourceStatus status,
  ) async {
    return _guard(() async {
      final tenantId = await _resolveTenantId();
      await _api.updateSourceStatus(tenantId, id, status.toApiStatus());
    });
  }

  @override
  Future<void> updateSourceInterval(String id, CrawlInterval interval) async {
    return _guard(() async {
      final tenantId = await _resolveTenantId();
      await _api.updateInterval(tenantId, id, interval.toApiInterval());
    });
  }

  @override
  Future<void> deleteSource(String id) async {
    return _guard(() async {
      final tenantId = await _resolveTenantId();
      await _api.deleteSource(tenantId, id);
    });
  }

  @override
  Future<void> reindexSource(String id) async {
    return _guard(() async {
      final tenantId = await _resolveTenantId();
      await _api.reindexSource(tenantId, id);
    });
  }

  // ---------------------------------------------------------------------------
  // Imports
  // ---------------------------------------------------------------------------

  @override
  Future<KnowledgeSource> importWebSource({
    required String url,
    required KnowledgeSourceType type,
    required CrawlInterval interval,
  }) async {
    if (type != KnowledgeSourceType.web &&
        type != KnowledgeSourceType.wholeSite) {
      throw const KnowledgeException(
        'Loại import phải là web hoặc whole_site.',
        KnowledgeErrorCode.badRequest,
      );
    }
    return _guard(() async {
      final tenantId = await _resolveTenantId();
      final json = await _api.importWeb(
        tenantId: tenantId,
        webUrl: url,
        apiInterval: interval.toApiInterval(),
        webImportType: type.toWebImportType(),
      );
      return _fromApiOrFallback(
        json,
        fallbackName: url,
        fallbackType: type,
        fallbackInterval: interval,
        fallbackConfig: {'url': url},
      );
    });
  }

  @override
  Future<KnowledgeSource> importLocalFile({
    required File file,
    required String fileName,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    return _guard(() async {
      final tenantId = await _resolveTenantId();
      final json = await _api.importLocalFile(
        tenantId: tenantId,
        file: file,
        fileName: fileName,
        onSendProgress: onSendProgress,
      );
      final size = await file.length();
      return _fromApiOrFallback(
        json,
        fallbackName: fileName,
        fallbackType: KnowledgeSourceType.localFile,
        fallbackInterval: CrawlInterval.once,
        fallbackConfig: {'fileName': fileName, 'fileSize': size},
      );
    });
  }

  @override
  Future<KnowledgeSource> importGoogleDrive({
    required String name,
    required List<String> includePaths,
    required String customerSupportId,
    required GoogleDriveCredentials credentials,
    required CrawlInterval interval,
  }) async {
    return _guard(() async {
      final tenantId = await _resolveTenantId();
      final json = await _api.importGoogleDrive(
        tenantId: tenantId,
        name: name,
        includePaths: includePaths,
        customerSupportId: customerSupportId,
        credentials: credentials.raw,
        apiInterval: interval.toApiInterval(),
      );
      return _fromApiOrFallback(
        json,
        fallbackName: name,
        fallbackType: KnowledgeSourceType.googleDrive,
        fallbackInterval: interval,
        fallbackConfig: {'includePaths': includePaths},
      );
    });
  }

  @override
  Future<KnowledgeSource> importDatabaseQuery({
    required String name,
    required String query,
    required String uri,
    required CrawlInterval interval,
    DatabaseDialect dialect = DatabaseDialect.postgresql,
  }) async {
    return _guard(() async {
      final tenantId = await _resolveTenantId();
      final json = await _api.importDatabaseQuery(
        tenantId: tenantId,
        name: name,
        query: query,
        uri: uri,
        apiInterval: interval.toApiInterval(),
      );
      return _fromApiOrFallback(
        json,
        fallbackName: name,
        fallbackType: KnowledgeSourceType.databaseQuery,
        fallbackInterval: interval,
        fallbackConfig: {
          'query': query,
          'uri': uri,
          'dialect': dialect.name,
        },
      );
    });
  }

  @override
  Future<void> updateDatabaseQuery({
    required String id,
    required String query,
    required String uri,
  }) async {
    return _guard(() async {
      final tenantId = await _resolveTenantId();
      await _api.updateDatabaseQuery(
        tenantId: tenantId,
        sourceId: id,
        query: query,
        uri: uri,
      );
    });
  }

  @override
  Future<DatabaseQueryPreview> testDatabaseQuery({
    required String query,
    required String uri,
  }) async {
    return _guard(() async {
      final json = await _api.testDatabaseQuery(query: query, uri: uri);
      return _parsePreview(json);
    });
  }

  // ---------------------------------------------------------------------------
  // Mapping helpers
  // ---------------------------------------------------------------------------

  KnowledgeSource _fromApi(Map<String, dynamic> json) {
    final now = DateTime.now();
    return KnowledgeSource(
      id: (json['id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      type: knowledgeSourceTypeFromApi(json['type'] as String?),
      status: knowledgeSourceStatusFromApi(json['status'] as String?),
      interval: crawlIntervalFromApi(json['interval'] as String?),
      createdAt: _parseDate(json['createdAt']) ?? now,
      updatedAt: _parseDate(json['updatedAt']) ?? now,
      progress: _parseProgress(json['progress']),
      errorMessage: json['errorMessage'] as String? ??
          json['lastError'] as String?,
      config: _extractConfig(json),
    );
  }

  KnowledgeSource _fromApiOrFallback(
    Map<String, dynamic> json, {
    required String fallbackName,
    required KnowledgeSourceType fallbackType,
    required CrawlInterval fallbackInterval,
    required Map<String, dynamic> fallbackConfig,
  }) {
    if (json.isNotEmpty && json['id'] is String) {
      final mapped = _fromApi(json);
      // Backend usually doesn't return config — graft fallback for the UI.
      if (mapped.config.isEmpty) {
        return mapped.copyWith(config: fallbackConfig);
      }
      return mapped;
    }
    final now = DateTime.now();
    return KnowledgeSource(
      id: (json['id'] as String?) ?? 'pending-${now.millisecondsSinceEpoch}',
      name: (json['name'] as String?) ?? fallbackName,
      type: fallbackType,
      status: KnowledgeSourceStatus.pending,
      interval: fallbackInterval,
      createdAt: now,
      updatedAt: now,
      config: fallbackConfig,
    );
  }

  Map<String, dynamic> _extractConfig(Map<String, dynamic> json) {
    final cfg = json['config'];
    if (cfg is Map<String, dynamic>) return cfg;
    return const {};
  }

  DateTime? _parseDate(dynamic raw) {
    if (raw is String && raw.isNotEmpty) {
      try {
        return DateTime.parse(raw);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  double? _parseProgress(dynamic raw) {
    if (raw is num) {
      final v = raw.toDouble();
      if (v.isNaN || v.isInfinite) return null;
      if (v <= 1.0) return v.clamp(0.0, 1.0);
      // Some BE flavours emit 0..100.
      return (v / 100.0).clamp(0.0, 1.0);
    }
    return null;
  }

  DatabaseQueryPreview _parsePreview(Map<String, dynamic> json) {
    final rowsRaw = json['rows'] ?? json['data'] ?? json['preview'];
    final cols = json['columns'];
    final rows = <Map<String, dynamic>>[];
    if (rowsRaw is List) {
      for (final r in rowsRaw) {
        if (r is Map<String, dynamic>) rows.add(r);
      }
    }
    final columns = <String>[];
    if (cols is List) {
      for (final c in cols) {
        if (c is String) columns.add(c);
      }
    } else if (rows.isNotEmpty) {
      columns.addAll(rows.first.keys);
    }
    final msg = json['message'];
    return DatabaseQueryPreview(
      rows: rows,
      columns: columns,
      message: msg is String ? msg : null,
    );
  }

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on KnowledgeException {
      rethrow;
    } on DioException catch (e) {
      throw KnowledgeException.from(e);
    } catch (e) {
      throw KnowledgeException.from(e);
    }
  }
}
