import 'dart:async';

import 'package:ai_helpdesk/data/network/apis/omnichannel/omnichannel_api.dart';
import 'package:ai_helpdesk/data/repository/omnichannel/mock_omnichannel_repository_impl.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';
import 'package:dio/dio.dart';

class OmnichannelRepositoryImpl implements OmnichannelRepository {
  final OmnichannelApi _api;
  final MockOmnichannelRepositoryImpl _fallbackRepository;

  OmnichannelRepositoryImpl(
    this._api, {
    MockOmnichannelRepositoryImpl? fallbackRepository,
  }) : _fallbackRepository =
           fallbackRepository ?? MockOmnichannelRepositoryImpl();

  @override
  Future<OmnichannelOverview> getOverview() async {
    final OmnichannelOverview fallback =
        await _fallbackRepository.getOverview();

    // 1. Messenger logic
    final List<MessengerPageDto> pages = await _api.getMessengerPages();
    MessengerPageDto? connectedPage;
    for (final MessengerPageDto page in pages) {
      if (page.connected) {
        connectedPage = page;
        break;
      }
    }

    MessengerIntegrationState messengerState = fallback.messenger;
    if (connectedPage != null) {
      messengerState = fallback.messenger.copyWith(
        connectionStatus: IntegrationConnectionStatus.connected,
        oauthState: OAuthState.verified,
        pageName:
            connectedPage.name.isNotEmpty
                ? connectedPage.name
                : fallback.messenger.pageName,
        autoReply: connectedPage.autoReply ?? fallback.messenger.autoReply,
        businessHours:
            connectedPage.businessHours ?? fallback.messenger.businessHours,
        lastSyncAt: connectedPage.lastSyncAt ?? fallback.messenger.lastSyncAt,
      );
    } else {
      messengerState = fallback.messenger.copyWith(
        connectionStatus: IntegrationConnectionStatus.disconnected,
        oauthState: OAuthState.unverified,
      );
    }

    // 2. Zalo logic
    List<ZaloAccountAssignment> assignments = [];
    IntegrationConnectionStatus zaloConnStatus =
        IntegrationConnectionStatus.disconnected;
    OAuthState zaloOauthState = OAuthState.unverified;
    SyncState zaloSyncState = SyncState.offline;

    try {
      final List<ZaloPersonalConnectionDto> zaloConnections =
          await _api.getZaloPersonalConnections();
      if (zaloConnections.isNotEmpty) {
        zaloConnStatus = IntegrationConnectionStatus.connected;
        zaloOauthState = OAuthState.verified;
        zaloSyncState = SyncState.healthy;
        assignments =
            zaloConnections.map((c) => c.toAssignment()).toList();
      }
    } catch (_) {
      // Keep disconnected on error
    }

    return fallback.copyWith(
      messenger: messengerState,
      zalo: fallback.zalo.copyWith(
        connectionStatus: zaloConnStatus,
        oauthState: zaloOauthState,
        syncState: zaloSyncState,
        assignments: assignments.isNotEmpty ? assignments : fallback.zalo.assignments,
      ),
    );
  }

  @override
  Future<ActionFeedback> disconnectMessenger({String? channelId}) async {
    try {
      String resolvedChannelId = channelId?.trim() ?? '';

      if (resolvedChannelId.isEmpty) {
        final List<MessengerPageDto> pages = await _api.getMessengerPages();
        for (final MessengerPageDto page in pages) {
          if (page.connected) {
            resolvedChannelId =
                page.channelId.isNotEmpty ? page.channelId : page.id;
            break;
          }
        }
      }

      if (resolvedChannelId.isEmpty) {
        return const ActionFeedback(
          isSuccess: false,
          messageKey: 'omnichannel_action_requires_connection',
        );
      }

      await _api.deleteMessengerPage(resolvedChannelId);

      return const ActionFeedback(
        isSuccess: true,
        messageKey: 'omnichannel_messenger_disconnect_success',
      );
    } on DioException {
      return const ActionFeedback(
        isSuccess: false,
        messageKey: 'omnichannel_messenger_disconnect_failed',
      );
    }
  }

  @override
  Future<ActionFeedback> syncMessengerData() async {
    try {
      final String? channelId = await _resolveConnectedMessengerChannelId();
      if (channelId == null) {
        return const ActionFeedback(
          isSuccess: false,
          messageKey: 'omnichannel_action_requires_connection',
        );
      }

      await _api.resyncMessengerPage(channelId);
      return const ActionFeedback(
        isSuccess: true,
        messageKey: 'omnichannel_messenger_sync_success',
      );
    } on DioException {
      return const ActionFeedback(
        isSuccess: false,
        messageKey: 'omnichannel_messenger_sync_failed',
      );
    }
  }

