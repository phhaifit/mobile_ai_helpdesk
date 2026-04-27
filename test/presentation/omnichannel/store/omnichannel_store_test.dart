import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/connect_messenger_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/connect_zalo_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/disconnect_messenger_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/disconnect_zalo_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/generate_zalo_qr_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/get_omnichannel_overview_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/get_zalo_qr_status_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/retry_zalo_sync_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/sync_messenger_data_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/update_messenger_settings_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/update_zalo_assignments_usecase.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRepository implements OmnichannelRepository {
  ZaloQr? mockedQr;
  ZaloQrStatusUpdate? mockedStatus;
  OmnichannelOverview? mockedOverview;

  @override
  Future<ZaloQr> generateZaloQr() async => mockedQr!;

  @override
  Future<ZaloQrStatusUpdate> getZaloQrStatus(String qrCode) async => mockedStatus!;

  @override
  Future<ActionFeedback> connectZalo(String authCode) async =>
      const ActionFeedback(isSuccess: true, messageKey: 'success');

  @override
  Future<OmnichannelOverview> getOverview() async => mockedOverview!;

  @override
  Future<ActionFeedback> disconnectZalo() async =>
      const ActionFeedback(isSuccess: true, messageKey: 'success');

  @override
  Future<ActionFeedback> connectMessenger({String? authCode}) async =>
      const ActionFeedback(isSuccess: true, messageKey: 'success');

  @override
  Future<ActionFeedback> disconnectMessenger({String? channelId}) async =>
      const ActionFeedback(isSuccess: true, messageKey: 'success');

  @override
  Future<ActionFeedback> retryZaloSync() async =>
      const ActionFeedback(isSuccess: true, messageKey: 'success');

  @override
  Future<ActionFeedback> syncMessengerData() async =>
      const ActionFeedback(isSuccess: true, messageKey: 'success');

  @override
  Future<ActionFeedback> updateMessengerSettings(MessengerSettingsUpdate settings) async =>
      const ActionFeedback(isSuccess: true, messageKey: 'success');

  @override
  Future<ActionFeedback> updateZaloAssignments(List<ZaloAssignmentUpdate> updates) async =>
      const ActionFeedback(isSuccess: true, messageKey: 'success');
}

void main() {
  group('OmnichannelStore Tests', () {
    late OmnichannelStore store;
    late MockRepository repository;

    setUp(() {
      repository = MockRepository();
      store = OmnichannelStore(
        GetOmnichannelOverviewUseCase(repository),
        ConnectMessengerUseCase(repository),
        DisconnectMessengerUseCase(repository),
        SyncMessengerDataUseCase(repository),
        UpdateMessengerSettingsUseCase(repository),
        DisconnectZaloUseCase(repository),
        RetryZaloSyncUseCase(repository),
        UpdateZaloAssignmentsUseCase(repository),
        GenerateZaloQrUseCase(repository),
        GetZaloQrStatusUseCase(repository),
        ConnectZaloUseCase(repository),
      );
    });

    test('Initial state is correct', () {
      expect(store.isLoading, isFalse);
      expect(store.overview, isNull);
      expect(store.zaloQr, isNull);
    });

    test('startZaloQrFlow sets loading and fetches QR', () async {
      repository.mockedQr = const ZaloQr(
        code: 'code',
        url: 'url',
      );
      
      final future = store.startZaloQrFlow();
      
      expect(store.isLoading, isTrue);
      
      await future;
      
      expect(store.zaloQr?.code, 'code');
      expect(store.isLoading, isFalse);
      
      store.dispose();
    });

    test('fetchOverview updates overview state', () async {
      final overview = OmnichannelOverview(
        messenger: MessengerIntegrationState(
          connectionStatus: IntegrationConnectionStatus.disconnected,
          oauthState: OAuthState.unverified,
          pageName: 'Mock Page',
          lastSyncAt: DateTime.now(),
          autoReply: false,
          language: 'vi',
          businessHours: '',
        ),
        zalo: ZaloIntegrationState(
          connectionStatus: IntegrationConnectionStatus.disconnected,
          oauthState: OAuthState.unverified,
          accountName: 'Mock Zalo',
          syncState: SyncState.offline,
          assignments: [],
          lastMessageSyncAt: DateTime.now(),
        ),
      );
      repository.mockedOverview = overview;

      await store.fetchOverview();

      expect(store.overview, isNotNull);
      expect(store.overview?.zalo.accountName, 'Mock Zalo');
    });
  });
}
