import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:flutter/material.dart';

String connectionStatusKey(IntegrationConnectionStatus status) {
  switch (status) {
    case IntegrationConnectionStatus.connected:
      return 'omnichannel_status_connected';
    case IntegrationConnectionStatus.disconnected:
      return 'omnichannel_status_disconnected';
    case IntegrationConnectionStatus.connecting:
      return 'omnichannel_status_connecting';
    case IntegrationConnectionStatus.error:
      return 'omnichannel_status_error';
  }
}

String oauthStatusKey(OAuthState state) {
  switch (state) {
    case OAuthState.verified:
      return 'omnichannel_oauth_verified';
    case OAuthState.unverified:
      return 'omnichannel_oauth_unverified';
    case OAuthState.expired:
      return 'omnichannel_oauth_expired';
  }
}

String syncStateKey(SyncState state) {
  switch (state) {
    case SyncState.healthy:
      return 'omnichannel_sync_healthy';
    case SyncState.degraded:
      return 'omnichannel_sync_degraded';
    case SyncState.offline:
      return 'omnichannel_sync_offline';
  }
}

Color connectionStatusColor(IntegrationConnectionStatus status) {
  switch (status) {
    case IntegrationConnectionStatus.connected:
      return Colors.green;
    case IntegrationConnectionStatus.disconnected:
      return Colors.grey;
    case IntegrationConnectionStatus.connecting:
      return Colors.orange;
    case IntegrationConnectionStatus.error:
      return Colors.red;
  }
}

String formatDateTime(DateTime? dateTime) {
  if (dateTime == null) {
    return '--';
  }

  String twoDigits(int value) => value.toString().padLeft(2, '0');
  return '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} '
      '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
}
