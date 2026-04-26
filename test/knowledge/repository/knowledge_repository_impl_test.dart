import 'package:ai_helpdesk/core/stores/error/error_store.dart';
import 'package:ai_helpdesk/data/repository/knowledge/knowledge_repository_impl.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/entity/tenant/tenant.dart';
import 'package:ai_helpdesk/domain/entity/tenant_settings/tenant_settings.dart';
import 'package:ai_helpdesk/domain/entity/team_member/team_member.dart';
import 'package:ai_helpdesk/domain/repository/tenant/tenant_repository.dart';
import 'package:ai_helpdesk/presentation/tenant/store/tenant_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../helpers/fake_knowledge_api.dart';
import '../helpers/knowledge_fixtures.dart';

// ---------------------------------------------------------------------------
// Fake TenantRepository — returns a single known tenant
// ---------------------------------------------------------------------------

class _FakeTenantRepository implements TenantRepository {
  final Tenant _tenant;

  _FakeTenantRepository(this._tenant);

  @override
  Future<List<Tenant>> getTenants() async => [_tenant];

  @override
  Future<Tenant?> getTenantById(String id) async =>
      _tenant.id == id ? _tenant : null;

  @override
  Future<Tenant> createTenant(Tenant tenant) async => tenant;

  @override
  Future<Tenant?> updateTenant(Tenant tenant) async => tenant;

