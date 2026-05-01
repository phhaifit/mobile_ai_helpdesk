import 'dart:async';

import 'package:ai_helpdesk/data/network/realtime/marketing_broadcast_realtime_service.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
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
import 'package:ai_helpdesk/presentation/marketing/store/marketing_broadcast_store.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBroadcastTemplatesUseCase extends Mock
    implements GetBroadcastTemplatesUseCase {}

class MockCreateBroadcastTemplateUseCase extends Mock
    implements CreateBroadcastTemplateUseCase {}

class MockUpdateBroadcastTemplateUseCase extends Mock
    implements UpdateBroadcastTemplateUseCase {}

class MockDeleteBroadcastTemplateUseCase extends Mock
    implements DeleteBroadcastTemplateUseCase {}

class MockGetBroadcastsUseCase extends Mock implements GetBroadcastsUseCase {}

class MockCreateBroadcastUseCase extends Mock
    implements CreateBroadcastUseCase {}

class MockUpdateBroadcastUseCase extends Mock
    implements UpdateBroadcastUseCase {}

class MockDeleteBroadcastUseCase extends Mock
    implements DeleteBroadcastUseCase {}

class MockExecuteBroadcastUseCase extends Mock
    implements ExecuteBroadcastUseCase {}

class MockStopBroadcastUseCase extends Mock implements StopBroadcastUseCase {}

class MockResumeBroadcastUseCase extends Mock
    implements ResumeBroadcastUseCase {}

class MockGetBroadcastRecipientsUseCase extends Mock
    implements GetBroadcastRecipientsUseCase {}

class MockGetDeliveryReceiptsUseCase extends Mock
    implements GetDeliveryReceiptsUseCase {}

class MockGetFacebookAdminAccountsUseCase extends Mock
    implements GetFacebookAdminAccountsUseCase {}

class MockCreateFacebookAdminAccountUseCase extends Mock
    implements CreateFacebookAdminAccountUseCase {}

class MockDisconnectFacebookAdminAccountUseCase extends Mock
    implements DisconnectFacebookAdminAccountUseCase {}

class MockReauthFacebookAdminAccountUseCase extends Mock
    implements ReauthFacebookAdminAccountUseCase {}

class MockGetFacebookAdminPagesUseCase extends Mock
    implements GetFacebookAdminPagesUseCase {}

class MockSelectFacebookAdminPageUseCase extends Mock
    implements SelectFacebookAdminPageUseCase {}

class MockMarketingBroadcastRealtimeService extends Mock
    implements MarketingBroadcastRealtimeService {}

class MockEventBus extends Mock implements EventBus {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  late MarketingBroadcastStore store;

  late MockGetBroadcastTemplatesUseCase mockGetTemplates;
  late MockCreateBroadcastTemplateUseCase mockCreateTemplate;
  late MockUpdateBroadcastTemplateUseCase mockUpdateTemplate;
  late MockDeleteBroadcastTemplateUseCase mockDeleteTemplate;
  late MockGetBroadcastsUseCase mockGetBroadcasts;
  late MockCreateBroadcastUseCase mockCreateBroadcast;
  late MockUpdateBroadcastUseCase mockUpdateBroadcast;
  late MockDeleteBroadcastUseCase mockDeleteBroadcast;
  late MockExecuteBroadcastUseCase mockExecuteBroadcast;
  late MockStopBroadcastUseCase mockStopBroadcast;
  late MockResumeBroadcastUseCase mockResumeBroadcast;
  late MockGetBroadcastRecipientsUseCase mockGetRecipients;
  late MockGetDeliveryReceiptsUseCase mockGetReceipts;
  late MockGetFacebookAdminAccountsUseCase mockGetFbAccounts;
  late MockCreateFacebookAdminAccountUseCase mockCreateFbAccount;
  late MockDisconnectFacebookAdminAccountUseCase mockDisconnectFbAccount;
  late MockReauthFacebookAdminAccountUseCase mockReauthFbAccount;
  late MockGetFacebookAdminPagesUseCase mockGetFbPages;
  late MockSelectFacebookAdminPageUseCase mockSelectFbPage;
  late MockMarketingBroadcastRealtimeService mockRealtimeService;
  late MockEventBus mockEventBus;
  late MockAnalyticsService mockAnalytics;
  late StreamController<BroadcastStatusRealtimeEvent> realtimeController;

