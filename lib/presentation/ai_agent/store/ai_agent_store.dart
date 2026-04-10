import 'package:mobx/mobx.dart';

import '/core/stores/error/error_store.dart';
import '/domain/entity/ai_agent/ai_agent.dart';
import '/domain/usecase/ai_agent/create_agent_usecase.dart';
import '/domain/usecase/ai_agent/delete_agent_usecase.dart';
import '/domain/usecase/ai_agent/get_agent_usecase.dart';
import '/domain/usecase/ai_agent/get_agents_usecase.dart';
import '/domain/usecase/ai_agent/update_agent_usecase.dart';

part 'ai_agent_store.g.dart';

class AiAgentStore = _AiAgentStore with _$AiAgentStore;

abstract class _AiAgentStore with Store {
  _AiAgentStore(
    this._getAgentsUseCase,
    this._getAgentUseCase,
    this._createAgentUseCase,
    this._updateAgentUseCase,
    this._deleteAgentUseCase,
    this.errorStore,
  );

  // use cases:-----------------------------------------------------------------
  final GetAgentsUseCase _getAgentsUseCase;
  final GetAgentUseCase _getAgentUseCase;
  final CreateAgentUseCase _createAgentUseCase;
  final UpdateAgentUseCase _updateAgentUseCase;
  final DeleteAgentUseCase _deleteAgentUseCase;

  // stores:--------------------------------------------------------------------
  final ErrorStore errorStore;

  // empty responses:-----------------------------------------------------------
  static ObservableFuture<List<AiAgent>?> emptyAgentsResponse =
      ObservableFuture.value(null);

  // store variables:-----------------------------------------------------------
  @observable
  ObservableFuture<List<AiAgent>?> fetchAgentsFuture = emptyAgentsResponse;

  @observable
  ObservableList<AiAgent> agents = ObservableList.of([]);

  @observable
  AiAgent? selectedAgent;

  @observable
  bool success = false;

  // computed:------------------------------------------------------------------
  @computed
  bool get isLoading => fetchAgentsFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------

  @action
  Future<void> fetchAgents() async {
    success = false;
    errorStore.errorMessage = '';
    final future = _getAgentsUseCase.call(params: null);
    fetchAgentsFuture = ObservableFuture(future);
    await future.then((result) {
      agents = ObservableList.of(result);
    }).catchError((e) {
      errorStore.errorMessage = e.toString();
    });
  }

  @action
  Future<void> loadAgentById(String id) async {
    errorStore.errorMessage = '';
    await _getAgentUseCase.call(params: id).then((agent) {
      selectedAgent = agent;
    }).catchError((e) {
      errorStore.errorMessage = e.toString();
    });
  }

  @action
  Future<void> createAgent(AiAgent agent) async {
    success = false;
    errorStore.errorMessage = '';
    await _createAgentUseCase.call(params: agent).then((created) {
      agents.insert(0, created);
      selectedAgent = created;
      success = true;
    }).catchError((e) {
      errorStore.errorMessage = e.toString();
    });
  }

  @action
  Future<void> updateAgent(AiAgent agent) async {
    success = false;
    errorStore.errorMessage = '';
    await _updateAgentUseCase.call(params: agent).then((updated) {
      final idx = agents.indexWhere((a) => a.id == updated.id);
      if (idx >= 0) agents[idx] = updated;
      selectedAgent = updated;
      success = true;
    }).catchError((e) {
      errorStore.errorMessage = e.toString();
    });
  }

  @action
  Future<void> deleteAgent(String id) async {
    success = false;
    errorStore.errorMessage = '';
    await _deleteAgentUseCase.call(params: id).then((_) {
      agents.removeWhere((a) => a.id == id);
      if (selectedAgent?.id == id) selectedAgent = null;
      success = true;
    }).catchError((e) {
      errorStore.errorMessage = e.toString();
    });
  }

  @action
  void selectAgent(AiAgent? agent) {
    selectedAgent = agent;
  }
}