  @override
  Future<bool> deleteTenant(String id) async => true;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

final _kTenant = Tenant(
  id: kTestTenantId,
  name: 'Test Corp',
  settings: const TenantSettings(
    allowInvitations: true,
    defaultRole: TeamRole.member,
    enableAuditLog: false,
  ),
  createdAt: DateTime(2024, 1, 1),
);

/// Registers TenantStore in GetIt with the given tenant as currentTenant.
/// Returns the store so tests can await loadTenants if needed.
Future<TenantStore> _registerTenantStore() async {
  final store = TenantStore(
    _FakeTenantRepository(_kTenant),
    ErrorStore(),
  );
  // loadTenants() is called in the constructor — give it a microtask to complete.
  await Future<void>.delayed(Duration.zero);
  getIt.registerSingleton<TenantStore>(store);
  return store;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late FakeKnowledgeApi fakeApi;
  late KnowledgeRepositoryImpl repo;

  setUp(() async {
    // Fresh GetIt state for each test.
    await getIt.reset();
    await _registerTenantStore();
    fakeApi = FakeKnowledgeApi();
    repo = KnowledgeRepositoryImpl(fakeApi);
  });

  tearDown(() async {
    await getIt.reset();
  });

  // -------------------------------------------------------------------------
  // getSources
  // -------------------------------------------------------------------------

  group('getSources', () {
    test('passes current tenantId to the API', () async {
      fakeApi.sourcesResponse = [];

      await repo.getSources();

      expect(fakeApi.lastGetSourcesTenantId, kTestTenantId);
    });

    test('maps API JSON to domain KnowledgeSource list', () async {
      fakeApi.sourcesResponse = [kApiSourceJson];

      final result = await repo.getSources();

      expect(result.length, 1);
      expect(result.first.id, 'src-001');
      expect(result.first.name, 'Test Website');
      expect(result.first.type, KnowledgeSourceType.webSingle);
      expect(result.first.status, KnowledgeSourceStatus.active);
      expect(result.first.crawlInterval, CrawlInterval.daily);
    });

    test('returns empty list when API returns nothing', () async {
      fakeApi.sourcesResponse = [];

      final result = await repo.getSources();

      expect(result, isEmpty);
    });

    test('maps "whole_site" type correctly', () async {
      fakeApi.sourcesResponse = [
        {
          'id': 'src-002',
          'name': 'Full Site',
          'type': 'whole_site',
          'status': 'completed',
          'updatedAt': '2024-01-15T12:00:00.000Z',
          'interval': 'WEEKLY',
        }
      ];

      final result = await repo.getSources();

      expect(result.first.type, KnowledgeSourceType.webFull);
      expect(result.first.crawlInterval, CrawlInterval.weekly);
    });

    test('maps "pending" status to indexing', () async {
      fakeApi.sourcesResponse = [
        {
          ...kApiImportWebResponse,
          'id': 'src-003',
        }
      ];

      final result = await repo.getSources();

      expect(result.first.status, KnowledgeSourceStatus.indexing);
    });
  });

  // -------------------------------------------------------------------------
  // addSource — web types
  // -------------------------------------------------------------------------

  group('addSource (web)', () {
    test('calls importWeb with correct tenantId and URL', () async {
      fakeApi.importWebResponse = kApiImportWebResponse;

      await repo.addSource(kWebSource);

      expect(fakeApi.lastImportWebTenantId, kTestTenantId);
      expect(fakeApi.lastImportWebUrl, 'https://example.com');
    });

    test('sends single_url importType for webSingle', () async {
      fakeApi.importWebResponse = kApiImportWebResponse;

      await repo.addSource(kWebSource);

      expect(fakeApi.lastImportWebType, 'single_url');
    });

    test('sends whole_site importType for webFull', () async {
      fakeApi.importWebResponse = kApiImportWebResponse;

      await repo.addSource(kWebFullSource);

      expect(fakeApi.lastImportWebType, 'whole_site');
    });

    test('sends DAILY interval for webSingle source with daily crawl', () async {
      fakeApi.importWebResponse = kApiImportWebResponse;

      await repo.addSource(kWebSource); // kWebSource has CrawlInterval.daily

      expect(fakeApi.lastImportWebInterval, 'DAILY');
    });

    test('returns mapped source when API response contains id', () async {
      fakeApi.importWebResponse = kApiImportWebResponse;

      final result = await repo.addSource(kWebSource);

      expect(result.id, 'src-new-001');
      expect(result.status, KnowledgeSourceStatus.indexing);
    });

    test('throws UnimplementedError for localFile type', () async {
      final localFileSource = KnowledgeSource(
        id: '',
        name: 'My File',
        type: KnowledgeSourceType.localFile,
        status: KnowledgeSourceStatus.indexing,
        lastSyncAt: kTestDate,
        crawlInterval: CrawlInterval.manual,
        config: const {},
      );

      await expectLater(
        repo.addSource(localFileSource),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  // deleteSource
  // -------------------------------------------------------------------------

  group('deleteSource', () {
    test('passes tenantId and sourceId to API', () async {
      await repo.deleteSource('src-001');

      expect(fakeApi.lastDeleteTenantId, kTestTenantId);
      expect(fakeApi.lastDeleteSourceId, 'src-001');
    });

    test('completes without error', () async {
      await expectLater(repo.deleteSource('src-001'), completes);
    });
  });

  // -------------------------------------------------------------------------
  // reindexSource
  // -------------------------------------------------------------------------

  group('reindexSource', () {
    test('passes tenantId and sourceId to API', () async {
      fakeApi.sourcesResponse = [kApiSourceJson];

      await repo.reindexSource('src-001');

      expect(fakeApi.lastReindexTenantId, kTestTenantId);
      expect(fakeApi.lastReindexSourceId, 'src-001');
    });

    test('fetches sources after reindex and returns matching one', () async {
      fakeApi.sourcesResponse = [kApiSourceJson];

      final result = await repo.reindexSource('src-001');

      expect(result.id, 'src-001');
    });

    test('returns stub with indexing status when source not found in list', () async {
      fakeApi.sourcesResponse = []; // source no longer in list

      final result = await repo.reindexSource('src-999');

      expect(result.id, 'src-999');
      expect(result.status, KnowledgeSourceStatus.indexing);
    });
  });

  // -------------------------------------------------------------------------
  // updateSourceCrawlInterval
  // -------------------------------------------------------------------------

  group('updateSourceCrawlInterval', () {
    test('passes tenantId, sourceId, and interval string to API', () async {
      fakeApi.sourcesResponse = [kApiSourceJson];

      await repo.updateSourceCrawlInterval('src-001', CrawlInterval.weekly);

      expect(fakeApi.lastUpdateIntervalTenantId, kTestTenantId);
      expect(fakeApi.lastUpdateIntervalSourceId, 'src-001');
      expect(fakeApi.lastUpdateIntervalValue, 'WEEKLY');
    });

    test('returns updated source with the new crawl interval', () async {
      fakeApi.sourcesResponse = [kApiSourceJson]; // kApiSourceJson has DAILY

      final result = await repo.updateSourceCrawlInterval(
        'src-001',
        CrawlInterval.weekly,
      );

      // copyWith applies the new interval regardless of what API returned.
      expect(result.crawlInterval, CrawlInterval.weekly);
    });

    test('returns stub with requested interval when source not found', () async {
      fakeApi.sourcesResponse = [];

      final result = await repo.updateSourceCrawlInterval(
        'src-999',
        CrawlInterval.monthly,
      );

      expect(result.id, 'src-999');
      expect(result.crawlInterval, CrawlInterval.monthly);
    });
  });

  // -------------------------------------------------------------------------
  // watchSourceStatuses
  // -------------------------------------------------------------------------

  group('watchSourceStatuses', () {
    test('delegates SSE stream from API with current tenantId', () async {
      final event = {'src-001': KnowledgeSourceStatus.active};
      fakeApi.sseStream = Stream.value(event);

      final events = await repo.watchSourceStatuses().toList();

      expect(events.length, 1);
      expect(events.first['src-001'], KnowledgeSourceStatus.active);
    });

    test('returns empty stream when API emits nothing', () async {
      fakeApi.sseStream = Stream.empty();

      final events = await repo.watchSourceStatuses().toList();

      expect(events, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // testDbConnection — Sub-task B stub
  // -------------------------------------------------------------------------

  group('testDbConnection', () {
    test('throws UnimplementedError (implemented in Sub-task B)', () {
      // The method throws synchronously before creating a Future.
      expect(
        () => repo.testDbConnection({'host': 'localhost'}),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
