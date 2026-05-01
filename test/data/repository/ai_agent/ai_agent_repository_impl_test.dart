import 'package:ai_helpdesk/core/data/network/dio/configs/dio_configs.dart';
import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/apis/ai_agent/ai_agent_api.dart';
import 'package:ai_helpdesk/data/network/models/request/update_ai_agent_request.dart';
import 'package:ai_helpdesk/data/repository/ai_agent/ai_agent_repository_impl.dart';
import 'package:ai_helpdesk/data/sharedpref/constants/preferences.dart';
import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/domain/entity/ai_agent/ai_agent.dart';
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
    test('getAgents throws when tenantId is missing', () async {
      final api = _FakeAiAgentApi();
      final prefs = await _buildPrefs(<String, Object>{});
      final repo = AiAgentRepositoryImpl(api, prefs);

      await expectLater(repo.getAgents(), throwsA(isA<Exception>()));
      expect(api.getAgentByTenantCallCount, 0);
    });

    test('createAgent throws when tenantId is missing', () async {
      final api = _FakeAiAgentApi();
      final prefs = await _buildPrefs(<String, Object>{});
      final repo = AiAgentRepositoryImpl(api, prefs);

      await expectLater(repo.createAgent(_sampleAgent()), throwsA(isA<Exception>()));
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
      final repo = AiAgentRepositoryImpl(api, prefs);

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
      final repo = AiAgentRepositoryImpl(api, prefs);

      final created = await repo.createAgent(_sampleAgent());

      expect(api.createAgentCallCount, 1);
      expect(api.updateAgentInfoCallCount, 1);
      expect(api.lastTenantId, 'tn-abc');
      expect(created.id, 'agent-created');
      expect(created.name, 'Support Bot');
    });
  });
}