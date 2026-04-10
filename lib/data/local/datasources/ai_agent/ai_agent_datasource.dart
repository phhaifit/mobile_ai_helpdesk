import '/domain/entity/ai_agent/ai_agent.dart';

/// In-memory mock datasource for AI agents.
/// Supports full CRUD — all changes are kept in-process only.
class AiAgentDataSource {
  final List<AiAgent> _agents = [
    AiAgent(
      id: 'agent-001',
      name: 'Aria - Order Support',
      description:
          'Handles order tracking, delivery status, and return requests for Lazada customers.',
      avatarUrl: null,
      mode: AgentMode.auto,
      platforms: ['Messenger', 'Telegram'],
      workflows: ['Order Tracking', 'Return & Refund', 'Delivery Status'],
      teamId: 'team-001',
      createdAt: DateTime(2026, 1, 10),
    ),
    AiAgent(
      id: 'agent-002',
      name: 'Max - Lead Qualifier',
      description:
          'Qualifies inbound leads and routes them to the right sales team.',
      avatarUrl: null,
      mode: AgentMode.semiAuto,
      platforms: ['Slack', 'Messenger'],
      workflows: ['Lead Qualification', 'FAQ Answering', 'Appointment Booking'],
      teamId: 'team-001',
      createdAt: DateTime(2026, 1, 15),
    ),
    AiAgent(
      id: 'agent-003',
      name: 'Nova - General Support',
      description:
          'Answers general product and service questions across all channels.',
      avatarUrl: null,
      mode: AgentMode.auto,
      platforms: ['Messenger', 'Telegram', 'Slack'],
      workflows: ['FAQ Answering', 'Complaint Handling', 'Escalation'],
      teamId: null,
      createdAt: DateTime(2026, 2, 3),
    ),
    AiAgent(
      id: 'agent-004',
      name: 'Zara - Campaign Assistant',
      description:
          'Assists with promotional campaigns and discount inquiries.',
      avatarUrl: null,
      mode: AgentMode.semiAuto,
      platforms: ['Telegram'],
      workflows: ['Promotions & Discounts', 'FAQ Answering'],
      teamId: 'team-002',
      createdAt: DateTime(2026, 2, 20),
    ),
  ];

  Future<List<AiAgent>> getAgents() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_agents);
  }

  Future<AiAgent?> getAgentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _agents.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<AiAgent> createAgent(AiAgent agent) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newAgent = agent.copyWith(
      id: 'agent-${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );
    _agents.add(newAgent);
    return newAgent;
  }

  Future<AiAgent> updateAgent(AiAgent agent) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _agents.indexWhere((a) => a.id == agent.id);
    if (index == -1) throw Exception('Agent not found: ${agent.id}');
    _agents[index] = agent;
    return agent;
  }

  Future<void> deleteAgent(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _agents.removeWhere((a) => a.id == id);
  }
}
