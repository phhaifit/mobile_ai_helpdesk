import 'package:ai_helpdesk/core/data/network/exceptions/network_exceptions.dart';
import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/data/network/apis/marketing/marketing_broadcast_api.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';
import 'package:dio/dio.dart';

class MarketingBroadcastRepositoryImpl implements MarketingBroadcastRepository {
  final MarketingBroadcastApi _api;

  MarketingBroadcastRepositoryImpl(this._api);

  @override
  Future<BroadcastPage<BroadcastTemplate>> getBroadcastTemplates({
    required BroadcastTemplateQuery query,
  }) {
    return _execute(() async {
      final response = await _api.getBroadcastTemplates(query: query);
      return _mapPage(
        response,
        _mapBroadcastTemplate,
        fallbackLimit: query.limit,
      );
    });
  }

  @override
  Future<BroadcastTemplate> getBroadcastTemplateDetail(String templateId) {
    return _execute(() async {
      final response = await _api.getBroadcastTemplateDetail(templateId);
      return _mapBroadcastTemplate(_extractPayloadMap(response));
    });
  }

  @override
  Future<BroadcastTemplate> createBroadcastTemplate(
    BroadcastTemplateUpsertData data,
  ) {
    return _execute(() async {
      final response = await _api.createBroadcastTemplate(data);
      return _mapBroadcastTemplate(_extractPayloadMap(response));
    });
  }

  @override
  Future<BroadcastTemplate> updateBroadcastTemplate({
    required String templateId,
    required BroadcastTemplateUpsertData data,
  }) {
    return _execute(() async {
      final response = await _api.updateBroadcastTemplate(
        templateId: templateId,
        data: data,
      );
      return _mapBroadcastTemplate(_extractPayloadMap(response));
    });
  }

  @override
  Future<bool> deleteBroadcastTemplate(String templateId) {
    return _execute(() async {
      final response = await _api.deleteBroadcastTemplate(templateId);
      return _extractBool(response, const [
        'success',
        'isSuccess',
        'deleted',
      ], fallback: true);
    });
  }

  @override
  Future<BroadcastPage<BroadcastItem>> getBroadcasts({
    required BroadcastQuery query,
  }) {
    return _execute(() async {
      final response = await _api.getBroadcasts(query: query);
      return _mapPage(response, _mapBroadcastItem, fallbackLimit: query.limit);
    });
  }

  @override
  Future<BroadcastItem> getBroadcastDetail(String broadcastId) {
    return _execute(() async {
      final response = await _api.getBroadcastDetail(broadcastId);
      return _mapBroadcastItem(_extractPayloadMap(response));
    });
  }

  @override
  Future<BroadcastItem> createBroadcast(BroadcastUpsertData data) {
    return _execute(() async {
      final response = await _api.createBroadcast(data);
      return _mapBroadcastItem(_extractPayloadMap(response));
    });
  }

  @override
  Future<BroadcastItem> updateBroadcast({
    required String broadcastId,
    required BroadcastUpsertData data,
  }) {
    return _execute(() async {
      final response = await _api.updateBroadcast(
        broadcastId: broadcastId,
        data: data,
      );
      return _mapBroadcastItem(_extractPayloadMap(response));
    });
  }

  @override
  Future<bool> deleteBroadcast(String broadcastId) {
    return _execute(() async {
      final response = await _api.deleteBroadcast(broadcastId);
      return _extractBool(response, const [
        'success',
        'isSuccess',
        'deleted',
      ], fallback: true);
    });
  }

  @override
  Future<BroadcastItem> executeBroadcast(String broadcastId) {
    return _execute(() async {
      final response = await _api.executeBroadcast(broadcastId);
      return _mapBroadcastItem(_extractPayloadMap(response));
    });
  }

  @override
  Future<BroadcastItem> stopBroadcast(String broadcastId) {
    return _execute(() async {
      final response = await _api.stopBroadcast(broadcastId);
      return _mapBroadcastItem(_extractPayloadMap(response));
    });
  }

  @override
  Future<BroadcastItem> resumeBroadcast(String broadcastId) {
    return _execute(() async {
      final response = await _api.resumeBroadcast(broadcastId);
      return _mapBroadcastItem(_extractPayloadMap(response));
    });
  }

  @override
  Future<BroadcastPage<BroadcastRecipient>> getBroadcastRecipients({
    required BroadcastRecipientsQuery query,
  }) {
    return _execute(() async {
      final response = await _api.getBroadcastRecipients(query: query);
      return _mapPage(response, _mapRecipient, fallbackLimit: query.limit);
    });
  }

