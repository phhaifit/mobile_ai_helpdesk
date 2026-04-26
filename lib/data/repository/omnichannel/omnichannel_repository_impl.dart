import 'dart:async';

import 'package:ai_helpdesk/data/network/apis/omnichannel/omnichannel_api.dart';
import 'package:ai_helpdesk/data/repository/omnichannel/mock_omnichannel_repository_impl.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';
import 'package:dio/dio.dart';

class OmnichannelRepositoryImpl implements OmnichannelRepository {
  final OmnichannelApi _api;
  final MockOmnichannelRepositoryImpl _fallbackRepository;
  DateTime? _lastOverviewApiFailureAt;
  MessengerSettingsUpdate? _lastSavedMessengerSettings;

  static const Duration _overviewApiFailureCooldown = Duration(seconds: 8);

  OmnichannelRepositoryImpl(
    this._api, {
    MockOmnichannelRepositoryImpl? fallbackRepository,
  }) : _fallbackRepository =
           fallbackRepository ?? MockOmnichannelRepositoryImpl();

  @override
  Future<OmnichannelOverview> getOverview() async {
    final OmnichannelOverview fallback =
        await _fallbackRepository.getOverview();

    if (_shouldSkipOverviewApiCall()) {
      return fallback;
    }

    try {
      final List<MessengerPageDto> pages = await _api.getMessengerPages();
      _lastOverviewApiFailureAt = null;
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
        autoReply:
            connectedPage.autoReply ??
            _lastSavedMessengerSettings?.autoReply ??
            fallback.messenger.autoReply,
        language:
            connectedPage.language ??
            _lastSavedMessengerSettings?.language ??
            fallback.messenger.language,
        businessHours:
            connectedPage.businessHours ??
            _lastSavedMessengerSettings?.businessHours ??
            fallback.messenger.businessHours,
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
    } on DioException {
      _lastOverviewApiFailureAt = DateTime.now();
      // Phase 1 keeps UX stable by falling back to mock data when API is not ready.
      return fallback;
    }
  }

  bool _shouldSkipOverviewApiCall() {
    final DateTime? lastFailure = _lastOverviewApiFailureAt;
    if (lastFailure == null) {
      return false;
    }

    return DateTime.now().difference(lastFailure) < _overviewApiFailureCooldown;
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
      final dynamic verifyResponse = await _api.verifyMessengerAuthCode(
        normalizedCode,
      );
      final _MessengerConnectPayload? payload = _resolveConnectPayload(
        verifyResponse,
      );

      if (payload == null) {
        return const ActionFeedback(
          isSuccess: false,
          messageKey: 'omnichannel_messenger_no_page_available',
        );
      }

      await _api.connectMessengerPage(
        pageId: payload.pageId,
        accessToken: payload.accessToken,
      );

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
          isSuccess: true,
          messageKey: 'omnichannel_messenger_disconnect_success',
        );
      }

      await _api.deleteMessengerPage(resolvedChannelId);
      _lastSavedMessengerSettings = null;

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
      _lastSavedMessengerSettings = update;

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

class _MessengerConnectPayload {
  final String pageId;
  final String accessToken;

  const _MessengerConnectPayload({
    required this.pageId,
    required this.accessToken,
  });
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

_MessengerConnectPayload? _resolveConnectPayload(dynamic verifyResponse) {
  final dynamic root = _unwrapResponseData(verifyResponse);
  final List<Map<String, dynamic>> candidates = <Map<String, dynamic>>[
    ..._extractCandidateMaps(root),
  ];

  for (final Map<String, dynamic> candidate in candidates) {
    final _MessengerConnectPayload? payload =
        _payloadFromSingleMap(candidate) ?? _payloadFromMapWithPages(candidate);
    if (payload != null) {
      return payload;
    }
  }

  return null;
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

List<Map<String, dynamic>> _extractCandidateMaps(dynamic value) {
  if (value is Map) {
    final Map<String, dynamic> map = Map<String, dynamic>.from(value);
    final List<Map<String, dynamic>> result = <Map<String, dynamic>>[map];

    for (final String key in const <String>[
      'data',
      'result',
      'payload',
      'integration',
      'page',
    ]) {
      final dynamic nested = map[key];
      if (nested is Map) {
        result.add(Map<String, dynamic>.from(nested));
      }
    }

    for (final String key in const <String>[
      'pages',
      'items',
      'results',
      'channels',
      'fanpages',
    ]) {
      final dynamic nested = map[key];
      if (nested is List) {
        for (final dynamic item in nested) {
          if (item is Map) {
            result.add(Map<String, dynamic>.from(item));
          }
        }
      }
    }

    return result;
  }

  if (value is List) {
    return value
        .whereType<Map<Object?, Object?>>()
        .map((Map<Object?, Object?> item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }

  return const <Map<String, dynamic>>[];
}

_MessengerConnectPayload? _payloadFromSingleMap(Map<String, dynamic> map) {
  final String pageId = _readString(map, const <String>[
    'pageId',
    'page_id',
    'id',
  ]);
  final String accessToken = _readString(map, const <String>[
    'accessToken',
    'access_token',
    'token',
    'pageAccessToken',
    'page_access_token',
  ]);

  if (pageId.isEmpty || accessToken.isEmpty) {
    return null;
  }

  return _MessengerConnectPayload(pageId: pageId, accessToken: accessToken);
}

_MessengerConnectPayload? _payloadFromMapWithPages(Map<String, dynamic> map) {
  final String globalToken = _readString(map, const <String>[
    'accessToken',
    'access_token',
    'token',
    'pageAccessToken',
    'page_access_token',
  ]);
  if (globalToken.isEmpty) {
    return null;
  }

  final dynamic pages =
      map['pages'] ??
      map['items'] ??
      map['results'] ??
      map['channels'] ??
      map['fanpages'];
  if (pages is! List) {
    return null;
  }

  for (final dynamic page in pages) {
    if (page is! Map) {
      continue;
    }

    final Map<String, dynamic> pageMap = Map<String, dynamic>.from(page);
    final String pageId = _readString(pageMap, const <String>[
      'pageId',
      'page_id',
      'id',
    ]);
    if (pageId.isNotEmpty) {
      return _MessengerConnectPayload(pageId: pageId, accessToken: globalToken);
    }
  }

  return null;
}

String _readString(Map<String, dynamic> map, List<String> keys) {
  for (final String key in keys) {
    final dynamic value = map[key];
    if (value == null) {
      continue;
    }

    final String normalized = value.toString().trim();
    if (normalized.isNotEmpty) {
      return normalized;
    }
  }

  return '';
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
