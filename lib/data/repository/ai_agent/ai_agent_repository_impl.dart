import 'package:dio/dio.dart';

import '/data/network/apis/ai_agent/ai_agent_api.dart';
import '/data/network/models/request/update_ai_agent_request.dart';
import '/data/sharedpref/shared_preference_helper.dart';
import '/domain/entity/ai_agent/ai_agent.dart';
import '/domain/repository/ai_agent/ai_agent_repository.dart';

class AiAgentRepositoryImpl implements AiAgentRepository {
  final AiAgentApi _api;
  final SharedPreferenceHelper _prefs;

  AiAgentRepositoryImpl(this._api, this._prefs);

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Maps an API response map to an [AiAgent] entity.
  /// Handles both `_id` (Mongo) and `id` shapes.
  AiAgent _fromJson(Map<String, dynamic> json) {
    final id = _extractAgentId(json);
    final configs = _extractConfigs(json);
    final autoResponse = _toBool(configs['autoResponse']) ?? false;
    DateTime createdAt;
    DateTime? updatedAt;
    try {
      createdAt =
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'].toString())
              : DateTime.now();
    } catch (_) {
      createdAt = DateTime.now();
    }
    try {
      updatedAt =
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'].toString())
              : null;
    } catch (_) {
      updatedAt = null;
    }
    return AiAgent(
      id: id,
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      avatarUrl: json['avatar']?.toString() ?? json['avatarUrl']?.toString(),
      mode: autoResponse ? AgentMode.auto : AgentMode.semiAuto,
      platforms: const [],
      workflows: const [],
      teamId: json['teamId']?.toString(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      websiteUrl: json['websiteUrl']?.toString(),
      toneOfAI: configs['toneOfAI']?.toString(),
      language: configs['language']?.toString(),
      includeReference: _toBool(configs['includeReference']),
      autoResponse: autoResponse,
      autoDraftResponse: _toBool(configs['autoDraftResponse']),
      enableTemplate: _toBool(configs['enableTemplate']),
      organizationDescription: configs['organizationDescription']?.toString(),
      responseFormatGuide: configs['responseFormatGuide']?.toString(),
    );
  }

  String _extractAgentId(Map<String, dynamic> json) =>
      (json['id'] ?? json['_id'] ?? '').toString();

  Map<String, dynamic> _extractConfigs(Map<String, dynamic> json) {
    final configs = json['configs'];
    if (configs is Map<String, dynamic>) {
      return configs;
    }
    if (configs is Map) {
      return Map<String, dynamic>.from(configs);
    }
    // Backward compatibility for legacy flat responses.
    return json;
  }

  bool? _toBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true') return true;
      if (normalized == 'false') return false;
    }
    return null;
  }

  UpdateAiAgentRequest _toConfigRequest(AiAgent agent) => UpdateAiAgentRequest(
    toneOfAI: agent.toneOfAI,
    language: agent.language,
    includeReference: agent.includeReference,
    autoResponse: agent.autoResponse ?? (agent.mode == AgentMode.auto),
    autoDraftResponse: agent.autoDraftResponse,
    enableTemplate: agent.enableTemplate,
    organizationDescription: agent.organizationDescription,
    responseFormatGuide: agent.responseFormatGuide,
  );

  Future<String?> _resolveTenantId() async {
    final id = (await _prefs.tenantId)?.trim();
    if (id == null || id.isEmpty) {
      return null;
    }
    return id;
  }

  Future<String> _requireTenantId() async {
    final tenantId = await _resolveTenantId();
    if (tenantId == null) {
      throw Exception('Tenant ID is required to call AI Agent APIs.');
    }
    return tenantId;
  }

  Future<String> _requireActiveAgentId(String tenantId) async {
    final json = await _api.getAgentByTenant(tenantId);
    final id = _extractAgentId(json);
    if (id.isEmpty) {
      throw Exception('Active AI Agent id is missing from tenant response.');
    }
    return id;
  }

  // ---------------------------------------------------------------------------
  // AiAgentRepository
  // ---------------------------------------------------------------------------

  @override
  Future<List<AiAgent>> getAgents() async {
    final tenantId = await _requireTenantId();

    try {
      final json = await _api.getAgentByTenant(tenantId);
      if (json.isEmpty) return [];
      return [_fromJson(json)];
    } on DioException catch (e) {
      throw Exception('Failed to load agents: ${e.message}');
    }
  }

  @override
  Future<AiAgent?> getAgentById(String id) async {
    await _requireTenantId();

    final agents = await getAgents();
    try {
      return agents.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<AiAgent> createAgent(AiAgent agent) async {
    final tenantId = await _requireTenantId();

    try {
      // 1. Create default agent without body, per backend contract.
      final created = await _api.createAgent(tenantId);
      final agentId = await _requireActiveAgentId(tenantId);
      // 2. Update runtime config for new agent.
      await _api.updateAgentById(agentId, _toConfigRequest(agent));
      // 3. Update profile (name / description / avatar).
      await _api.updateAgentInfo(
        agentId,
        name: agent.name,
        description: agent.description,
        avatar: agent.avatarUrl,
      );
      return _fromJson({
        ...created,
        'id': agentId,
        'name': agent.name,
        'description': agent.description,
        'websiteUrl': agent.websiteUrl,
        'updatedAt': DateTime.now().toIso8601String(),
        'configs': _toConfigRequest(agent).toJson(),
      });
    } on DioException catch (e) {
      throw Exception('Failed to create agent: ${e.message}');
    }
  }

  @override
  Future<AiAgent> updateAgent(AiAgent agent) async {
    final tenantId = await _requireTenantId();

    try {
      final activeAgentId = await _requireActiveAgentId(tenantId);
      // 1. Update config
      await _api.updateAgentById(activeAgentId, _toConfigRequest(agent));
      // 2. Update profile
      await _api.updateAgentInfo(
        activeAgentId,
        name: agent.name,
        description: agent.description,
        avatar: agent.avatarUrl,
      );
      return agent.copyWith(id: activeAgentId);
    } on DioException catch (e) {
      throw Exception('Failed to update agent: ${e.message}');
    }
  }

  @override
  Future<void> deleteAgent(String id) async {
    final tenantId = await _requireTenantId();

    try {
      final activeAgentId = await _requireActiveAgentId(tenantId);
      await _api.deleteAgent(activeAgentId);
    } on DioException catch (e) {
      throw Exception('Failed to delete agent: ${e.message}');
    }
  }
}
