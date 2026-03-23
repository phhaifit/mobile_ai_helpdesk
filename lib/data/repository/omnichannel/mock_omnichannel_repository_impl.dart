import 'dart:async';
import 'dart:math';

import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';

class MockOmnichannelRepositoryImpl implements OmnichannelRepository {
  final Random _random = Random();

  OmnichannelOverview _state = OmnichannelOverview(
    messenger: MessengerIntegrationState(
      connectionStatus: IntegrationConnectionStatus.disconnected,
      oauthState: OAuthState.unverified,
      pageName: 'Jarvis Helpdesk Fanpage',
      lastSyncAt: null,
      syncedCustomers: 0,
      failedCustomers: 0,
      autoReply: false,
      language: 'vi',
      businessHours: '08:00 - 18:00',
    ),
    zalo: ZaloIntegrationState(
      connectionStatus: IntegrationConnectionStatus.disconnected,
      oauthState: OAuthState.unverified,
      syncState: SyncState.offline,
      accountName: 'Jarvis OA',
      lastMessageSyncAt: null,
      assignments: const [
        ZaloAccountAssignment(
          accountId: 'zalo_01',
          accountName: 'Zalo OA Main Inbox',
          assignedCs: 'Nguyen Ha Linh',
        ),
        ZaloAccountAssignment(
          accountId: 'zalo_02',
          accountName: 'Zalo OA VIP',
          assignedCs: 'Tran Minh Quan',
        ),
        ZaloAccountAssignment(
          accountId: 'zalo_03',
          accountName: 'Zalo OA Support 24/7',
          assignedCs: 'Le Thu Anh',
        ),
      ],
    ),
  );

  @override
  Future<OmnichannelOverview> getOverview() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return _state;
  }

  @override
  Future<ActionFeedback> connectMessenger() async {
    await Future.delayed(const Duration(milliseconds: 700));
    _state = _state.copyWith(
      messenger: _state.messenger.copyWith(
        connectionStatus: IntegrationConnectionStatus.connected,
        oauthState: OAuthState.verified,
        lastSyncAt: DateTime.now(),
      ),
    );
    return const ActionFeedback(
      isSuccess: true,
      messageKey: 'omnichannel_messenger_connect_success',
    );
  }

  @override
  Future<ActionFeedback> disconnectMessenger() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _state = _state.copyWith(
      messenger: _state.messenger.copyWith(
        connectionStatus: IntegrationConnectionStatus.disconnected,
        oauthState: OAuthState.unverified,
      ),
    );
    return const ActionFeedback(
      isSuccess: true,
      messageKey: 'omnichannel_messenger_disconnect_success',
    );
  }

  @override
  Future<ActionFeedback> syncMessengerData() async {
    await Future.delayed(const Duration(milliseconds: 650));

    if (_state.messenger.connectionStatus !=
        IntegrationConnectionStatus.connected) {
      return const ActionFeedback(
        isSuccess: false,
        messageKey: 'omnichannel_action_requires_connection',
      );
    }

    final int synced = 20 + _random.nextInt(80);
    final int failed = _random.nextInt(6);

    _state = _state.copyWith(
      messenger: _state.messenger.copyWith(
        lastSyncAt: DateTime.now(),
        syncedCustomers: synced,
        failedCustomers: failed,
      ),
    );

    return const ActionFeedback(
      isSuccess: true,
      messageKey: 'omnichannel_messenger_sync_success',
    );
  }

  @override
  Future<ActionFeedback> updateMessengerSettings(
    MessengerSettingsUpdate update,
  ) async {
    await Future.delayed(const Duration(milliseconds: 450));

    if (_state.messenger.connectionStatus !=
        IntegrationConnectionStatus.connected) {
      return const ActionFeedback(
        isSuccess: false,
        messageKey: 'omnichannel_action_requires_connection',
      );
    }

    _state = _state.copyWith(
      messenger: _state.messenger.copyWith(
        autoReply: update.autoReply,
        language: update.language,
        businessHours: update.businessHours,
      ),
    );

    return const ActionFeedback(
      isSuccess: true,
      messageKey: 'omnichannel_messenger_settings_saved',
    );
  }

  @override
  Future<ActionFeedback> connectZaloFromQr() async {
    await Future.delayed(const Duration(milliseconds: 900));
    _state = _state.copyWith(
      zalo: _state.zalo.copyWith(
        connectionStatus: IntegrationConnectionStatus.connected,
        oauthState: OAuthState.verified,
        syncState: SyncState.healthy,
        lastMessageSyncAt: DateTime.now(),
      ),
    );
    return const ActionFeedback(
      isSuccess: true,
      messageKey: 'omnichannel_zalo_connect_success',
    );
  }

  @override
  Future<ActionFeedback> disconnectZalo() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _state = _state.copyWith(
      zalo: _state.zalo.copyWith(
        connectionStatus: IntegrationConnectionStatus.disconnected,
        oauthState: OAuthState.unverified,
        syncState: SyncState.offline,
      ),
    );
    return const ActionFeedback(
      isSuccess: true,
      messageKey: 'omnichannel_zalo_disconnect_success',
    );
  }

  @override
  Future<ActionFeedback> retryZaloSync() async {
    await Future.delayed(const Duration(milliseconds: 550));

    if (_state.zalo.connectionStatus != IntegrationConnectionStatus.connected) {
      return const ActionFeedback(
        isSuccess: false,
        messageKey: 'omnichannel_action_requires_connection',
      );
    }

    final bool healthy = _random.nextBool();
    _state = _state.copyWith(
      zalo: _state.zalo.copyWith(
        syncState: healthy ? SyncState.healthy : SyncState.degraded,
        lastMessageSyncAt: DateTime.now(),
      ),
    );

    return ActionFeedback(
      isSuccess: true,
      messageKey: healthy
          ? 'omnichannel_zalo_sync_healthy'
          : 'omnichannel_zalo_sync_degraded',
    );
  }

  @override
  Future<ActionFeedback> updateZaloAssignments(
    List<ZaloAssignmentUpdate> updates,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final Map<String, String> mapping = {
      for (final ZaloAssignmentUpdate update in updates)
        update.accountId: update.assignedCs,
    };

    final List<ZaloAccountAssignment> nextAssignments = _state.zalo.assignments
        .map(
          (item) => item.copyWith(
            assignedCs: mapping[item.accountId] ?? item.assignedCs,
          ),
        )
        .toList(growable: false);

    _state = _state.copyWith(
      zalo: _state.zalo.copyWith(assignments: nextAssignments),
    );

    return const ActionFeedback(
      isSuccess: true,
      messageKey: 'omnichannel_zalo_assignment_saved',
    );
  }
}
