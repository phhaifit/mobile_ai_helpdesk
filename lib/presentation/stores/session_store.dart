import 'package:mobx/mobx.dart';

part 'session_store.g.dart';

class SessionStore = _SessionStoreBase with _$SessionStore;

abstract class _SessionStoreBase with Store {
  @observable
  String currentAgentId = 'agent_1';
  String get currentAgentName {
    // In a real app, you would fetch the agent's name from a user service or database
    // Here we just return a placeholder based on the currentAgentId
    switch (currentAgentId) {
      case 'agent_1':
        return 'Nguyễn An';
      case 'agent_2':
        return 'Trần Thị B';
      case 'agent_3':
        return 'Lê Văn C';
      default:
        return 'Unknown Agent';
    }
  }

  @action
  void setCurrentAgentId(String agentId) {
    currentAgentId = agentId;
  }
}