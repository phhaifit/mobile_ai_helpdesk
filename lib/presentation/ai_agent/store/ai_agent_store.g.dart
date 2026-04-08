// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_agent_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AiAgentStore on _AiAgentStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(
            () => super.isLoading,
            name: '_AiAgentStore.isLoading',
          ))
          .value;

  late final _$fetchAgentsFutureAtom = Atom(
    name: '_AiAgentStore.fetchAgentsFuture',
    context: context,
  );

  @override
  ObservableFuture<List<AiAgent>?> get fetchAgentsFuture {
    _$fetchAgentsFutureAtom.reportRead();
    return super.fetchAgentsFuture;
  }

  @override
  set fetchAgentsFuture(ObservableFuture<List<AiAgent>?> value) {
    _$fetchAgentsFutureAtom.reportWrite(value, super.fetchAgentsFuture, () {
      super.fetchAgentsFuture = value;
    });
  }

  late final _$agentsAtom = Atom(
    name: '_AiAgentStore.agents',
    context: context,
  );

  @override
  ObservableList<AiAgent> get agents {
    _$agentsAtom.reportRead();
    return super.agents;
  }

  @override
  set agents(ObservableList<AiAgent> value) {
    _$agentsAtom.reportWrite(value, super.agents, () {
      super.agents = value;
    });
  }

  late final _$selectedAgentAtom = Atom(
    name: '_AiAgentStore.selectedAgent',
    context: context,
  );

  @override
  AiAgent? get selectedAgent {
    _$selectedAgentAtom.reportRead();
    return super.selectedAgent;
  }

  @override
  set selectedAgent(AiAgent? value) {
    _$selectedAgentAtom.reportWrite(value, super.selectedAgent, () {
      super.selectedAgent = value;
    });
  }

  late final _$successAtom = Atom(
    name: '_AiAgentStore.success',
    context: context,
  );

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$fetchAgentsAsyncAction = AsyncAction(
    '_AiAgentStore.fetchAgents',
    context: context,
  );

  @override
  Future<void> fetchAgents() {
    return _$fetchAgentsAsyncAction.run(() => super.fetchAgents());
  }

  late final _$loadAgentByIdAsyncAction = AsyncAction(
    '_AiAgentStore.loadAgentById',
    context: context,
  );

  @override
  Future<void> loadAgentById(String id) {
    return _$loadAgentByIdAsyncAction.run(() => super.loadAgentById(id));
  }

  late final _$createAgentAsyncAction = AsyncAction(
    '_AiAgentStore.createAgent',
    context: context,
  );

  @override
  Future<void> createAgent(AiAgent agent) {
    return _$createAgentAsyncAction.run(() => super.createAgent(agent));
  }

  late final _$updateAgentAsyncAction = AsyncAction(
    '_AiAgentStore.updateAgent',
    context: context,
  );

  @override
  Future<void> updateAgent(AiAgent agent) {
    return _$updateAgentAsyncAction.run(() => super.updateAgent(agent));
  }

  late final _$deleteAgentAsyncAction = AsyncAction(
    '_AiAgentStore.deleteAgent',
    context: context,
  );

  @override
  Future<void> deleteAgent(String id) {
    return _$deleteAgentAsyncAction.run(() => super.deleteAgent(id));
  }

  late final _$_AiAgentStoreActionController = ActionController(
    name: '_AiAgentStore',
    context: context,
  );

  @override
  void selectAgent(AiAgent? agent) {
    final _$actionInfo = _$_AiAgentStoreActionController.startAction(
      name: '_AiAgentStore.selectAgent',
    );
    try {
      return super.selectAgent(agent);
    } finally {
      _$_AiAgentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchAgentsFuture: ${fetchAgentsFuture},
agents: ${agents},
selectedAgent: ${selectedAgent},
success: ${success},
isLoading: ${isLoading}
    ''';
  }
}
