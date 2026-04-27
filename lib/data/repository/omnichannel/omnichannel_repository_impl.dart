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

    MessengerIntegrationState messengerState = fallback.messenger.copyWith(
      connectionStatus: IntegrationConnectionStatus.connected,
      oauthState: OAuthState.verified,
      pageName:
          connectedPage.name.isNotEmpty
              ? connectedPage.name
              : fallback.messenger.pageName,
      autoReply: connectedPage.autoReply ?? fallback.messenger.autoReply,
      language: connectedPage.language ?? fallback.messenger.language,
      businessHours:
          connectedPage.businessHours ?? fallback.messenger.businessHours,
      lastSyncAt: connectedPage.lastSyncAt ?? fallback.messenger.lastSyncAt,
    );

    try {
      final _MessengerCustomersSummary? summary =
          await _fetchMessengerCustomersSummary();
      if (summary != null) {
        messengerState = messengerState.copyWith(
          syncedCustomers: summary.syncedCustomers,
          failedCustomers: summary.failedCustomers,
          lastSyncAt: summary.lastSyncAt ?? messengerState.lastSyncAt,
        );
      }
    } on DioException {
      // Keep connection information even when customer paging API is down.
    }

    return fallback.copyWith(messenger: messengerState);
  }

  @override
  Future<ActionFeedback> connectMessenger({String? authCode}) async {
    final String normalizedCode = authCode?.trim() ?? '';
    if (normalizedCode.isEmpty) {
      return const ActionFeedback(
        isSuccess: false,
        messageKey: 'omnichannel_messenger_auth_code_required',
      );
    }

    try {
      await _api.verifyMessengerAuthCode(normalizedCode);
      return const ActionFeedback(
        isSuccess: true,
        messageKey: 'omnichannel_messenger_connect_success',
      );
    } on DioException {
      return const ActionFeedback(
        isSuccess: false,
        messageKey: 'omnichannel_messenger_connect_failed',
      );
    }
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
      await _api.deleteZalo();
      return const ActionFeedback(
        isSuccess: true,
        messageKey: 'omnichannel_zalo_disconnect_success',
      );
    } on DioException {
      return _fallbackRepository.disconnectZalo();
    }
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

  Future<_MessengerCustomersSummary?> _fetchMessengerCustomersSummary() async {
    const int pageSize = 100;
    const int maxPages = 20;

    int offset = 0;
    int syncedCustomers = 0;
    int failedCustomers = 0;
    int pageCounter = 0;
    DateTime? latestSyncAt;

    while (pageCounter < maxPages) {
      final dynamic response = await _api.getMessengerCustomers(
        offset: offset,
        limit: pageSize,
      );
      final dynamic payload = _unwrapResponseData(response);
      final List<Map<String, dynamic>> customers = _extractCustomers(payload);

      if (customers.isEmpty) {
        if (pageCounter == 0 && payload is Map<String, dynamic>) {
          final _MessengerCustomersSummary? mappedSummary =
              _extractSummaryFromMeta(payload);
          if (mappedSummary != null) {
            return mappedSummary;
          }
        }
        break;
      }

      for (final Map<String, dynamic> customer in customers) {
        final bool failed = _isCustomerSyncFailed(customer);
        if (failed) {
          failedCustomers++;
        } else {
          syncedCustomers++;
        }

        final DateTime? customerSyncAt = _readDateTime(customer, const <String>[
          'syncedAt',
          'synced_at',
          'lastSyncAt',
          'last_sync_at',
          'updatedAt',
          'updated_at',
          'createdAt',
          'created_at',
        ]);
        if (customerSyncAt != null &&
            (latestSyncAt == null || customerSyncAt.isAfter(latestSyncAt))) {
          latestSyncAt = customerSyncAt;
        }
      }

      pageCounter++;
      if (customers.length < pageSize) {
        break;
      }

      offset += pageSize;
    }

    if (syncedCustomers == 0 && failedCustomers == 0 && latestSyncAt == null) {
      return null;
    }

    return _MessengerCustomersSummary(
      syncedCustomers: syncedCustomers,
      failedCustomers: failedCustomers,
      lastSyncAt: latestSyncAt,
    );
  }
}