  final tCreatedAt = DateTime(2024, 1, 1);

  BroadcastItem makeItem({
    String id = 'bc_1',
    String name = 'Campaign 1',
    BroadcastStatus status = BroadcastStatus.draft,
  }) => BroadcastItem(
    id: id,
    name: name,
    templateId: 'tpl_1',
    status: status,
    recipientCount: 0,
    sentCount: 0,
    deliveredCount: 0,
    failedCount: 0,
    createdAt: tCreatedAt,
  );

  BroadcastTemplate makeTemplate({
    String id = 'tpl_1',
    String name = 'Template 1',
  }) => BroadcastTemplate(
    id: id,
    name: name,
    content: 'Hello {{name}}',
    variableKeys: const ['name'],
    isActive: true,
    createdAt: tCreatedAt,
  );

  FacebookAdAccount makeAccount({
    String id = 'acc_1',
    String status = 'connected',
    String? pageId = 'page_1',
  }) => FacebookAdAccount(
    id: id,
    adminName: 'Admin',
    adminEmail: 'admin@test.com',
    pageId: pageId,
    status: status,
  );

  void stubNoopAnalytics() {
    when(
      () => mockAnalytics.trackEvent(
        any(),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async {});
  }

  void stubFbPages({List<FacebookPage> pages = const []}) {
    when(
      () => mockGetFbPages.call(params: any(named: 'params')),
    ).thenAnswer((_) async => pages);
  }

  setUp(() {
    mockGetTemplates = MockGetBroadcastTemplatesUseCase();
    mockCreateTemplate = MockCreateBroadcastTemplateUseCase();
    mockUpdateTemplate = MockUpdateBroadcastTemplateUseCase();
    mockDeleteTemplate = MockDeleteBroadcastTemplateUseCase();
    mockGetBroadcasts = MockGetBroadcastsUseCase();
    mockCreateBroadcast = MockCreateBroadcastUseCase();
    mockUpdateBroadcast = MockUpdateBroadcastUseCase();
    mockDeleteBroadcast = MockDeleteBroadcastUseCase();
    mockExecuteBroadcast = MockExecuteBroadcastUseCase();
    mockStopBroadcast = MockStopBroadcastUseCase();
    mockResumeBroadcast = MockResumeBroadcastUseCase();
    mockGetRecipients = MockGetBroadcastRecipientsUseCase();
    mockGetReceipts = MockGetDeliveryReceiptsUseCase();
    mockGetFbAccounts = MockGetFacebookAdminAccountsUseCase();
    mockCreateFbAccount = MockCreateFacebookAdminAccountUseCase();
    mockDisconnectFbAccount = MockDisconnectFacebookAdminAccountUseCase();
    mockReauthFbAccount = MockReauthFacebookAdminAccountUseCase();
    mockGetFbPages = MockGetFacebookAdminPagesUseCase();
    mockSelectFbPage = MockSelectFacebookAdminPageUseCase();
    mockRealtimeService = MockMarketingBroadcastRealtimeService();
    mockEventBus = MockEventBus();
    mockAnalytics = MockAnalyticsService();

    realtimeController = StreamController<BroadcastStatusRealtimeEvent>.broadcast();
    when(() => mockEventBus.on<BroadcastStatusRealtimeEvent>()).thenAnswer(
      (_) => realtimeController.stream,
    );

    registerFallbackValue(const BroadcastTemplateQuery());
    registerFallbackValue(const BroadcastQuery());
    registerFallbackValue(
      const BroadcastTemplateUpsertData(name: '', content: '', variableKeys: []),
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

    store = MarketingBroadcastStore(
      mockGetTemplates,
      mockCreateTemplate,
      mockUpdateTemplate,
      mockDeleteTemplate,
      mockGetBroadcasts,
      mockCreateBroadcast,
      mockUpdateBroadcast,
      mockDeleteBroadcast,
      mockExecuteBroadcast,
      mockStopBroadcast,
      mockResumeBroadcast,
      mockGetRecipients,
      mockGetReceipts,
      mockGetFbAccounts,
      mockCreateFbAccount,
      mockDisconnectFbAccount,
      mockReauthFbAccount,
      mockGetFbPages,
      mockSelectFbPage,
      mockRealtimeService,
      mockEventBus,
      mockAnalytics,
    );
  });

  tearDown(() {
    realtimeController.close();
  });

  group('Initial state', () {
    test('lists are empty and flags are false', () {
      expect(store.templates, isEmpty);
      expect(store.campaigns, isEmpty);
      expect(store.facebookAccounts, isEmpty);
      expect(store.facebookPages, isEmpty);
      expect(store.receipts, isEmpty);
      expect(store.errorMessage, isNull);
      expect(store.actionMessageKey, isNull);
      expect(store.isLoading, isFalse);
      expect(store.isSubmitting, isFalse);
      expect(store.hasValidFacebookIntegration, isFalse);
    });
  });

  group('fetchTemplates', () {
    test('populates templates list on success', () async {
      final tpl = makeTemplate();
      when(
        () => mockGetTemplates.call(params: any(named: 'params')),
      ).thenAnswer(
        (_) async => BroadcastPage<BroadcastTemplate>(
          items: [tpl],
          total: 1,
          offset: 0,
          limit: 10,
        ),
      );

      await store.fetchTemplates();

      expect(store.templates.length, 1);
      expect(store.templates.first.id, 'tpl_1');
      expect(store.errorMessage, isNull);
    });

    test('replaces list on subsequent fetch', () async {
      final tpl2 = makeTemplate(id: 'tpl_2', name: 'Template 2');
      when(
        () => mockGetTemplates.call(params: any(named: 'params')),
      ).thenAnswer(
        (_) async => BroadcastPage<BroadcastTemplate>(
          items: [tpl2],
          total: 1,
          offset: 0,
          limit: 10,
        ),
      );

      store.templates.add(makeTemplate());
      await store.fetchTemplates();

      expect(store.templates.length, 1);
      expect(store.templates.first.id, 'tpl_2');
    });

    test('sets errorMessage on failure', () async {
      when(
        () => mockGetTemplates.call(params: any(named: 'params')),
      ).thenThrow(Exception('network error'));

      await store.fetchTemplates();

      expect(store.errorMessage, isNotNull);
      expect(store.templates, isEmpty);
    });
  });

  group('saveTemplate (create)', () {
    test('adds new template to list and sets success message', () async {
      final created = makeTemplate(id: 'tpl_new');
      stubNoopAnalytics();
      when(
        () => mockCreateTemplate.call(params: any(named: 'params')),
      ).thenAnswer((_) async => created);

      await store.saveTemplate(
        templateId: null,
        data: const BroadcastTemplateUpsertData(
          name: 'New',
          content: 'Body',
          variableKeys: [],
        ),
      );

      expect(store.templates.any((t) => t.id == 'tpl_new'), isTrue);
      expect(store.actionMessageKey, 'marketing_success_template_saved');
      expect(store.actionWasSuccess, isTrue);
    });
  });

  group('saveTemplate (update)', () {
    test('replaces existing template in list', () async {
      final existing = makeTemplate();
      store.templates.add(existing);

      final updated = makeTemplate(name: 'Updated Name');
      stubNoopAnalytics();
      when(
        () => mockUpdateTemplate.call(params: any(named: 'params')),
      ).thenAnswer((_) async => updated);

      await store.saveTemplate(
        templateId: 'tpl_1',
        data: const BroadcastTemplateUpsertData(
          name: 'Updated Name',
          content: 'Body',
          variableKeys: [],
        ),
      );

      expect(store.templates.length, 1);
      expect(store.templates.first.name, 'Updated Name');
    });
  });

  group('deleteTemplate', () {
    test('removes template from list on success', () async {
      store.templates.add(makeTemplate());
      stubNoopAnalytics();
      when(
        () => mockDeleteTemplate.call(params: any(named: 'params')),
      ).thenAnswer((_) async => true);

      await store.deleteTemplate('tpl_1');

      expect(store.templates, isEmpty);
      expect(store.actionMessageKey, 'marketing_success_template_deleted');
    });

    test('does not remove template when API returns false', () async {
      store.templates.add(makeTemplate());
      when(
        () => mockDeleteTemplate.call(params: any(named: 'params')),
      ).thenAnswer((_) async => false);

      await store.deleteTemplate('tpl_1');

      expect(store.templates.length, 1);
    });
  });

  group('fetchCampaigns', () {
    test('populates campaigns list on success', () async {
      when(
        () => mockGetBroadcasts.call(params: any(named: 'params')),
      ).thenAnswer(
        (_) async => BroadcastPage<BroadcastItem>(
          items: [makeItem(), makeItem(id: 'bc_2')],
          total: 2,
          offset: 0,
          limit: 10,
        ),
      );

      await store.fetchCampaigns();

      expect(store.campaigns.length, 2);
      expect(store.errorMessage, isNull);
    });

    test('sets errorMessage on failure', () async {
      when(
        () => mockGetBroadcasts.call(params: any(named: 'params')),
      ).thenThrow(Exception('timeout'));

      await store.fetchCampaigns();

      expect(store.errorMessage, isNotNull);
      expect(store.campaigns, isEmpty);
    });
  });

  group('executeCampaign', () {
    test('sets error when no valid Facebook integration', () async {
      await store.executeCampaign('bc_1');

      expect(store.errorMessage, 'marketing_error_facebook_not_connected');
      verifyNever(() => mockExecuteBroadcast.call(params: any(named: 'params')));
    });

    test('executes campaign when Facebook integration is valid', () async {
      final account = makeAccount();
      stubFbPages();
      stubNoopAnalytics();
      when(() => mockGetFbAccounts.call(params: null)).thenAnswer(
        (_) async => [account],
      );
      await store.fetchFacebookAdminAccounts();

      final running = makeItem(status: BroadcastStatus.running);
      when(
        () => mockExecuteBroadcast.call(params: any(named: 'params')),
      ).thenAnswer((_) async => running);

      await store.executeCampaign('bc_1');

      expect(store.errorMessage, isNull);
      expect(store.actionMessageKey, 'marketing_success_campaign_started');
      verify(
        () => mockExecuteBroadcast.call(params: any(named: 'params')),
      ).called(1);
    });
  });

  group('stopCampaign', () {
    test('updates campaign in list to paused', () async {
      store.campaigns.add(makeItem(status: BroadcastStatus.running));
      stubNoopAnalytics();
      final paused = makeItem(status: BroadcastStatus.paused);
      when(
        () => mockStopBroadcast.call(params: any(named: 'params')),
      ).thenAnswer((_) async => paused);

      await store.stopCampaign('bc_1');

      expect(store.campaigns.first.status, BroadcastStatus.paused);
      expect(store.actionMessageKey, 'marketing_success_campaign_stopped');
    });
  });

  group('resumeCampaign', () {
    test('updates campaign in list to running', () async {
      store.campaigns.add(makeItem(status: BroadcastStatus.paused));
      stubNoopAnalytics();
      final running = makeItem(status: BroadcastStatus.running);
      when(
        () => mockResumeBroadcast.call(params: any(named: 'params')),
      ).thenAnswer((_) async => running);

      await store.resumeCampaign('bc_1');

      expect(store.campaigns.first.status, BroadcastStatus.running);
      expect(store.actionMessageKey, 'marketing_success_campaign_resumed');
    });
  });

  group('hasValidFacebookIntegration', () {
    test('false when no account selected', () {
      expect(store.hasValidFacebookIntegration, isFalse);
    });

    test('false when account has no pageId', () async {
      final noPage = makeAccount(pageId: null);
      stubFbPages();
      when(() => mockGetFbAccounts.call(params: null)).thenAnswer(
        (_) async => [noPage],
      );
      await store.fetchFacebookAdminAccounts();

      expect(store.hasValidFacebookIntegration, isFalse);
    });

    test('false when account status is error', () async {
      final errorAccount = makeAccount(status: 'error');
      stubFbPages();
      when(() => mockGetFbAccounts.call(params: null)).thenAnswer(
        (_) async => [errorAccount],
      );
      await store.fetchFacebookAdminAccounts();

      expect(store.hasValidFacebookIntegration, isFalse);
    });

    test('true when account is connected with a page', () async {
      stubFbPages();
      when(() => mockGetFbAccounts.call(params: null)).thenAnswer(
        (_) async => [makeAccount()],
      );
      await store.fetchFacebookAdminAccounts();

      expect(store.hasValidFacebookIntegration, isTrue);
    });

    test('false when token is expired', () async {
      final expired = FacebookAdAccount(
        id: 'acc_1',
        pageId: 'page_1',
        status: 'connected',
        tokenExpiresAt: DateTime.now().subtract(const Duration(hours: 1)),
      );
      stubFbPages();
      when(() => mockGetFbAccounts.call(params: null)).thenAnswer(
        (_) async => [expired],
      );
      await store.fetchFacebookAdminAccounts();

      expect(store.hasValidFacebookIntegration, isFalse);
    });
  });

  group('fetchFacebookAdminAccounts', () {
    test('auto-selects connected account over non-connected', () async {
      final disconnected = makeAccount(id: 'acc_0', status: 'disconnected', pageId: null);
      final connected = makeAccount(id: 'acc_1');
      stubFbPages();
      when(() => mockGetFbAccounts.call(params: null)).thenAnswer(
        (_) async => [disconnected, connected],
      );

      await store.fetchFacebookAdminAccounts();

      expect(store.selectedFacebookAccountId, 'acc_1');
    });

    test('fetches pages for selected account', () async {
      final account = makeAccount();
      const page = FacebookPage(id: 'page_1', name: 'My Page', isSelected: true);
      when(() => mockGetFbAccounts.call(params: null)).thenAnswer(
        (_) async => [account],
      );
      when(
        () => mockGetFbPages.call(params: any(named: 'params')),
      ).thenAnswer((_) async => [page]);

      await store.fetchFacebookAdminAccounts();

      expect(store.facebookPages.length, 1);
      expect(store.facebookPages.first.id, 'page_1');
    });

    test('clears pages when no account is selected', () async {
      store.facebookPages.add(
        const FacebookPage(id: 'page_old', name: 'Old', isSelected: false),
      );
      when(() => mockGetFbAccounts.call(params: null)).thenAnswer(
        (_) async => [],
      );

      await store.fetchFacebookAdminAccounts();

      expect(store.facebookPages, isEmpty);
    });
  });

  group('disconnectFacebookAdminAccount', () {
    test('removes account and clears selection', () async {
      final account = makeAccount();
      store.facebookAccounts.add(account);
      store.setSelectedFacebookAccount('acc_1');
      stubNoopAnalytics();
      when(
        () => mockDisconnectFbAccount.call(params: any(named: 'params')),
      ).thenAnswer((_) async => true);

      await store.disconnectFacebookAdminAccount('acc_1');

      expect(store.facebookAccounts, isEmpty);
      expect(store.selectedFacebookAccountId, isNull);
      expect(store.actionMessageKey, 'marketing_success_facebook_disconnected');
    });

    test('does not remove account when API returns false', () async {
      store.facebookAccounts.add(makeAccount());
      when(
        () => mockDisconnectFbAccount.call(params: any(named: 'params')),
      ).thenAnswer((_) async => false);

      await store.disconnectFacebookAdminAccount('acc_1');

      expect(store.facebookAccounts.length, 1);
    });
  });

  group('fetchDeliveryReceipts', () {
    test('populates receipts on first load', () async {
      final receipts = List.generate(
        5,
        (i) => BroadcastDeliveryReceipt(
          id: 'r_$i',
          broadcastId: 'bc_1',
          recipientId: 'user_$i',
          status: 'delivered',
        ),
      );
      when(
        () => mockGetReceipts.call(params: any(named: 'params')),
      ).thenAnswer(
        (_) async => BroadcastPage<BroadcastDeliveryReceipt>(
          items: receipts,
          total: 5,
          offset: 0,
          limit: 20,
        ),
      );

      await store.fetchDeliveryReceipts('bc_1');

      expect(store.receipts.length, 5);
      expect(store.receiptsHasMore, isFalse);
      expect(store.isLoadingReceipts, isFalse);
    });

    test('appends receipts on loadMore', () async {
      final firstPage = List.generate(
        20,
        (i) => BroadcastDeliveryReceipt(
          id: 'r_$i',
          broadcastId: 'bc_1',
          recipientId: 'user_$i',
          status: 'delivered',
        ),
      );
      final secondPage = List.generate(
        5,
        (i) => BroadcastDeliveryReceipt(
          id: 'r_${i + 20}',
          broadcastId: 'bc_1',
          recipientId: 'user_${i + 20}',
          status: 'delivered',
        ),
      );

      var callCount = 0;
      when(
        () => mockGetReceipts.call(params: any(named: 'params')),
      ).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          return BroadcastPage<BroadcastDeliveryReceipt>(
            items: firstPage,
            total: 25,
            offset: 0,
            limit: 20,
          );
        }
        return BroadcastPage<BroadcastDeliveryReceipt>(
          items: secondPage,
          total: 25,
          offset: 20,
          limit: 20,
        );
      });

      await store.fetchDeliveryReceipts('bc_1');
      expect(store.receipts.length, 20);
      expect(store.receiptsHasMore, isTrue);

      await store.fetchDeliveryReceipts('bc_1', loadMore: true);
      expect(store.receipts.length, 25);
      expect(store.receiptsHasMore, isFalse);
    });

    test('sets receiptsError on failure', () async {
      when(
        () => mockGetReceipts.call(params: any(named: 'params')),
      ).thenThrow(Exception('fetch failed'));

      await store.fetchDeliveryReceipts('bc_1');

      expect(store.receiptsError, isNotNull);
      expect(store.isLoadingReceipts, isFalse);
    });
  });

  group('clearActionFeedback', () {
    test('resets message key, error, and success flag', () async {
      final created = makeTemplate(id: 'tpl_new');
      stubNoopAnalytics();
      when(
        () => mockCreateTemplate.call(params: any(named: 'params')),
      ).thenAnswer((_) async => created);
      await store.saveTemplate(
        templateId: null,
        data: const BroadcastTemplateUpsertData(
          name: 'x',
          content: 'y',
          variableKeys: [],
        ),
      );
      expect(store.actionMessageKey, isNotNull);

      store.clearActionFeedback();

      expect(store.actionMessageKey, isNull);
      expect(store.errorMessage, isNull);
      expect(store.actionWasSuccess, isTrue);
    });
  });

  group('realtime event handling', () {
    test('updates sentCount and status in campaigns list', () async {
      store.campaigns.add(makeItem(status: BroadcastStatus.running));

      realtimeController.add(
        BroadcastStatusRealtimeEvent(
          campaignId: 'bc_1',
          status: BroadcastStatus.running,
          rawStatus: 'running',
          sentCount: 42,
          deliveredCount: 40,
          failedCount: 2,
          occurredAt: DateTime.now(),
          fromWebSocket: false,
        ),
      );

      await Future<void>.delayed(Duration.zero);

      expect(store.campaigns.first.sentCount, 42);
      expect(store.campaigns.first.deliveredCount, 40);
    });

    test('ignores event for unknown campaignId', () async {
      store.campaigns.add(makeItem());

      realtimeController.add(
        BroadcastStatusRealtimeEvent(
          campaignId: 'unknown_id',
          status: BroadcastStatus.completed,
          rawStatus: 'completed',
          sentCount: 100,
          deliveredCount: 98,
          failedCount: 2,
          occurredAt: DateTime.now(),
          fromWebSocket: false,
        ),
      );

      await Future<void>.delayed(Duration.zero);

      expect(store.campaigns.first.sentCount, 0);
    });
  });
}
