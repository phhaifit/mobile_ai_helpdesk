import 'package:flutter/foundation.dart';

import '/core/data/network/dio/dio_client.dart';
import '/data/network/constants/endpoints.dart';
import '/data/network/models/request/update_ai_agent_request.dart';

class AiAgentApi {
  final DioClient _dioClient;

  AiAgentApi(this._dioClient);

  Future<Map<String, dynamic>> getAgentByTenant(String tenantId) async {
    debugPrint('[AiAgentApi] getAgentByTenant called');
    final response = await _dioClient.dio
        .get<Map<String, dynamic>>(Endpoints.agentsByTenant(tenantId));
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> createAgent(
    String tenantId,
    UpdateAiAgentRequest dto,
  ) async {
    debugPrint('data: ${dto.toJson()}');
    debugPrint('[AiAgentApi] createAgent called');
    final response = await _dioClient.dio.post<Map<String, dynamic>>(
      Endpoints.agentsByTenant(tenantId),
      data: dto.toJson(),
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> updateAgentByTenant(
    String tenantId,
    UpdateAiAgentRequest dto,
  ) async {
    debugPrint('[AiAgentApi] updateAgentByTenant called');
    final response = await _dioClient.dio.patch<Map<String, dynamic>>(
      Endpoints.agentsByTenant(tenantId),
      data: dto.toJson(),
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> updateAgentById(
    String agentId,
    UpdateAiAgentRequest dto,
  ) async {
    debugPrint('[AiAgentApi] updateAgentById called');
    final response = await _dioClient.dio.patch<Map<String, dynamic>>(
      Endpoints.agentById(agentId),
      data: dto.toJson(),
    );
    return response.data ?? {};
  }

  Future<void> deleteAgent(String agentId) async {
    debugPrint('[AiAgentApi] deleteAgent called');
    await _dioClient.dio.delete<void>(Endpoints.agentById(agentId));
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
    final response = await _dioClient.dio.patch<Map<String, dynamic>>(
      Endpoints.agentInfo(agentId),
      data: body,
    );
    return response.data ?? {};
  }
}
