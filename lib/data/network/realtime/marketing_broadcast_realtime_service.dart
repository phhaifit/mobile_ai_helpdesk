import 'dart:async';
import 'dart:convert';

import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BroadcastStatusRealtimeEvent {
  final String campaignId;
  final BroadcastStatus? status;
  final String rawStatus;
  final int sentCount;
  final int deliveredCount;
  final int failedCount;
  final DateTime occurredAt;
  final bool fromWebSocket;

  const BroadcastStatusRealtimeEvent({
    required this.campaignId,
    required this.status,
    required this.rawStatus,
    required this.sentCount,
    required this.deliveredCount,
    required this.failedCount,
    required this.occurredAt,
    required this.fromWebSocket,
  });
}

class MarketingBroadcastRealtimeService {
  final DioClient _dioClient;
  final EventBus _eventBus;
  final Duration defaultPollingInterval;

  final Map<String, _RealtimeSession> _sessions = <String, _RealtimeSession>{};

  MarketingBroadcastRealtimeService(
    this._dioClient,
    this._eventBus, {
    this.defaultPollingInterval = const Duration(seconds: 8),
  });

  Future<void> subscribeCampaign(
    String campaignId, {
    Duration? pollingInterval,
  }) async {
    final normalizedCampaignId = campaignId.trim();
    if (normalizedCampaignId.isEmpty) {
      return;
    }

    final existing = _sessions[normalizedCampaignId];
    if (existing != null) {
      existing.subscriberCount += 1;
      return;
    }

    final session = _RealtimeSession(
      campaignId: normalizedCampaignId,
      pollingInterval: pollingInterval ?? defaultPollingInterval,
    );
    _sessions[normalizedCampaignId] = session;

    await _connectWebSocket(session);
  }

  Future<void> unsubscribeCampaign(String campaignId) async {
    final normalizedCampaignId = campaignId.trim();
    final session = _sessions[normalizedCampaignId];
    if (session == null) {
      return;
    }

    session.subscriberCount -= 1;
    if (session.subscriberCount > 0) {
      return;
    }

    _sessions.remove(normalizedCampaignId);
    await session.dispose();
  }

  Future<void> dispose() async {
    final sessions = _sessions.values.toList();
    _sessions.clear();
    for (final session in sessions) {
      await session.dispose();
    }
  }

  Future<void> _connectWebSocket(_RealtimeSession session) async {
    if (session.isDisposed || session.reconnectInProgress) {
      return;
    }

    session.reconnectInProgress = true;

    await session.disposeWebSocketOnly();

    final wsUris = <Uri>[
      Endpoints.marketingV1BroadcastStatusWsUri(session.campaignId),
      Endpoints.marketingCampaignStatusWsUri(session.campaignId),
    ];

    for (final wsUri in wsUris) {
      if (session.isDisposed) {
        session.reconnectInProgress = false;
        return;
      }

      try {
        final channel = WebSocketChannel.connect(wsUri);
        session.channel = channel;

        session.wsSubscription = channel.stream.listen(
          (dynamic message) {
            final event = _tryParseWsEvent(session.campaignId, message);
            if (event != null) {
              _emitIfChanged(session, event);
            }
          },
          onError: (_) {
            _handleWebSocketDisconnect(session);
          },
          onDone: () {
            _handleWebSocketDisconnect(session);
          },
          cancelOnError: true,
        );

        session.reconnectAttempt = 0;
        session.reconnectTimer?.cancel();
        session.reconnectTimer = null;
        session.pollingTimer?.cancel();
        session.pollingTimer = null;
        session.reconnectInProgress = false;

        return;
      } catch (_) {
        await session.disposeWebSocketOnly();
      }
    }

    session.reconnectInProgress = false;
    _switchToPolling(session);
  }

  void _handleWebSocketDisconnect(_RealtimeSession session) {
    _switchToPolling(session);
  }

