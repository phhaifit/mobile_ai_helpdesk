import 'package:mobx/mobx.dart';

part 'session_store.g.dart';

class SessionStore = _SessionStoreBase with _$SessionStore;

abstract class _SessionStoreBase with Store {
  @observable
  String currentAgentId = 'agent_1';

  @action
  void setCurrentAgentId(String agentId) {
    currentAgentId = agentId;
  }
}