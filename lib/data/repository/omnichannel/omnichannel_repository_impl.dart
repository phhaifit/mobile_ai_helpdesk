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

    try {
      final List<MessengerPageDto> pages = await _api.getMessengerPages();
      MessengerPageDto? connectedPage;
      for (final MessengerPageDto page in pages) {
        if (page.connected) {
          connectedPage = page;
          break;
        }
      }

      if (connectedPage == null) {
        return fallback.copyWith(
          messenger: fallback.messenger.copyWith(
            connectionStatus: IntegrationConnectionStatus.disconnected,
            oauthState: OAuthState.unverified,
          ),
        );
      }

      return fallback.copyWith(
        messenger: fallback.messenger.copyWith(
          connectionStatus: IntegrationConnectionStatus.connected,
          oauthState: OAuthState.verified,
          pageName:
              connectedPage.name.isNotEmpty
                  ? connectedPage.name
                  : fallback.messenger.pageName,
        ),
      );
    } on DioException {
      // Phase 1 keeps UX stable by falling back to mock data when API is not ready.
      return fallback;
    }
  }

  @override
  Future<ActionFeedback> connectMessenger() {
    // Phase 2 will wire the full API connect flow.
    return _fallbackRepository.connectMessenger();
  }

  @override
  Future<ActionFeedback> disconnectMessenger() {
    // Phase 2 will wire the full API disconnect flow.
    return _fallbackRepository.disconnectMessenger();
  }

  @override
  Future<ActionFeedback> syncMessengerData() {
    // Phase 3 will wire sync and customer APIs.
    return _fallbackRepository.syncMessengerData();
  }

  @override
  Future<ActionFeedback> updateMessengerSettings(
    MessengerSettingsUpdate update,
  ) {
    // Phase 3 will wire settings API.
    return _fallbackRepository.updateMessengerSettings(update);
  }

  @override
  Future<ActionFeedback> connectZaloFromQr() {
    return _fallbackRepository.connectZaloFromQr();
  }

  @override
  Future<ActionFeedback> disconnectZalo() {
    return _fallbackRepository.disconnectZalo();
  }

  @override
  Future<ActionFeedback> retryZaloSync() {
    return _fallbackRepository.retryZaloSync();
  }

  @override
  Future<ActionFeedback> updateZaloAssignments(
    List<ZaloAssignmentUpdate> updates,
  ) {
    return _fallbackRepository.updateZaloAssignments(updates);
  }
}