  @override
  Future<ActionFeedback> updateMessengerSettings(
    MessengerSettingsUpdate update,
  ) async {
    try {
      final String? channelId = await _resolveConnectedMessengerChannelId();
      if (channelId == null) {
        return const ActionFeedback(
          isSuccess: false,
          messageKey: 'omnichannel_action_requires_connection',
        );
      }

      await _api.updateMessengerPageConfig(
        channelId: channelId,
        autoReply: update.autoReply,
        greeting: update.businessHours,
      );

      return const ActionFeedback(
        isSuccess: true,
        messageKey: 'omnichannel_messenger_settings_saved',
      );
    } on DioException {
      return const ActionFeedback(
        isSuccess: false,
        messageKey: 'omnichannel_messenger_settings_failed',
      );
    }
  }

  @override
  Future<ZaloQr> generateZaloQr() async {
    try {
      final ZaloQrDto dto = await _api.generateZaloQr();
      return dto.toEntity();
    } on DioException {
      return _fallbackRepository.generateZaloQr();
    }
  }

  @override
  Future<ZaloQrStatusUpdate> getZaloQrStatus(String code) async {
    try {
      final ZaloQrStatusDto dto = await _api.getZaloQrStatus(code);
      return dto.toEntity();
    } on DioException {
      return _fallbackRepository.getZaloQrStatus(code);
    }
  }

  @override
  Future<ActionFeedback> connectZalo(String authCode) async {
    final String normalizedCode = authCode.trim();
    if (normalizedCode.isEmpty) {
      return const ActionFeedback(
        isSuccess: false,
        messageKey: 'omnichannel_zalo_auth_code_required',
      );
    }

    try {
      await _api.connectZalo(normalizedCode);
      return const ActionFeedback(
        isSuccess: true,
        messageKey: 'omnichannel_zalo_connect_success',
      );
    } on DioException {
      return const ActionFeedback(
        isSuccess: false,
        messageKey: 'omnichannel_zalo_connect_failed',
      );
    }
  }

  @override
  Future<ActionFeedback> disconnectZalo() async {
    try {
      await _api.revokeZaloOauth();
      return const ActionFeedback(
        isSuccess: true,
        messageKey: 'omnichannel_zalo_disconnect_success',
      );
    } on DioException {
      return const ActionFeedback(
        isSuccess: false,
        messageKey: 'omnichannel_zalo_disconnect_failed',
      );
    }
  }

  @override
  Future<ActionFeedback> retryZaloSync() async {
    try {
      await _api.syncZaloLatestMessages();
      return const ActionFeedback(
        isSuccess: true,
        messageKey: 'omnichannel_zalo_sync_healthy',
      );
    } on DioException {
      return const ActionFeedback(
        isSuccess: false,
        messageKey: 'omnichannel_zalo_sync_failed',
      );
    }
  }

  @override
  Future<ActionFeedback> updateZaloAssignments(
    List<ZaloAssignmentUpdate> updates,
  ) async {
    try {
      for (final update in updates) {
        await _api.assignZaloCs(
          channelId: update.accountId,
          customerSupportId: update.assignedCs,
        );
      }
      return const ActionFeedback(
        isSuccess: true,
        messageKey: 'omnichannel_zalo_assignment_saved',
      );
    } on DioException {
      return const ActionFeedback(
        isSuccess: false,
        messageKey: 'omnichannel_zalo_assignment_failed',
      );
    }
  }

  @override
  Future<ActionFeedback> sendZaloMessage({
    required String recipient,
    required String message,
  }) async {
    try {
      await _api.sendZaloMessage(recipient: recipient, message: message);
      return const ActionFeedback(
        isSuccess: true,
        messageKey: 'omnichannel_zalo_message_send_success',
      );
    } on DioException {
      return const ActionFeedback(
        isSuccess: false,
        messageKey: 'omnichannel_zalo_message_send_failed',
      );
    }
  }

  Future<String?> _resolveConnectedMessengerChannelId() async {
    final List<MessengerPageDto> pages = await _api.getMessengerPages();
    for (final MessengerPageDto page in pages) {
      if (page.connected) {
        final String channelId = page.channelId.trim();
        if (channelId.isNotEmpty) {
          return channelId;
        }

        final String fallbackId = page.id.trim();
        if (fallbackId.isNotEmpty) {
          return fallbackId;
        }
      }
    }

    return null;
  }
}