  void _switchToPolling(_RealtimeSession session) {
    if (session.isDisposed) {
      return;
    }

    unawaited(session.disposeWebSocketOnly());

    if (session.pollingTimer == null) {
      session.pollingTimer = Timer.periodic(session.pollingInterval, (_) {
        unawaited(_pollLatestStatus(session));
      });
    }

    unawaited(_pollLatestStatus(session));
    _scheduleReconnect(session);
  }

  void _scheduleReconnect(_RealtimeSession session) {
    if (session.isDisposed || session.reconnectTimer != null) {
      return;
    }

    final delay = _computeReconnectDelay(session.reconnectAttempt);
    session.reconnectAttempt += 1;

    session.reconnectTimer = Timer(delay, () {
      session.reconnectTimer = null;
      if (session.isDisposed) {
        return;
      }
      unawaited(_connectWebSocket(session));
    });
  }

  Duration _computeReconnectDelay(int attempt) {
    final safeAttempt = attempt < 0 ? 0 : attempt;
    final exponentialSeconds = 1 << safeAttempt;
    final boundedSeconds = exponentialSeconds > 30 ? 30 : exponentialSeconds;
    return Duration(seconds: boundedSeconds);
  }

  Future<void> _pollLatestStatus(_RealtimeSession session) async {
    if (session.isDisposed) {
      return;
    }

    final latest = await _fetchLatestStatusEvent(session.campaignId);
    if (latest == null) {
      return;
    }

    _emitIfChanged(session, latest);
  }

  Future<BroadcastStatusRealtimeEvent?> _fetchLatestStatusEvent(
    String campaignId,
  ) async {
    final timelineResponses = <String>[
      Endpoints.marketingV1BroadcastStatusTimeline(campaignId),
      Endpoints.marketingCampaignStatusTimeline(campaignId),
    ];

    for (final endpoint in timelineResponses) {
      try {
        final response = await _dioClient.dio.get(
          endpoint,
          queryParameters: const <String, dynamic>{'limit': 20, 'offset': 0},
        );

        final payload = _asMap(response.data);
        final itemMaps = _extractItemMaps(payload);
        if (itemMaps.isEmpty) {
          final fallbackSingle = _asEventMap(payload);
          if (fallbackSingle != null) {
            return _mapRealtimeEvent(
              campaignId: campaignId,
              raw: fallbackSingle,
              fromWebSocket: false,
            );
          }
          continue;
        }

        itemMaps.sort((a, b) {
          final timeA =
              _extractDateTime(a, const <String>['occurredAt', 'timestamp']) ??
              DateTime.fromMillisecondsSinceEpoch(0);
          final timeB =
              _extractDateTime(b, const <String>['occurredAt', 'timestamp']) ??
              DateTime.fromMillisecondsSinceEpoch(0);
          return timeB.compareTo(timeA);
        });

        return _mapRealtimeEvent(
          campaignId: campaignId,
          raw: itemMaps.first,
          fromWebSocket: false,
        );
      } on DioException {
        continue;
      }
    }

    return null;
  }

  BroadcastStatusRealtimeEvent? _tryParseWsEvent(
    String campaignId,
    dynamic message,
  ) {
    dynamic decoded = message;
    if (message is String) {
      decoded = jsonDecode(message);
    }

    if (decoded is List<dynamic>) {
      final maps = decoded.whereType<Map<String, dynamic>>().toList();
      if (maps.isEmpty) {
        return null;
      }
      return _mapRealtimeEvent(
        campaignId: campaignId,
        raw: maps.last,
        fromWebSocket: true,
      );
    }

    if (decoded is Map<String, dynamic>) {
      final eventMap = _asEventMap(decoded) ?? decoded;
      return _mapRealtimeEvent(
        campaignId: campaignId,
        raw: eventMap,
        fromWebSocket: true,
      );
    }

    return null;
  }

