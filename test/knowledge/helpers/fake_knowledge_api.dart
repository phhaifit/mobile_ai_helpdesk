import 'package:ai_helpdesk/core/data/network/dio/configs/dio_configs.dart';
import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/apis/knowledge/knowledge_api.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';

/// Test double for [KnowledgeApi].
/// Overrides all network methods — the Dio client is never actually used.
/// Set [sourcesResponse] / [importWebResponse] to control return values.
/// Inspect [lastXxx] fields to verify what arguments were passed.
class FakeKnowledgeApi extends KnowledgeApi {
  // --- configurable return values ---
  List<Map<String, dynamic>> sourcesResponse = [];
  Map<String, dynamic> importWebResponse = {};
  Stream<Map<String, KnowledgeSourceStatus>> sseStream = Stream.empty();

  // --- captured arguments ---
  String? lastGetSourcesTenantId;
  String? lastDeleteTenantId;
  String? lastDeleteSourceId;
  String? lastReindexTenantId;
  String? lastReindexSourceId;
  String? lastUpdateIntervalTenantId;
  String? lastUpdateIntervalSourceId;
  String? lastUpdateIntervalValue;
  String? lastImportWebTenantId;
  String? lastImportWebUrl;
  String? lastImportWebInterval;
  String? lastImportWebType;

  FakeKnowledgeApi()
      : super(DioClient(
          dioConfigs: const DioConfigs(baseUrl: 'http://fake.test'),
        ));

  @override
  Future<List<Map<String, dynamic>>> getSources(String tenantId) async {
    lastGetSourcesTenantId = tenantId;
    return sourcesResponse;
  }

  @override
  Future<void> deleteSource(String tenantId, String sourceId) async {
    lastDeleteTenantId = tenantId;
    lastDeleteSourceId = sourceId;
  }

  @override
  Future<void> reindexSource(String tenantId, String sourceId) async {
    lastReindexTenantId = tenantId;
    lastReindexSourceId = sourceId;
  }

  @override
  Future<void> updateInterval(
    String tenantId,
    String sourceId,
    String apiInterval,
  ) async {
    lastUpdateIntervalTenantId = tenantId;
    lastUpdateIntervalSourceId = sourceId;
    lastUpdateIntervalValue = apiInterval;
  }

  @override
  Future<Map<String, dynamic>> importWeb({
    required String tenantId,
    required String webUrl,
    required String apiInterval,
    required String importType,
  }) async {
    lastImportWebTenantId = tenantId;
    lastImportWebUrl = webUrl;
    lastImportWebInterval = apiInterval;
    lastImportWebType = importType;
    return importWebResponse;
  }

  @override
  Stream<Map<String, KnowledgeSourceStatus>> statusSseStream(
    String tenantId,
  ) =>
      sseStream;
}