  @override
  Future<BroadcastPage<BroadcastDeliveryReceipt>> getBroadcastDeliveryReceipts({
    required String broadcastId,
    required PaginationQuery query,
  }) {
    return _execute(() async {
      final response = await _api.getBroadcastDeliveryReceipts(
        broadcastId: broadcastId,
        query: query,
      );
      return _mapPage(
        response,
        _mapDeliveryReceipt,
        fallbackLimit: query.limit,
      );
    });
  }

  @override
  Future<List<FacebookAdAccount>> getFacebookAdminAccounts() {
    return _execute(() async {
      final response = await _api.getFacebookAdminAccounts();
      return response.map(_mapFacebookAccount).toList();
    });
  }

  @override
  Future<FacebookAdAccount> createFacebookAdminAccount(
    FacebookAdminAccountCreateData data,
  ) {
    return _execute(() async {
      final response = await _api.createFacebookAdminAccount(data);
      return _mapFacebookAccount(_extractPayloadMap(response));
    });
  }

  Future<T> _execute<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (e) {
      throw NetworkExceptions.getDioException(e);
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  BroadcastPage<T> _mapPage<T>(
    Map<String, dynamic> raw,
    T Function(Map<String, dynamic>) mapItem, {
    required int fallbackLimit,
  }) {
    final source = _extractPayloadMap(raw);
    final items = _extractItemMaps(source).map(mapItem).toList();

    final meta = _extractMetaMap(source);
    final limit = _extractInt(
      [source, meta],
      const ['limit', 'pageSize', 'size'],
      fallback: fallbackLimit,
    );

    final total = _extractInt(
      [source, meta],
      const ['total', 'totalCount', 'count'],
      fallback: items.length,
    );

    var offset = _extractInt(
      [source, meta],
      const ['offset', 'skip'],
      fallback: -1,
    );

    if (offset < 0) {
      final page = _extractInt([source, meta], const ['page'], fallback: 1);
      offset = (page - 1) * limit;
    }

    return BroadcastPage<T>(
      items: items,
      total: total,
      offset: offset < 0 ? 0 : offset,
      limit: limit,
    );
  }

  BroadcastTemplate _mapBroadcastTemplate(Map<String, dynamic> raw) {
    final variableKeysRaw =
        raw['variableKeys'] ??
        raw['variables'] ??
        raw['placeholders'] ??
        const [];

    return BroadcastTemplate(
      id: _extractString(raw, const ['id', '_id', 'templateId']),
      name: _extractString(raw, const ['name', 'templateName']),
      content: _extractString(raw, const ['content', 'body', 'message']),
      category: _extractNullableString(raw, const [
        'category',
        'templateCategory',
      ]),
      channel: _extractNullableString(raw, const [
        'channel',
        'deliveryChannel',
      ]),
      variableKeys: _extractStringList(variableKeysRaw),
      isActive: _extractBool(raw, const ['isActive', 'active'], fallback: true),
      createdAt: _extractDateTime(raw, const ['createdAt', 'created_at']),
      updatedAt: _extractDateTime(raw, const ['updatedAt', 'updated_at']),
    );
  }

  BroadcastItem _mapBroadcastItem(Map<String, dynamic> raw) {
    final template = raw['template'];
    String templateId = _extractString(raw, const [
      'templateId',
      'template_id',
    ]);
    if (templateId.isEmpty && template is Map<String, dynamic>) {
      templateId = _extractString(template, const ['id', '_id']);
    }

    return BroadcastItem(
      id: _extractString(raw, const ['id', '_id', 'broadcastId']),
      name: _extractString(raw, const ['name', 'broadcastName']),
      templateId: templateId,
      status: _parseStatus(_extractString(raw, const ['status'])),
      recipientCount: _extractInt(
        [raw],
        const ['recipientCount', 'targetedCount', 'audienceCount'],
        fallback: 0,
      ),
      sentCount: _extractInt([raw], const ['sentCount'], fallback: 0),
      deliveredCount: _extractInt([raw], const ['deliveredCount'], fallback: 0),
      failedCount: _extractInt([raw], const ['failedCount'], fallback: 0),
      scheduledAt: _extractDateTime(raw, const ['scheduledAt', 'scheduled_at']),
      startedAt: _extractDateTime(raw, const ['startedAt', 'started_at']),
      completedAt: _extractDateTime(raw, const ['completedAt', 'completed_at']),
      createdAt:
          _extractDateTime(raw, const ['createdAt', 'created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  BroadcastRecipient _mapRecipient(Map<String, dynamic> raw) {
    return BroadcastRecipient(
      id: _extractString(raw, const ['id', '_id', 'recipientId']),
      displayName: _extractNullableString(raw, const ['displayName', 'name']),
      channelAddress: _extractNullableString(raw, const [
        'channelAddress',
        'address',
        'contact',
      ]),
      segmentValue: _extractNullableString(raw, const [
        'segmentValue',
        'segment',
      ]),
      tags: _extractStringList(raw['tags']),
    );
  }

  BroadcastDeliveryReceipt _mapDeliveryReceipt(Map<String, dynamic> raw) {
    return BroadcastDeliveryReceipt(
      id: _extractString(raw, const ['id', '_id', 'receiptId']),
      broadcastId: _extractString(raw, const ['broadcastId']),
      recipientId: _extractString(raw, const ['recipientId']),
      status: _extractString(raw, const ['status']),
      channelMessageId: _extractNullableString(raw, const [
        'channelMessageId',
        'messageId',
      ]),
      errorCode: _extractNullableString(raw, const ['errorCode']),
      errorMessage: _extractNullableString(raw, const [
        'errorMessage',
        'error',
      ]),
      sentAt: _extractDateTime(raw, const ['sentAt', 'sent_at']),
      deliveredAt: _extractDateTime(raw, const ['deliveredAt', 'delivered_at']),
      failedAt: _extractDateTime(raw, const ['failedAt', 'failed_at']),
    );
  }

  FacebookAdAccount _mapFacebookAccount(Map<String, dynamic> raw) {
    return FacebookAdAccount(
      id: _extractString(raw, const ['id', '_id', 'accountId']),
      adminName: _extractNullableString(raw, const ['adminName', 'name']),
      adminEmail: _extractNullableString(raw, const ['adminEmail', 'email']),
      pageId: _extractNullableString(raw, const ['pageId']),
      pageName: _extractNullableString(raw, const ['pageName']),
      status: _extractNullableString(raw, const ['status']),
      connectedAt: _extractDateTime(raw, const ['connectedAt', 'connected_at']),
    );
  }

  BroadcastStatus _parseStatus(String rawStatus) {
    final normalized = rawStatus.toLowerCase().trim();
    switch (normalized) {
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
      case 'draft':
      default:
        return BroadcastStatus.draft;
    }
  }

  Map<String, dynamic> _extractPayloadMap(Map<String, dynamic> raw) {
    final payload = raw['data'] ?? raw['item'] ?? raw['result'];
    if (payload is Map<String, dynamic>) {
      return payload;
    }
    return raw;
  }

  Map<String, dynamic> _extractMetaMap(Map<String, dynamic> raw) {
    final meta = raw['meta'] ?? raw['pagination'];
    if (meta is Map<String, dynamic>) {
      return meta;
    }
    return const <String, dynamic>{};
  }

  List<Map<String, dynamic>> _extractItemMaps(Map<String, dynamic> raw) {
    final candidates = [
      raw['items'],
      raw['data'],
      raw['results'],
      raw['rows'],
      raw['content'],
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

  int _extractInt(
    List<Map<String, dynamic>> sources,
    List<String> keys, {
    required int fallback,
  }) {
    for (final source in sources) {
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
    }
    return fallback;
  }

  bool _extractBool(
    Map<String, dynamic> source,
    List<String> keys, {
    required bool fallback,
  }) {
    for (final key in keys) {
      final value = source[key];
      if (value is bool) {
        return value;
      }
      if (value is num) {
        return value != 0;
      }
      if (value is String) {
        final normalized = value.toLowerCase().trim();
        if (normalized == 'true' || normalized == '1') {
          return true;
        }
        if (normalized == 'false' || normalized == '0') {
          return false;
        }
      }
    }
    return fallback;
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

  String? _extractNullableString(
    Map<String, dynamic> source,
    List<String> keys,
  ) {
    final value = _extractString(source, keys);
    return value.isEmpty ? null : value;
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

  List<String> _extractStringList(dynamic value) {
    if (value is List<dynamic>) {
      return value
          .map((item) {
            if (item is String) {
              return item;
            }
            if (item is Map<String, dynamic>) {
              return _extractString(item, const ['key', 'name', 'value']);
            }
            return '';
          })
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return const <String>[];
  }
}