  BroadcastStatusRealtimeEvent _mapRealtimeEvent({
    required String campaignId,
    required Map<String, dynamic> raw,
    required bool fromWebSocket,
  }) {
    final resolvedCampaignId =
        _extractString(raw, const <String>['campaignId', 'broadcastId']).isEmpty
            ? campaignId
            : _extractString(raw, const <String>['campaignId', 'broadcastId']);

    final rawStatus = _extractString(raw, const <String>['status']);

    return BroadcastStatusRealtimeEvent(
      campaignId: resolvedCampaignId,
      status: _parseStatus(rawStatus),
      rawStatus: rawStatus,
      sentCount: _extractInt(raw, const <String>['sentCount'], fallback: 0),
      deliveredCount: _extractInt(raw, const <String>[
        'deliveredCount',
      ], fallback: 0),
      failedCount: _extractInt(raw, const <String>['failedCount'], fallback: 0),
      occurredAt:
          _extractDateTime(raw, const <String>['occurredAt', 'timestamp']) ??
          DateTime.now().toUtc(),
      fromWebSocket: fromWebSocket,
    );
  }

  void _emitIfChanged(
    _RealtimeSession session,
    BroadcastStatusRealtimeEvent event,
  ) {
    final signature =
        '${event.campaignId}|${event.rawStatus}|${event.sentCount}|${event.deliveredCount}|${event.failedCount}|${event.occurredAt.toIso8601String()}';

    if (session.lastEventSignature == signature) {
      return;
    }

    session.lastEventSignature = signature;
    _eventBus.fire(event);
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    return const <String, dynamic>{};
  }

  Map<String, dynamic>? _asEventMap(Map<String, dynamic> source) {
    final candidates = <dynamic>[
      source['event'],
      source['data'],
      source['item'],
      source['result'],
    ];

    for (final candidate in candidates) {
      if (candidate is Map<String, dynamic>) {
        return candidate;
      }
    }

    return null;
  }

  List<Map<String, dynamic>> _extractItemMaps(Map<String, dynamic> source) {
    final candidates = <dynamic>[
      source['items'],
      source['events'],
      source['data'],
      source['results'],
      source['rows'],
      source['timeline'],
    ];

    for (final candidate in candidates) {
      if (candidate is List<dynamic>) {
        return candidate.whereType<Map<String, dynamic>>().toList();
      }
      if (candidate is Map<String, dynamic>) {
        final nested = _extractItemMaps(candidate);
        if (nested.isNotEmpty) {
          return nested;
        }
      }
    }

    return const <Map<String, dynamic>>[];
  }

  String _extractString(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
      if (value is num) {
        return value.toString();
      }
    }
    return '';
  }

  int _extractInt(
    Map<String, dynamic> source,
    List<String> keys, {
    required int fallback,
  }) {
    for (final key in keys) {
      final value = source[key];
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
      }
    }
    return fallback;
  }

  DateTime? _extractDateTime(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value is String && value.trim().isNotEmpty) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
      }
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
    }
    return null;
  }

  BroadcastStatus? _parseStatus(String rawStatus) {
    final normalized = rawStatus.toLowerCase().trim();
    switch (normalized) {
      case 'draft':
        return BroadcastStatus.draft;
      case 'scheduled':
        return BroadcastStatus.scheduled;
      case 'running':
        return BroadcastStatus.running;
      case 'paused':
        return BroadcastStatus.paused;
      case 'completed':
        return BroadcastStatus.completed;
      case 'failed':
        return BroadcastStatus.failed;
      default:
        return null;
    }
  }
}

class _RealtimeSession {
  final String campaignId;
  final Duration pollingInterval;

  int subscriberCount = 1;

  bool isDisposed = false;
  WebSocketChannel? channel;
  StreamSubscription<dynamic>? wsSubscription;
  Timer? pollingTimer;
  Timer? reconnectTimer;
  int reconnectAttempt = 0;
  bool reconnectInProgress = false;
  String? lastEventSignature;

  _RealtimeSession({required this.campaignId, required this.pollingInterval});

  Future<void> disposeWebSocketOnly() async {
    await wsSubscription?.cancel();
    wsSubscription = null;

    await channel?.sink.close();
    channel = null;
  }

  Future<void> dispose() async {
    isDisposed = true;
    pollingTimer?.cancel();
    pollingTimer = null;
    reconnectTimer?.cancel();
    reconnectTimer = null;
    await disposeWebSocketOnly();
  }
}
