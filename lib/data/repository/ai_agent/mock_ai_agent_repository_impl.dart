import '/data/local/datasources/ai_agent/ai_agent_datasource.dart';
import '/domain/entity/ai_agent/ai_agent.dart';
import '/domain/repository/ai_agent/ai_agent_repository.dart';

class MockAiAgentRepositoryImpl implements AiAgentRepository {
  final AiAgentDataSource _dataSource;

  MockAiAgentRepositoryImpl(this._dataSource);

  @override
  Future<List<AiAgent>> getAgents() => _dataSource.getAgents();

  @override
  Future<AiAgent?> getAgentById(String id) => _dataSource.getAgentById(id);

  @override
  Future<AiAgent> createAgent(AiAgent agent) =>
      _dataSource.createAgent(agent);

  @override
  Future<AiAgent> updateAgent(AiAgent agent) =>
      _dataSource.updateAgent(agent);

  @override
  Future<void> deleteAgent(String id) => _dataSource.deleteAgent(id);
}
