import 'package:ai_helpdesk/data/network/apis/ai_agent/ai_agent_api.dart';
import 'package:ai_helpdesk/data/repository/ai_agent/mock_ai_agent_repository_impl.dart';
import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/ai_agent/ai_agent.dart';
import 'package:ai_helpdesk/domain/repository/ai_agent/ai_agent_repository.dart';
import 'package:dio/dio.dart';

/// Real implementation of [AiAgentRepository] backed by AI-Services.
///
/// `getAgents` / `getAgentById` hit the BE; mutation methods (`create`,
/// `update`, `delete`) still delegate to [MockAiAgentRepositoryImpl] because
/// the BE endpoints for those aren't wired yet. Read operations fall back to
/// the mock on [DioException] or when no tenant is available, so the prompt
/// editor dropdown always has something to show during phase-1 rollout.
class AiAgentRepositoryImpl implements AiAgentRepository {
  final AiAgentApi _api;
  final MockAiAgentRepositoryImpl _fallback;

  AiAgentRepositoryImpl(this._api, this._fallback);

  Future<String?> _currentTenantId() async {
    return getIt<SharedPreferenceHelper>().tenantId;
  }

  @override
  Future<List<AiAgent>> getAgents() async {
    final tenantId = await _currentTenantId();
    if (tenantId == null || tenantId.isEmpty) {
      return _fallback.getAgents();
    }
    try {
      return await _api.getAgentsByTenant(tenantId);
    } on DioException {
      return _fallback.getAgents();
    }
  }

  @override
  Future<AiAgent?> getAgentById(String id) async {
    try {
      return await _api.getAgentById(id);
    } on DioException {
      return _fallback.getAgentById(id);
    }
  }

  @override
  Future<AiAgent> createAgent(AiAgent agent) => _fallback.createAgent(agent);

  @override
  Future<AiAgent> updateAgent(AiAgent agent) => _fallback.updateAgent(agent);

  @override
  Future<void> deleteAgent(String id) => _fallback.deleteAgent(id);
}