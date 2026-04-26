import 'package:dio/dio.dart';

import '/data/network/apis/ai_agent/ai_agent_api.dart';
import '/data/network/models/request/update_ai_agent_request.dart';
import '/data/sharedpref/shared_preference_helper.dart';
import '/domain/entity/ai_agent/ai_agent.dart';
import '/domain/repository/ai_agent/ai_agent_repository.dart';

class AiAgentRepositoryImpl implements AiAgentRepository {
  final AiAgentApi _api;
  final SharedPreferenceHelper _prefs;
  final AiAgentRepository _fallbackRepository;

  AiAgentRepositoryImpl(
    this._api,
    this._prefs, {
    required AiAgentRepository fallbackRepository,
  }) : _fallbackRepository = fallbackRepository;

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Maps an API response map to an [AiAgent] entity.
  /// Handles both `_id` (Mongo) and `id` shapes.
  AiAgent _fromJson(Map<String, dynamic> json) {
    final id = (json['_id'] ?? json['id'] ?? '').toString();
    final autoResponse = json['autoResponse'] as bool? ?? false;
    DateTime createdAt;
    try {
      createdAt =
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'].toString())
              : DateTime.now();
    } catch (_) {
      createdAt = DateTime.now();
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
      toneOfAI: json['toneOfAI']?.toString(),
      language: json['language']?.toString(),
      includeReference: json['includeReference'] as bool?,
      autoResponse: autoResponse,
      autoDraftResponse: json['autoDraftResponse'] as bool?,
      enableTemplate: json['enableTemplate'] as bool?,
    );
  }

  UpdateAiAgentRequest _toConfigRequest(AiAgent agent) => UpdateAiAgentRequest(
    toneOfAI: agent.toneOfAI,
    language: agent.language,
    includeReference: agent.includeReference,
    autoResponse: agent.autoResponse ?? (agent.mode == AgentMode.auto),
    autoDraftResponse: agent.autoDraftResponse,
    enableTemplate: agent.enableTemplate,
  );

  Future<String?> _resolveTenantId() async {
    final id = (await _prefs.tenantId)?.trim();
    if (id == null || id.isEmpty) {
      return null;
    }
    return id;
  }

  // ---------------------------------------------------------------------------
  // AiAgentRepository
  // ---------------------------------------------------------------------------

  @override
  Future<List<AiAgent>> getAgents() async {
    final tenantId = await _resolveTenantId();
    if (tenantId == null) {
      return _fallbackRepository.getAgents();
    }

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
    final tenantId = await _resolveTenantId();
    if (tenantId == null) {
      return _fallbackRepository.getAgentById(id);
    }

    final agents = await getAgents();
    try {
      return agents.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<AiAgent> createAgent(AiAgent agent) async {
    final tenantId = await _resolveTenantId();
    if (tenantId == null) {
      return _fallbackRepository.createAgent(agent);
    }

    try {
      // 1. Create with config fields
      final created = await _api.createAgent(tenantId, _toConfigRequest(agent));
      final agentId = (created['_id'] ?? created['id'] ?? '').toString();
      // 2. Update profile (name / description / avatar)
      await _api.updateAgentInfo(
        agentId,
        name: agent.name,
        description: agent.description,
        avatar: agent.avatarUrl,
      );
      return _fromJson({
        ...created,
        'name': agent.name,
        'description': agent.description,
      });
    } on DioException catch (e) {
      throw Exception('Failed to create agent: ${e.message}');
    }
  }

  @override
  Future<AiAgent> updateAgent(AiAgent agent) async {
    final tenantId = await _resolveTenantId();
    if (tenantId == null) {
      return _fallbackRepository.updateAgent(agent);
    }

    try {
      // 1. Update config
      await _api.updateAgentById(agent.id, _toConfigRequest(agent));
      // 2. Update profile
      await _api.updateAgentInfo(
        agent.id,
        name: agent.name,
        description: agent.description,
        avatar: agent.avatarUrl,
      );
      return agent;
    } on DioException catch (e) {
      throw Exception('Failed to update agent: ${e.message}');
    }
  }

  @override
  Future<void> deleteAgent(String id) async {
    final tenantId = await _resolveTenantId();
    if (tenantId == null) {
      return _fallbackRepository.deleteAgent(id);
    }

    try {
      await _api.deleteAgent(id);
    } on DioException catch (e) {
      throw Exception('Failed to delete agent: ${e.message}');
    }
  }
}