class _MessengerCustomersSummary {
  final int syncedCustomers;
  final int failedCustomers;
  final DateTime? lastSyncAt;

  const _MessengerCustomersSummary({
    required this.syncedCustomers,
    required this.failedCustomers,
    this.lastSyncAt,
  });
}

dynamic _unwrapResponseData(dynamic response) {
  if (response is Response) {
    return _unwrapResponseData(response.data);
  }

  if (response is! Map) {
    return response;
  }

  final Map<String, dynamic> map = Map<String, dynamic>.from(response);
  return map['data'] ?? map['result'] ?? map['payload'] ?? map;
}

List<Map<String, dynamic>> _extractCustomers(dynamic payload) {
  if (payload is List) {
    return payload
        .whereType<Map<Object?, Object?>>()
        .map((Map<Object?, Object?> item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }

  if (payload is! Map) {
    return const <Map<String, dynamic>>[];
  }

  final Map<String, dynamic> map = Map<String, dynamic>.from(payload);
  final dynamic rawList =
      map['customers'] ?? map['items'] ?? map['results'] ?? map['data'];

  if (rawList is! List) {
    return const <Map<String, dynamic>>[];
  }

  return rawList
      .whereType<Map<Object?, Object?>>()
      .map((Map<Object?, Object?> item) => Map<String, dynamic>.from(item))
      .toList(growable: false);
}

_MessengerCustomersSummary? _extractSummaryFromMeta(Map<String, dynamic> map) {
  final int? synced = _readInt(map, const <String>[
    'syncedCustomers',
    'synced_count',
    'successCount',
  ]);
  final int? failed = _readInt(map, const <String>[
    'failedCustomers',
    'failed_count',
    'failedCount',
  ]);
  final DateTime? lastSyncAt = _readDateTime(map, const <String>[
    'lastSyncAt',
    'last_sync_at',
    'syncedAt',
    'synced_at',
    'updatedAt',
    'updated_at',
  ]);

  if (synced == null && failed == null && lastSyncAt == null) {
    return null;
  }

  return _MessengerCustomersSummary(
    syncedCustomers: synced ?? 0,
    failedCustomers: failed ?? 0,
    lastSyncAt: lastSyncAt,
  );
}

bool _isCustomerSyncFailed(Map<String, dynamic> customer) {
  final dynamic syncStatus = customer['syncStatus'] ?? customer['status'];
  if (syncStatus is String) {
    final String normalized = syncStatus.trim().toLowerCase();
    if (normalized.contains('fail') || normalized == 'error') {
      return true;
    }
    if (normalized.contains('success') || normalized.contains('ok')) {
      return false;
    }
  }

  final dynamic rawFailed =
      customer['failed'] ?? customer['isFailed'] ?? customer['hasError'];
  if (rawFailed is bool) {
    return rawFailed;
  }
  if (rawFailed is num) {
    return rawFailed != 0;
  }
  if (rawFailed is String) {
    final String normalized = rawFailed.trim().toLowerCase();
    if (normalized == 'true' || normalized == '1') {
      return true;
    }
    if (normalized == 'false' || normalized == '0') {
      return false;
    }
  }

  return false;
}

DateTime? _readDateTime(Map<String, dynamic> map, List<String> keys) {
  for (final String key in keys) {
    final dynamic rawValue = map[key];
    if (rawValue == null) {
      continue;
    }

    if (rawValue is int) {
      if (rawValue <= 0) {
        continue;
      }
      return DateTime.fromMillisecondsSinceEpoch(rawValue);
    }

    if (rawValue is String) {
      final DateTime? parsed = DateTime.tryParse(rawValue);
      if (parsed != null) {
        return parsed;
      }
    }
  }

  return null;
}

int? _readInt(Map<String, dynamic> map, List<String> keys) {
  for (final String key in keys) {
    final dynamic raw = map[key];
    if (raw == null) {
      continue;
    }
    if (raw is int) {
      return raw;
    }
    if (raw is num) {
      return raw.toInt();
    }
    if (raw is String) {
      final int? parsed = int.tryParse(raw);
      if (parsed != null) {
        return parsed;
      }
    }
  }

  return null;
}
