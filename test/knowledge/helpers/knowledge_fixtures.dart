import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';

const kTestTenantId = 'tenant-test-123';

final kTestDate = DateTime(2024, 1, 15, 12, 0);

/// Web (single URL) source — status active, interval daily
final kWebSource = KnowledgeSource(
  id: 'src-001',
  name: 'Test Website',
  type: KnowledgeSourceType.webSingle,
  status: KnowledgeSourceStatus.active,
  lastSyncAt: kTestDate,
  crawlInterval: CrawlInterval.daily,
  config: const {'url': 'https://example.com'},
);

/// Web (whole site) source — status indexing, interval weekly
final kWebFullSource = KnowledgeSource(
  id: 'src-002',
  name: 'Full Website',
  type: KnowledgeSourceType.webFull,
  status: KnowledgeSourceStatus.indexing,
  lastSyncAt: kTestDate,
  crawlInterval: CrawlInterval.weekly,
  config: const {'url': 'https://example.org'},
);

/// Raw JSON as returned by GET /api/v1/knowledges/{tenantId}/sources
final kApiSourceJson = <String, dynamic>{
  'id': 'src-001',
  'name': 'Test Website',
  'type': 'web',
  'status': 'completed',
  'updatedAt': '2024-01-15T12:00:00.000Z',
  'interval': 'DAILY',
};

/// Raw JSON returned by POST /web (import web response)
final kApiImportWebResponse = <String, dynamic>{
  'id': 'src-new-001',
  'name': 'New Site',
  'type': 'web',
  'status': 'pending',
  'updatedAt': '2024-01-15T12:00:00.000Z',
  'interval': 'ONCE',
};
