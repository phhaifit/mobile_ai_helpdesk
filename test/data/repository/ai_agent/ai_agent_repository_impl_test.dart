import 'package:ai_helpdesk/core/data/network/dio/configs/dio_configs.dart';
import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/apis/ai_agent/ai_agent_api.dart';
import 'package:ai_helpdesk/data/network/models/request/update_ai_agent_request.dart';
import 'package:ai_helpdesk/data/repository/ai_agent/ai_agent_repository_impl.dart';
import 'package:ai_helpdesk/data/sharedpref/constants/preferences.dart';
import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/domain/entity/ai_agent/ai_agent.dart';
import 'package:ai_helpdesk/domain/repository/ai_agent/ai_agent_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAiAgentApi extends AiAgentApi {
  _FakeAiAgentApi()
    : super(
        DioClient(
          dioConfigs: const DioConfigs(baseUrl: 'https://example.com'),
        ),
      );

  int getAgentByTenantCallCount = 0;
  int createAgentCallCount = 0;
  int updateAgentInfoCallCount = 0;
  String? lastTenantId;

  Map<String, dynamic> getAgentByTenantResponse = <String, dynamic>{};
  Map<String, dynamic> createAgentResponse = <String, dynamic>{
    '_id': 'agent-created',
    'autoResponse': false,
    'createdAt': '2024-01-01T00:00:00.000Z',
  };

  @override
  Future<Map<String, dynamic>> getAgentByTenant(String tenantId) async {
    getAgentByTenantCallCount += 1;
    lastTenantId = tenantId;
    return getAgentByTenantResponse;
  }

  @override
  Future<Map<String, dynamic>> createAgent(
    String tenantId,
    UpdateAiAgentRequest dto,
  ) async {
    createAgentCallCount += 1;
    lastTenantId = tenantId;
    return createAgentResponse;
  }

  @override
  Future<Map<String, dynamic>> updateAgentInfo(
    String agentId, {
    String? name,
    String? description,
    String? avatar,
  }) async {
    updateAgentInfoCallCount += 1;
    return <String, dynamic>{'id': agentId};
  }
}

class _FakeFallbackAiAgentRepository implements AiAgentRepository {
  int getAgentsCallCount = 0;
  int createAgentCallCount = 0;
  int updateAgentCallCount = 0;
  int deleteAgentCallCount = 0;

  final List<AiAgent> _agents = <AiAgent>[
    AiAgent(
      id: 'fallback-1',
      name: 'Fallback Agent',
      description: 'Used when tenant is missing',
      avatarUrl: null,
      mode: AgentMode.semiAuto,
      platforms: const <String>[],
      workflows: const <String>[],
      teamId: null,
      createdAt: DateTime(2024, 1, 1),
    ),
  ];

  @override
  Future<List<AiAgent>> getAgents() async {
    getAgentsCallCount += 1;
    return List<AiAgent>.from(_agents);
  }

  @override
  Future<AiAgent?> getAgentById(String id) async {
    for (final agent in _agents) {
      if (agent.id == id) return agent;
    }
    return null;
  }

  @override
  Future<AiAgent> createAgent(AiAgent agent) async {
    createAgentCallCount += 1;
    final created = agent.copyWith(id: 'fallback-created');
    _agents.add(created);
    return created;
  }

  @override
  Future<AiAgent> updateAgent(AiAgent agent) async {
    updateAgentCallCount += 1;
    final idx = _agents.indexWhere((a) => a.id == agent.id);
    if (idx >= 0) {
      _agents[idx] = agent;
      return agent;
    }
    throw Exception('Agent not found');
  }

  @override
  Future<void> deleteAgent(String id) async {
    deleteAgentCallCount += 1;
    _agents.removeWhere((a) => a.id == id);
  }
}

Future<SharedPreferenceHelper> _buildPrefs(Map<String, Object> initial) async {
  SharedPreferences.setMockInitialValues(initial);
  final prefs = await SharedPreferences.getInstance();
  return SharedPreferenceHelper(prefs);
}

AiAgent _sampleAgent() {
  return AiAgent(
    id: 'agent-1',
    name: 'Support Bot',
    description: 'Handles support questions',
    avatarUrl: null,
    mode: AgentMode.semiAuto,
    platforms: const <String>[],
    workflows: const <String>[],
    teamId: null,
    createdAt: DateTime(2024, 1, 1),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AiAgentRepositoryImpl tenant handling', () {
    test('getAgents falls back when tenantId is missing', () async {
      final api = _FakeAiAgentApi();
      final prefs = await _buildPrefs(<String, Object>{});
      final fallback = _FakeFallbackAiAgentRepository();
      final repo = AiAgentRepositoryImpl(
        api,
        prefs,
        fallbackRepository: fallback,
      );

      final agents = await repo.getAgents();

      expect(agents, hasLength(1));
      expect(agents.first.id, 'fallback-1');
      expect(fallback.getAgentsCallCount, 1);
      expect(api.getAgentByTenantCallCount, 0);
    });

    test('createAgent falls back when tenantId is missing', () async {
      final api = _FakeAiAgentApi();
      final prefs = await _buildPrefs(<String, Object>{});
      final fallback = _FakeFallbackAiAgentRepository();
      final repo = AiAgentRepositoryImpl(
        api,
        prefs,
        fallbackRepository: fallback,
      );

      final created = await repo.createAgent(_sampleAgent());

      expect(created.id, 'fallback-created');
      expect(fallback.createAgentCallCount, 1);
      expect(api.createAgentCallCount, 0);
      expect(api.updateAgentInfoCallCount, 0);
    });

    test('getAgents uses tenantId from shared preferences', () async {
      final api = _FakeAiAgentApi()
        ..getAgentByTenantResponse = <String, dynamic>{
          '_id': 'agent-remote-1',
          'name': 'Remote Agent',
          'description': 'Loaded from API',
          'autoResponse': true,
          'createdAt': '2025-01-01T00:00:00.000Z',
        };
      final prefs = await _buildPrefs(<String, Object>{
        Preferences.tenantId: 'tn-001',
      });
      final repo = AiAgentRepositoryImpl(
        api,
        prefs,
        fallbackRepository: _FakeFallbackAiAgentRepository(),
      );

      final agents = await repo.getAgents();

      expect(api.getAgentByTenantCallCount, 1);
      expect(api.lastTenantId, 'tn-001');
      expect(agents, hasLength(1));
      expect(agents.first.id, 'agent-remote-1');
      expect(agents.first.mode, AgentMode.auto);
    });

    test('createAgent uses tenantId and updates profile info', () async {
      final api = _FakeAiAgentApi();
      final prefs = await _buildPrefs(<String, Object>{
        Preferences.tenantId: 'tn-abc',
      });
      final repo = AiAgentRepositoryImpl(
        api,
        prefs,
        fallbackRepository: _FakeFallbackAiAgentRepository(),
      );

      final created = await repo.createAgent(_sampleAgent());

      expect(api.createAgentCallCount, 1);
      expect(api.updateAgentInfoCallCount, 1);
      expect(api.lastTenantId, 'tn-abc');
      expect(created.id, 'agent-created');
      expect(created.name, 'Support Bot');
    });
  });
}