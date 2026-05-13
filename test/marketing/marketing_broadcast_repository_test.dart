import 'package:ai_helpdesk/data/network/apis/marketing/marketing_broadcast_api.dart';
import 'package:ai_helpdesk/data/repository/marketing/marketing_broadcast_repository_impl.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMarketingBroadcastApi extends Mock implements MarketingBroadcastApi {}

void main() {
  late MarketingBroadcastRepositoryImpl repository;
  late MockMarketingBroadcastApi mockApi;

  setUp(() {
    mockApi = MockMarketingBroadcastApi();
    repository = MarketingBroadcastRepositoryImpl(mockApi);
    registerFallbackValue(const BroadcastTemplateQuery());
    registerFallbackValue(const BroadcastQuery());
    registerFallbackValue(
      const BroadcastTemplateUpsertData(
        name: '',
        content: '',
        variableKeys: [],
      ),
    );
    registerFallbackValue(const PaginationQuery(offset: 0, limit: 20));
    registerFallbackValue(
      const BroadcastRecipientsQuery(
        broadcastId: '',
        filter: BroadcastRecipientsFilter(),
      ),
    );
  });

  group('getBroadcastTemplates', () {
    test('maps paginated template response', () async {
      when(() => mockApi.getBroadcastTemplates(query: any(named: 'query')))
          .thenAnswer(
            (_) async => {
              'items': [
                {
                  'id': 'tpl_1',
                  'name': 'Welcome',
                  'content': 'Hello {{name}}',
                  'isActive': true,
                  'variableKeys': ['name'],
                },
              ],
              'total': 1,
              'offset': 0,
              'limit': 10,
            },
          );

      final result = await repository.getBroadcastTemplates(
        query: const BroadcastTemplateQuery(),
      );

      expect(result.items.length, 1);
      expect(result.items.first.id, 'tpl_1');
      expect(result.items.first.name, 'Welcome');
      expect(result.items.first.variableKeys, ['name']);
      expect(result.total, 1);
    });

    test('unwraps items from nested data key', () async {
      when(() => mockApi.getBroadcastTemplates(query: any(named: 'query')))
          .thenAnswer(
            (_) async => {
              'data': {
                'items': [
                  {'id': 'tpl_2', 'name': 'Promo', 'content': 'Buy now'},
                ],
                'total': 5,
                'limit': 10,
                'offset': 0,
              },
            },
          );

      final result = await repository.getBroadcastTemplates(
        query: const BroadcastTemplateQuery(),
      );

      expect(result.items.length, 1);
      expect(result.items.first.name, 'Promo');
      expect(result.total, 5);
    });

    test('accepts alternative field names (results, count)', () async {
      when(() => mockApi.getBroadcastTemplates(query: any(named: 'query')))
          .thenAnswer(
            (_) async => {
              'results': [
                {'id': 'tpl_3', 'name': 'Alt', 'content': 'Alt body'},
              ],
              'count': 3,
              'offset': 0,
              'limit': 10,
            },
          );

      final result = await repository.getBroadcastTemplates(
        query: const BroadcastTemplateQuery(),
      );

      expect(result.items.length, 1);
      expect(result.total, 3);
    });
  });

  group('createBroadcastTemplate', () {
    test('maps created template from flat response', () async {
      when(() => mockApi.createBroadcastTemplate(any())).thenAnswer(
        (_) async => {
          'id': 'new_tpl',
          'name': 'New Template',
          'content': 'Content here',
          'isActive': true,
          'variableKeys': ['name', 'email'],
        },
      );

      final result = await repository.createBroadcastTemplate(
        const BroadcastTemplateUpsertData(
          name: 'New Template',
          content: 'Content here',
          variableKeys: [],
        ),
      );

      expect(result.id, 'new_tpl');
      expect(result.name, 'New Template');
      expect(result.variableKeys, ['name', 'email']);
      expect(result.isActive, isTrue);
    });

    test('maps created template from data-wrapped response', () async {
      when(() => mockApi.createBroadcastTemplate(any())).thenAnswer(
        (_) async => {
          'data': {
            'id': 'wrapped_tpl',
            'name': 'Wrapped',
            'content': 'Body',
            'isActive': false,
          },
        },
      );

      final result = await repository.createBroadcastTemplate(
        const BroadcastTemplateUpsertData(
          name: 'Wrapped',
          content: 'Body',
          variableKeys: [],
        ),
      );

      expect(result.id, 'wrapped_tpl');
      expect(result.isActive, isFalse);
    });
  });

  group('updateBroadcastTemplate', () {
    test('delegates to API and maps response', () async {
      when(
        () => mockApi.updateBroadcastTemplate(
          templateId: any(named: 'templateId'),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => {
          'id': 'tpl_1',
          'name': 'Updated',
          'content': 'New content',
          'isActive': true,
        },
      );

      final result = await repository.updateBroadcastTemplate(
        templateId: 'tpl_1',
        data: const BroadcastTemplateUpsertData(
          name: 'Updated',
          content: 'New content',
          variableKeys: [],
        ),
      );

      expect(result.name, 'Updated');
      verify(
        () => mockApi.updateBroadcastTemplate(
          templateId: 'tpl_1',
          data: any(named: 'data'),
        ),
      ).called(1);
    });
  });

  group('deleteBroadcastTemplate', () {
    test('returns true when success field is true', () async {
      when(() => mockApi.deleteBroadcastTemplate(any())).thenAnswer(
        (_) async => {'success': true},
      );

      final result = await repository.deleteBroadcastTemplate('tpl_1');

      expect(result, isTrue);
      verify(() => mockApi.deleteBroadcastTemplate('tpl_1')).called(1);
    });

    test('returns false when success field is false', () async {
      when(() => mockApi.deleteBroadcastTemplate(any())).thenAnswer(
        (_) async => {'success': false},
      );

      final result = await repository.deleteBroadcastTemplate('tpl_1');

      expect(result, isFalse);
    });

    test('uses fallback true when no success field', () async {
      when(() => mockApi.deleteBroadcastTemplate(any())).thenAnswer(
        (_) async => {},
      );

      final result = await repository.deleteBroadcastTemplate('tpl_1');

      expect(result, isTrue);
    });
  });

  group('getBroadcasts', () {
    test('maps broadcast items with status', () async {
      when(() => mockApi.getBroadcasts(query: any(named: 'query'))).thenAnswer(
        (_) async => {
          'items': [
            {
              'id': 'bc_1',
              'name': 'Campaign A',
              'templateId': 'tpl_1',
              'status': 'running',
              'sentCount': 100,
              'deliveredCount': 95,
              'failedCount': 5,
              'recipientCount': 200,
            },
          ],
          'total': 1,
          'offset': 0,
          'limit': 10,
        },
      );

      final result = await repository.getBroadcasts(
        query: const BroadcastQuery(),
      );

      expect(result.items.length, 1);
      expect(result.items.first.id, 'bc_1');
      expect(result.items.first.status, BroadcastStatus.running);
      expect(result.items.first.sentCount, 100);
      expect(result.items.first.deliveredCount, 95);
    });

    test('maps templateId from nested template object', () async {
      when(() => mockApi.getBroadcasts(query: any(named: 'query'))).thenAnswer(
        (_) async => {
          'items': [
            {
              'id': 'bc_2',
              'name': 'Campaign B',
              'template': {'id': 'tpl_nested', 'name': 'Template'},
              'status': 'draft',
            },
          ],
          'total': 1,
          'offset': 0,
          'limit': 10,
        },
      );

      final result = await repository.getBroadcasts(
        query: const BroadcastQuery(),
      );

      expect(result.items.first.templateId, 'tpl_nested');
    });
  });

  group('status parsing', () {
    Future<BroadcastItem> itemWithStatus(String rawStatus) async {
      when(() => mockApi.getBroadcastDetail(any())).thenAnswer(
        (_) async => {
          'id': 'bc_1',
          'name': 'Test',
          'templateId': 'tpl_1',
          'status': rawStatus,
        },
      );
      return repository.getBroadcastDetail('bc_1');
    }

    test('parses scheduled', () async {
      expect((await itemWithStatus('scheduled')).status, BroadcastStatus.scheduled);
    });

    test('parses running', () async {
      expect((await itemWithStatus('running')).status, BroadcastStatus.running);
    });

    test('parses paused', () async {
      expect((await itemWithStatus('paused')).status, BroadcastStatus.paused);
    });

    test('parses completed', () async {
      expect(
        (await itemWithStatus('completed')).status,
        BroadcastStatus.completed,
      );
    });

    test('parses failed', () async {
      expect((await itemWithStatus('failed')).status, BroadcastStatus.failed);
    });

    test('is case-insensitive (RUNNING → running)', () async {
      expect((await itemWithStatus('RUNNING')).status, BroadcastStatus.running);
    });

    test('falls back to draft for unknown value', () async {
      expect(
        (await itemWithStatus('unknown_xyz')).status,
        BroadcastStatus.draft,
      );
    });
  });

  group('executeBroadcast / stopBroadcast / resumeBroadcast', () {
    test('executeBroadcast delegates to API', () async {
      when(() => mockApi.executeBroadcast(any())).thenAnswer(
        (_) async => {
          'id': 'bc_1',
          'name': 'Campaign',
          'templateId': 'tpl_1',
          'status': 'running',
        },
      );

      final result = await repository.executeBroadcast('bc_1');

      expect(result.id, 'bc_1');
      expect(result.status, BroadcastStatus.running);
      verify(() => mockApi.executeBroadcast('bc_1')).called(1);
    });

    test('stopBroadcast delegates to API', () async {
      when(() => mockApi.stopBroadcast(any())).thenAnswer(
        (_) async => {
          'id': 'bc_1',
          'name': 'Campaign',
          'templateId': 'tpl_1',
          'status': 'paused',
        },
      );

      final result = await repository.stopBroadcast('bc_1');

      expect(result.status, BroadcastStatus.paused);
      verify(() => mockApi.stopBroadcast('bc_1')).called(1);
    });

    test('resumeBroadcast delegates to API', () async {
      when(() => mockApi.resumeBroadcast(any())).thenAnswer(
        (_) async => {
          'id': 'bc_1',
          'name': 'Campaign',
          'templateId': 'tpl_1',
          'status': 'running',
        },
      );

      final result = await repository.resumeBroadcast('bc_1');

      expect(result.status, BroadcastStatus.running);
      verify(() => mockApi.resumeBroadcast('bc_1')).called(1);
    });
  });

  group('getFacebookAdminAccounts', () {
    test('maps list of accounts', () async {
      when(() => mockApi.getFacebookAdminAccounts()).thenAnswer(
        (_) async => [
          {
            'id': 'acc_1',
            'adminName': 'Admin User',
            'adminEmail': 'admin@example.com',
            'pageId': 'page_1',
            'pageName': 'My Page',
            'status': 'connected',
          },
        ],
      );

      final result = await repository.getFacebookAdminAccounts();

      expect(result.length, 1);
      expect(result.first.id, 'acc_1');
      expect(result.first.adminName, 'Admin User');
      expect(result.first.pageId, 'page_1');
      expect(result.first.status, 'connected');
    });

    test('returns empty list when API returns empty', () async {
      when(() => mockApi.getFacebookAdminAccounts()).thenAnswer(
        (_) async => [],
      );

      final result = await repository.getFacebookAdminAccounts();

      expect(result, isEmpty);
    });
  });

  group('disconnectFacebookAdminAccount', () {
    test('returns true on success', () async {
      when(() => mockApi.disconnectFacebookAdminAccount(any())).thenAnswer(
        (_) async => {'success': true},
      );

      final result = await repository.disconnectFacebookAdminAccount('acc_1');

      expect(result, isTrue);
      verify(() => mockApi.disconnectFacebookAdminAccount('acc_1')).called(1);
    });

    test('uses fallback true when response has no success field', () async {
      when(() => mockApi.disconnectFacebookAdminAccount(any())).thenAnswer(
        (_) async => {},
      );

      final result = await repository.disconnectFacebookAdminAccount('acc_1');

      expect(result, isTrue);
    });
  });

  group('getFacebookAdminPages', () {
    test('maps list of pages', () async {
      when(() => mockApi.getFacebookAdminPages(any())).thenAnswer(
        (_) async => [
          {'id': 'page_1', 'name': 'My Page', 'isSelected': true},
          {'id': 'page_2', 'name': 'Other Page', 'isSelected': false},
        ],
      );

      final result = await repository.getFacebookAdminPages('acc_1');

      expect(result.length, 2);
      expect(result.first.id, 'page_1');
      expect(result.first.name, 'My Page');
      expect(result.first.isSelected, isTrue);
      expect(result.last.isSelected, isFalse);
    });
  });

  group('getBroadcastDeliveryReceipts', () {
    test('maps receipts with pagination metadata', () async {
      when(
        () => mockApi.getBroadcastDeliveryReceipts(
          broadcastId: any(named: 'broadcastId'),
          query: any(named: 'query'),
        ),
      ).thenAnswer(
        (_) async => {
          'items': [
            {
              'id': 'receipt_1',
              'broadcastId': 'bc_1',
              'recipientId': 'user_1',
              'status': 'delivered',
              'sentAt': '2024-01-01T10:00:00.000Z',
              'deliveredAt': '2024-01-01T10:00:05.000Z',
            },
          ],
          'total': 50,
          'offset': 0,
          'limit': 20,
        },
      );

      final result = await repository.getBroadcastDeliveryReceipts(
        broadcastId: 'bc_1',
        query: const PaginationQuery(offset: 0, limit: 20),
      );

      expect(result.items.length, 1);
      expect(result.items.first.id, 'receipt_1');
      expect(result.items.first.status, 'delivered');
      expect(result.total, 50);
      expect(result.limit, 20);
    });
  });

  group('getBroadcastRecipients', () {
    test('maps recipients with tags', () async {
      when(
        () => mockApi.getBroadcastRecipients(query: any(named: 'query')),
      ).thenAnswer(
        (_) async => {
          'items': [
            {
              'id': 'user_1',
              'displayName': 'Nguyen Van A',
              'channelAddress': 'fb_12345',
              'segmentValue': 'vip',
              'tags': ['tag_a', 'tag_b'],
            },
          ],
          'total': 1,
          'offset': 0,
          'limit': 10,
        },
      );

      final result = await repository.getBroadcastRecipients(
        query: const BroadcastRecipientsQuery(
          broadcastId: 'bc_1',
          filter: BroadcastRecipientsFilter(),
        ),
      );

      expect(result.items.first.id, 'user_1');
      expect(result.items.first.displayName, 'Nguyen Van A');
      expect(result.items.first.tags, ['tag_a', 'tag_b']);
    });
  });
}
