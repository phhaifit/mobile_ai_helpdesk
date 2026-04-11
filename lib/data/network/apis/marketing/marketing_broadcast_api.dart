import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';

class MarketingBroadcastApi {
  final DioClient _dioClient;

  MarketingBroadcastApi(this._dioClient);

  Future<Map<String, dynamic>> getBroadcastTemplates({
    required BroadcastTemplateQuery query,
  }) async {
    final response = await _dioClient.dio.get(
      Endpoints.marketingV1BroadcastTemplates(),
      queryParameters: {
        if (_hasText(query.search)) 'search': query.search,
        if (_hasText(query.category)) 'category': query.category,
        if (_hasText(query.channel)) 'channel': query.channel,
        'offset': query.offset,
        'limit': query.limit,
      },
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> getBroadcastTemplateDetail(
    String templateId,
  ) async {
    final response = await _dioClient.dio.get(
      Endpoints.marketingV1BroadcastTemplate(templateId),
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> createBroadcastTemplate(
    BroadcastTemplateUpsertData data,
  ) async {
    final response = await _dioClient.dio.post(
      Endpoints.marketingV1BroadcastTemplates(),
      data: {
        'name': data.name,
        'content': data.content,
        if (_hasText(data.category)) 'category': data.category,
        if (_hasText(data.channel)) 'channel': data.channel,
        'variableKeys': data.variableKeys,
        'isActive': data.isActive,
      },
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> updateBroadcastTemplate({
    required String templateId,
    required BroadcastTemplateUpsertData data,
  }) async {
    final response = await _dioClient.dio.put(
      Endpoints.marketingV1BroadcastTemplate(templateId),
      data: {
        'name': data.name,
        'content': data.content,
        if (_hasText(data.category)) 'category': data.category,
        if (_hasText(data.channel)) 'channel': data.channel,
        'variableKeys': data.variableKeys,
        'isActive': data.isActive,
      },
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> deleteBroadcastTemplate(
    String templateId,
  ) async {
    final response = await _dioClient.dio.delete(
      Endpoints.marketingV1BroadcastTemplate(templateId),
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> getBroadcasts({
    required BroadcastQuery query,
  }) async {
    final response = await _dioClient.dio.get(
      Endpoints.marketingV1Broadcasts(),
      queryParameters: {
        if (query.status != null) 'status': query.status!.name,
        'offset': query.offset,
        'limit': query.limit,
      },
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> getBroadcastDetail(String broadcastId) async {
    final response = await _dioClient.dio.get(
      Endpoints.marketingV1Broadcast(broadcastId),
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> createBroadcast(BroadcastUpsertData data) async {
    final response = await _dioClient.dio.post(
      Endpoints.marketingV1Broadcasts(),
      data: {
        'name': data.name,
        'templateId': data.templateId,
        if (data.scheduledAt != null)
          'scheduledAt': data.scheduledAt!.toIso8601String(),
      },
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> updateBroadcast({
    required String broadcastId,
    required BroadcastUpsertData data,
  }) async {
    final response = await _dioClient.dio.put(
      Endpoints.marketingV1Broadcast(broadcastId),
      data: {
        'name': data.name,
        'templateId': data.templateId,
        if (data.scheduledAt != null)
          'scheduledAt': data.scheduledAt!.toIso8601String(),
      },
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> deleteBroadcast(String broadcastId) async {
    final response = await _dioClient.dio.delete(
      Endpoints.marketingV1Broadcast(broadcastId),
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> executeBroadcast(String broadcastId) async {
    final response = await _dioClient.dio.post(
      Endpoints.marketingV1BroadcastExecute(broadcastId),
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> stopBroadcast(String broadcastId) async {
    final response = await _dioClient.dio.post(
      Endpoints.marketingV1BroadcastStop(broadcastId),
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> resumeBroadcast(String broadcastId) async {
    final response = await _dioClient.dio.post(
      Endpoints.marketingV1BroadcastResume(broadcastId),
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> getBroadcastRecipients({
    required BroadcastRecipientsQuery query,
  }) async {
    final response = await _dioClient.dio.post(
      Endpoints.marketingV1BroadcastRecipients(),
      data: {
        'broadcastId': query.broadcastId,
        'filters': {
          if (_hasText(query.filter.segmentValue))
            'segmentValue': query.filter.segmentValue,
          if (_hasText(query.filter.channel)) 'channel': query.filter.channel,
          if (query.filter.tagValues.isNotEmpty)
            'tagValues': query.filter.tagValues,
        },
      },
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> getBroadcastDeliveryReceipts({
    required String broadcastId,
    required PaginationQuery query,
  }) async {
    final response = await _dioClient.dio.get(
      Endpoints.marketingV1BroadcastReceipts(broadcastId),
      queryParameters: {'offset': query.offset, 'limit': query.limit},
    );
    return _asMap(response.data);
  }

  Future<List<Map<String, dynamic>>> getFacebookAdminAccounts() async {
    final response = await _dioClient.dio.get(
      Endpoints.marketingV1FacebookAdminAccounts(),
    );
    return _asMapList(response.data);
  }

  Future<Map<String, dynamic>> createFacebookAdminAccount(
    FacebookAdminAccountCreateData data,
  ) async {
    final response = await _dioClient.dio.post(
      Endpoints.marketingV1FacebookAdminAccounts(),
      data: {
        'accessToken': data.accessToken,
        if (_hasText(data.adminName)) 'adminName': data.adminName,
        if (_hasText(data.adminEmail)) 'adminEmail': data.adminEmail,
        if (_hasText(data.pageId)) 'pageId': data.pageId,
        if (_hasText(data.pageName)) 'pageName': data.pageName,
      },
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> disconnectFacebookAdminAccount(
    String accountId,
  ) async {
    final response = await _dioClient.dio.post(
      Endpoints.marketingV1FacebookAdminDisconnect(accountId),
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> reauthFacebookAdminAccount({
    required String accountId,
    required String accessToken,
  }) async {
    final response = await _dioClient.dio.post(
      Endpoints.marketingV1FacebookAdminReauth(accountId),
      data: {'accessToken': accessToken},
    );
    return _asMap(response.data);
  }

  Future<List<Map<String, dynamic>>> getFacebookAdminPages(
    String accountId,
  ) async {
    final response = await _dioClient.dio.get(
      Endpoints.marketingV1FacebookAdminPages(accountId),
    );
    return _asMapList(response.data);
  }

  Future<Map<String, dynamic>> selectFacebookAdminPage({
    required String accountId,
    required String pageId,
  }) async {
    final response = await _dioClient.dio.post(
      Endpoints.marketingV1FacebookAdminSelectPage(accountId),
      data: {'pageId': pageId},
    );
    return _asMap(response.data);
  }

  bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is List<dynamic>) {
      return {'items': data};
    }
    return const <String, dynamic>{};
  }

  List<Map<String, dynamic>> _asMapList(dynamic data) {
    if (data is List<dynamic>) {
      return data.whereType<Map<String, dynamic>>().toList();
    }
    if (data is Map<String, dynamic>) {
      final nested =
          data['items'] ?? data['data'] ?? data['results'] ?? data['rows'];
      if (nested is List<dynamic>) {
        return nested.whereType<Map<String, dynamic>>().toList();
      }
    }
    return const <Map<String, dynamic>>[];
  }
}
