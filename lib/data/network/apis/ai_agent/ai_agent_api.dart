import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '/core/data/network/dio/dio_client.dart';
import '/data/network/constants/endpoints.dart';
import '/data/network/models/request/update_ai_agent_request.dart';

class AiAgentApi {
  final DioClient _dioClient;

  AiAgentApi(this._dioClient);

  Future<Map<String, dynamic>> getAgentByTenant(String tenantId) async {
    debugPrint('[AiAgentApi] getAgentByTenant called');
    try {
      final response = await _dioClient.dio
          .get<Map<String, dynamic>>(Endpoints.agentsByTenant(tenantId));
      return response.data ?? {};
    } on DioException catch (e) {
      _logApiError('getAgentByTenant', e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createAgent(
    String tenantId,
  ) async {
    debugPrint('[AiAgentApi] createAgent called');
    try {
      final response = await _dioClient.dio.post<Map<String, dynamic>>(
        Endpoints.agentsByTenant(tenantId),
      );
      return response.data ?? {};
    } on DioException catch (e) {
      _logApiError('createAgent', e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateAgentByTenant(
    String tenantId,
    UpdateAiAgentRequest dto,
  ) async {
    debugPrint('[AiAgentApi] updateAgentByTenant called');
    try {
      final response = await _dioClient.dio.patch<Map<String, dynamic>>(
        Endpoints.agentsByTenant(tenantId),
        data: dto.toJson(),
      );
      return response.data ?? {};
    } on DioException catch (e) {
      _logApiError('updateAgentByTenant', e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateAgentById(
    String agentId,
    UpdateAiAgentRequest dto,
  ) async {
    debugPrint('[AiAgentApi] updateAgentById called');
    try {
      final response = await _dioClient.dio.patch<Map<String, dynamic>>(
        Endpoints.agentById(agentId),
        data: dto.toJson(),
      );
      return response.data ?? {};
    } on DioException catch (e) {
      _logApiError('updateAgentById', e);
      rethrow;
    }
  }

  Future<void> deleteAgent(String agentId) async {
    debugPrint('[AiAgentApi] deleteAgent called');
    try {
      await _dioClient.dio.delete<void>(Endpoints.agentById(agentId));
    } on DioException catch (e) {
      _logApiError('deleteAgent', e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateAgentInfo(
    String agentId, {
    String? name,
    String? description,
    String? avatar,
  }) async {
    debugPrint('[AiAgentApi] updateAgentInfo called');
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;
    if (avatar != null) body['avatar'] = avatar;
    try {
      final response = await _dioClient.dio.patch<Map<String, dynamic>>(
        Endpoints.agentInfo(agentId),
        data: body,
      );
      return response.data ?? {};
    } on DioException catch (e) {
      _logApiError('updateAgentInfo', e);
      rethrow;
    }
  }

  void _logApiError(String action, DioException e) {
    final method = e.requestOptions.method;
    final path = e.requestOptions.path;
    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;
    debugPrint(
      '[AiAgentApi][$action] $method $path failed '
      '(status: $statusCode) response: $responseData',
    );
  }
}
