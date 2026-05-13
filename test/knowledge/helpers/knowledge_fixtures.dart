import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';

const kTestTenantId = 'tenant-test-123';

final kTestDate = DateTime(2024, 1, 15, 12, 0);

/// Web (single URL) — completed / daily
final kWebSource = KnowledgeSource(
  id: 'src-001',
  name: 'Test Website',
  type: KnowledgeSourceType.web,
  status: KnowledgeSourceStatus.completed,
  interval: CrawlInterval.daily,
  createdAt: kTestDate,
  updatedAt: kTestDate,
  config: const {'url': 'https://example.com'},
);

/// Whole-site — processing / weekly
final kWebFullSource = KnowledgeSource(
  id: 'src-002',
  name: 'Full Website',
  type: KnowledgeSourceType.wholeSite,
  status: KnowledgeSourceStatus.processing,
  interval: CrawlInterval.weekly,
  createdAt: kTestDate,
  updatedAt: kTestDate,
  config: const {'url': 'https://example.org'},
);

/// Raw JSON as returned by GET /api/v1/knowledges/{tenantId}/sources
final kApiSourceJson = <String, dynamic>{
  'id': 'src-001',
  'name': 'Test Website',
  'type': 'web',
  'status': 'completed',
  'createdAt': '2024-01-15T12:00:00.000Z',
  'updatedAt': '2024-01-15T12:00:00.000Z',
  'interval': 'DAILY',
};

/// Raw JSON returned by POST /web
final kApiImportWebResponse = <String, dynamic>{
  'id': 'src-new-001',
  'name': 'New Site',
  'type': 'web',
  'status': 'pending',
  'createdAt': '2024-01-15T12:00:00.000Z',
  'updatedAt': '2024-01-15T12:00:00.000Z',
  'interval': 'ONCE',
};
