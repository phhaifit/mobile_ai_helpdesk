import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/create_broadcast_template_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/create_broadcast_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/create_facebook_admin_account_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/delete_broadcast_template_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/delete_broadcast_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/disconnect_facebook_admin_account_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/execute_broadcast_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_broadcast_recipients_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_broadcast_templates_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_broadcasts_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_delivery_receipts_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_facebook_admin_accounts_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_facebook_admin_pages_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/reauth_facebook_admin_account_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/resume_broadcast_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/select_facebook_admin_page_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/stop_broadcast_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/update_broadcast_template_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/update_broadcast_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMarketingBroadcastRepository extends Mock
    implements MarketingBroadcastRepository {}

void main() {
  late MockMarketingBroadcastRepository mockRepo;

  final tCreatedAt = DateTime(2024, 1, 1);

  final tTemplate = BroadcastTemplate(
    id: 'tpl_1',
    name: 'Test Template',
    content: 'Hello {{name}}',
    variableKeys: const ['name'],
    isActive: true,
    createdAt: tCreatedAt,
  );

  final tBroadcastItem = BroadcastItem(
    id: 'bc_1',
    name: 'Campaign 1',
    templateId: 'tpl_1',
    status: BroadcastStatus.draft,
    recipientCount: 0,
    sentCount: 0,
    deliveredCount: 0,
    failedCount: 0,
    createdAt: tCreatedAt,
  );

  const tFacebookAccount = FacebookAdAccount(
    id: 'acc_1',
    adminName: 'Admin',
    adminEmail: 'admin@test.com',
    pageId: 'page_1',
    status: 'connected',
  );

  const tFacebookPage = FacebookPage(
    id: 'page_1',
    name: 'My Page',
    isSelected: true,
  );

  setUpAll(() {
    registerFallbackValue(const BroadcastTemplateQuery());
    registerFallbackValue(const BroadcastQuery());
    registerFallbackValue(
      const BroadcastTemplateUpsertData(
        name: '',
        content: '',
        variableKeys: [],
      ),
    );
    registerFallbackValue(
      const BroadcastUpsertData(name: '', templateId: ''),
    );
    registerFallbackValue(
      const BroadcastRecipientsQuery(
        broadcastId: '',
        filter: BroadcastRecipientsFilter(),
      ),
    );
    registerFallbackValue(const PaginationQuery(offset: 0, limit: 20));
    registerFallbackValue(
      const FacebookAdminAccountCreateData(accessToken: ''),
    );
  });

  setUp(() {
    mockRepo = MockMarketingBroadcastRepository();
  });

  group('GetBroadcastTemplatesUseCase', () {
    test('delegates query to repository and returns page', () async {
      final page = BroadcastPage<BroadcastTemplate>(
        items: [tTemplate],
        total: 1,
        offset: 0,
        limit: 10,
      );
      when(
        () => mockRepo.getBroadcastTemplates(query: any(named: 'query')),
      ).thenAnswer((_) async => page);

      final result = await GetBroadcastTemplatesUseCase(mockRepo).call(
        params: const GetBroadcastTemplatesParams(
          query: BroadcastTemplateQuery(search: 'hello', limit: 10),
        ),
      );

      expect(result.items.first.id, 'tpl_1');
      verify(
        () => mockRepo.getBroadcastTemplates(query: any(named: 'query')),
      ).called(1);
    });
  });

  group('CreateBroadcastTemplateUseCase', () {
    test('delegates data to repository', () async {
      when(() => mockRepo.createBroadcastTemplate(any())).thenAnswer(
        (_) async => tTemplate,
      );

      final result = await CreateBroadcastTemplateUseCase(mockRepo).call(
        params: const CreateBroadcastTemplateParams(
          data: BroadcastTemplateUpsertData(
            name: 'Test',
            content: 'Body',
            variableKeys: [],
          ),
        ),
      );

      expect(result.id, 'tpl_1');
      verify(() => mockRepo.createBroadcastTemplate(any())).called(1);
    });
  });

  group('UpdateBroadcastTemplateUseCase', () {
    test('passes templateId and data to repository', () async {
      when(
        () => mockRepo.updateBroadcastTemplate(
          templateId: any(named: 'templateId'),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => tTemplate);

      final result = await UpdateBroadcastTemplateUseCase(mockRepo).call(
        params: const UpdateBroadcastTemplateParams(
          templateId: 'tpl_1',
          data: BroadcastTemplateUpsertData(
            name: 'Updated',
            content: 'Body',
            variableKeys: [],
          ),
        ),
      );

      expect(result.id, 'tpl_1');
      verify(
        () => mockRepo.updateBroadcastTemplate(
          templateId: 'tpl_1',
          data: any(named: 'data'),
        ),
      ).called(1);
    });
  });

  group('DeleteBroadcastTemplateUseCase', () {
    test('passes templateId to repository and returns true', () async {
      when(() => mockRepo.deleteBroadcastTemplate(any())).thenAnswer(
        (_) async => true,
      );

      final result = await DeleteBroadcastTemplateUseCase(mockRepo).call(
        params: const DeleteBroadcastTemplateParams(templateId: 'tpl_1'),
      );

      expect(result, isTrue);
      verify(() => mockRepo.deleteBroadcastTemplate('tpl_1')).called(1);
    });
  });

  group('GetBroadcastsUseCase', () {
    test('delegates query to repository', () async {
      final page = BroadcastPage<BroadcastItem>(
        items: [tBroadcastItem],
        total: 1,
        offset: 0,
        limit: 10,
      );
      when(
        () => mockRepo.getBroadcasts(query: any(named: 'query')),
      ).thenAnswer((_) async => page);

      final result = await GetBroadcastsUseCase(mockRepo).call(
        params: const GetBroadcastsParams(
          query: BroadcastQuery(status: BroadcastStatus.running),
        ),
      );

      expect(result.items.first.id, 'bc_1');
      verify(
        () => mockRepo.getBroadcasts(query: any(named: 'query')),
      ).called(1);
    });
  });

  group('CreateBroadcastUseCase', () {
    test('delegates data to repository', () async {
      when(() => mockRepo.createBroadcast(any())).thenAnswer(
        (_) async => tBroadcastItem,
      );

      final result = await CreateBroadcastUseCase(mockRepo).call(
        params: const CreateBroadcastParams(
          data: BroadcastUpsertData(name: 'Campaign', templateId: 'tpl_1'),
        ),
      );

      expect(result.id, 'bc_1');
    });
  });

  group('UpdateBroadcastUseCase', () {
    test('passes broadcastId and data to repository', () async {
      when(
        () => mockRepo.updateBroadcast(
          broadcastId: any(named: 'broadcastId'),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => tBroadcastItem);

      final result = await UpdateBroadcastUseCase(mockRepo).call(
        params: const UpdateBroadcastParams(
          broadcastId: 'bc_1',
          data: BroadcastUpsertData(name: 'Updated', templateId: 'tpl_1'),
        ),
      );

      expect(result.id, 'bc_1');
      verify(
        () => mockRepo.updateBroadcast(
          broadcastId: 'bc_1',
          data: any(named: 'data'),
        ),
      ).called(1);
    });
  });

  group('DeleteBroadcastUseCase', () {
    test('passes broadcastId to repository', () async {
      when(() => mockRepo.deleteBroadcast(any())).thenAnswer(
        (_) async => true,
      );

      final result = await DeleteBroadcastUseCase(mockRepo).call(
        params: const DeleteBroadcastParams(broadcastId: 'bc_1'),
      );

      expect(result, isTrue);
      verify(() => mockRepo.deleteBroadcast('bc_1')).called(1);
    });
  });

  group('ExecuteBroadcastUseCase', () {
    test('passes broadcastId and returns updated item', () async {
      final running = BroadcastItem(
        id: 'bc_1',
        name: 'Campaign 1',
        templateId: 'tpl_1',
        status: BroadcastStatus.running,
        recipientCount: 100,
        sentCount: 0,
        deliveredCount: 0,
        failedCount: 0,
        createdAt: tCreatedAt,
      );
      when(() => mockRepo.executeBroadcast(any())).thenAnswer(
        (_) async => running,
      );

      final result = await ExecuteBroadcastUseCase(mockRepo).call(
        params: const ExecuteBroadcastParams(broadcastId: 'bc_1'),
      );

      expect(result.status, BroadcastStatus.running);
      verify(() => mockRepo.executeBroadcast('bc_1')).called(1);
    });
  });

  group('StopBroadcastUseCase', () {
    test('passes broadcastId and returns paused item', () async {
      final paused = BroadcastItem(
        id: 'bc_1',
        name: 'Campaign 1',
        templateId: 'tpl_1',
        status: BroadcastStatus.paused,
        recipientCount: 100,
        sentCount: 50,
        deliveredCount: 48,
        failedCount: 2,
        createdAt: tCreatedAt,
      );
      when(() => mockRepo.stopBroadcast(any())).thenAnswer(
        (_) async => paused,
      );

      final result = await StopBroadcastUseCase(mockRepo).call(
        params: const StopBroadcastParams(broadcastId: 'bc_1'),
      );

      expect(result.status, BroadcastStatus.paused);
      verify(() => mockRepo.stopBroadcast('bc_1')).called(1);
    });
  });

  group('ResumeBroadcastUseCase', () {
    test('passes broadcastId and returns running item', () async {
      final resumed = BroadcastItem(
        id: 'bc_1',
        name: 'Campaign 1',
        templateId: 'tpl_1',
        status: BroadcastStatus.running,
        recipientCount: 100,
        sentCount: 50,
        deliveredCount: 48,
        failedCount: 2,
        createdAt: tCreatedAt,
      );
      when(() => mockRepo.resumeBroadcast(any())).thenAnswer(
        (_) async => resumed,
      );

      final result = await ResumeBroadcastUseCase(mockRepo).call(
        params: const ResumeBroadcastParams(broadcastId: 'bc_1'),
      );

      expect(result.status, BroadcastStatus.running);
      verify(() => mockRepo.resumeBroadcast('bc_1')).called(1);
    });
  });

  group('GetBroadcastRecipientsUseCase', () {
    test('delegates query to repository', () async {
      const page = BroadcastPage<BroadcastRecipient>(
        items: [
          BroadcastRecipient(
            id: 'user_1',
            displayName: 'Nguyen Van A',
            tags: [],
          ),
        ],
        total: 1,
        offset: 0,
        limit: 10,
      );
      when(
        () => mockRepo.getBroadcastRecipients(query: any(named: 'query')),
      ).thenAnswer((_) async => page);

      final result = await GetBroadcastRecipientsUseCase(mockRepo).call(
        params: const GetBroadcastRecipientsParams(
          query: BroadcastRecipientsQuery(
            broadcastId: 'bc_1',
            filter: BroadcastRecipientsFilter(),
          ),
        ),
      );

      expect(result.items.first.id, 'user_1');
      verify(
        () => mockRepo.getBroadcastRecipients(query: any(named: 'query')),
      ).called(1);
    });
  });

  group('GetDeliveryReceiptsUseCase', () {
    test('passes broadcastId and pagination query to repository', () async {
      const page = BroadcastPage<BroadcastDeliveryReceipt>(
        items: [
          const BroadcastDeliveryReceipt(
            id: 'r_1',
            broadcastId: 'bc_1',
            recipientId: 'user_1',
            status: 'delivered',
          ),
        ],
        total: 1,
        offset: 0,
        limit: 20,
      );
      when(
        () => mockRepo.getBroadcastDeliveryReceipts(
          broadcastId: any(named: 'broadcastId'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => page);

      final result = await GetDeliveryReceiptsUseCase(mockRepo).call(
        params: const GetDeliveryReceiptsParams(
          broadcastId: 'bc_1',
          query: PaginationQuery(offset: 0, limit: 20),
        ),
      );

      expect(result.items.first.id, 'r_1');
      verify(
        () => mockRepo.getBroadcastDeliveryReceipts(
          broadcastId: 'bc_1',
          query: any(named: 'query'),
        ),
      ).called(1);
    });
  });

  group('GetFacebookAdminAccountsUseCase', () {
    test('returns list of accounts from repository', () async {
      when(() => mockRepo.getFacebookAdminAccounts()).thenAnswer(
        (_) async => [tFacebookAccount],
      );

      final result = await GetFacebookAdminAccountsUseCase(mockRepo).call(
        params: null,
      );

      expect(result.length, 1);
      expect(result.first.id, 'acc_1');
      verify(() => mockRepo.getFacebookAdminAccounts()).called(1);
    });
  });

  group('CreateFacebookAdminAccountUseCase', () {
    test('delegates data to repository', () async {
      when(() => mockRepo.createFacebookAdminAccount(any())).thenAnswer(
        (_) async => tFacebookAccount,
      );

      final result = await CreateFacebookAdminAccountUseCase(mockRepo).call(
        params: const CreateFacebookAdminAccountParams(
          data: FacebookAdminAccountCreateData(accessToken: 'token_abc'),
        ),
      );

      expect(result.id, 'acc_1');
      verify(() => mockRepo.createFacebookAdminAccount(any())).called(1);
    });
  });

  group('DisconnectFacebookAdminAccountUseCase', () {
    test('passes accountId to repository', () async {
      when(() => mockRepo.disconnectFacebookAdminAccount(any())).thenAnswer(
        (_) async => true,
      );

      final result = await DisconnectFacebookAdminAccountUseCase(mockRepo).call(
        params: const DisconnectFacebookAdminAccountParams(accountId: 'acc_1'),
      );

      expect(result, isTrue);
      verify(() => mockRepo.disconnectFacebookAdminAccount('acc_1')).called(1);
    });
  });

  group('ReauthFacebookAdminAccountUseCase', () {
    test('passes accountId and accessToken to repository', () async {
      when(
        () => mockRepo.reauthFacebookAdminAccount(
          accountId: any(named: 'accountId'),
          accessToken: any(named: 'accessToken'),
        ),
      ).thenAnswer((_) async => tFacebookAccount);

      final result = await ReauthFacebookAdminAccountUseCase(mockRepo).call(
        params: const ReauthFacebookAdminAccountParams(
          accountId: 'acc_1',
          accessToken: 'new_token',
        ),
      );

      expect(result.id, 'acc_1');
      verify(
        () => mockRepo.reauthFacebookAdminAccount(
          accountId: 'acc_1',
          accessToken: 'new_token',
        ),
      ).called(1);
    });
  });

  group('GetFacebookAdminPagesUseCase', () {
    test('passes accountId to repository', () async {
      when(() => mockRepo.getFacebookAdminPages(any())).thenAnswer(
        (_) async => [tFacebookPage],
      );

      final result = await GetFacebookAdminPagesUseCase(mockRepo).call(
        params: const GetFacebookAdminPagesParams(accountId: 'acc_1'),
      );

      expect(result.length, 1);
      expect(result.first.id, 'page_1');
      verify(() => mockRepo.getFacebookAdminPages('acc_1')).called(1);
    });
  });

  group('SelectFacebookAdminPageUseCase', () {
    test('passes accountId and pageId to repository', () async {
      when(
        () => mockRepo.selectFacebookAdminPage(
          accountId: any(named: 'accountId'),
          pageId: any(named: 'pageId'),
        ),
      ).thenAnswer((_) async => tFacebookAccount);

      final result = await SelectFacebookAdminPageUseCase(mockRepo).call(
        params: const SelectFacebookAdminPageParams(
          accountId: 'acc_1',
          pageId: 'page_1',
        ),
      );

      expect(result.id, 'acc_1');
      verify(
        () => mockRepo.selectFacebookAdminPage(
          accountId: 'acc_1',
          pageId: 'page_1',
        ),
      ).called(1);
    });
  });
}
