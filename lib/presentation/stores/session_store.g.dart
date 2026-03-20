// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SessionStore on _SessionStoreBase, Store {
  late final _$currentAgentIdAtom = Atom(
    name: '_SessionStoreBase.currentAgentId',
    context: context,
  );

  @override
  String get currentAgentId {
    _$currentAgentIdAtom.reportRead();
    return super.currentAgentId;
  }

  @override
  set currentAgentId(String value) {
    _$currentAgentIdAtom.reportWrite(value, super.currentAgentId, () {
      super.currentAgentId = value;
    });
  }

  late final _$_SessionStoreBaseActionController = ActionController(
    name: '_SessionStoreBase',
    context: context,
  );

  @override
  void setCurrentAgentId(String agentId) {
    final _$actionInfo = _$_SessionStoreBaseActionController.startAction(
      name: '_SessionStoreBase.setCurrentAgentId',
    );
    try {
      return super.setCurrentAgentId(agentId);
    } finally {
      _$_SessionStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentAgentId: ${currentAgentId}
    ''';
  }
}
