import '/domain/entity/ai_agent/ai_agent.dart';

abstract class AiAgentRepository {
  Future<List<AiAgent>> getAgents();
  Future<AiAgent?> getAgentById(String id);
  Future<AiAgent> createAgent(AiAgent agent);
  Future<AiAgent> updateAgent(AiAgent agent);
  Future<void> deleteAgent(String id);
}
