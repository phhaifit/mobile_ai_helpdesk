// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_column_visibility_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TicketColumnVisibilityStore on _TicketColumnVisibilityStoreBase, Store {
  Computed<List<TicketColumn>>? _$visibleColumnsComputed;

  @override
  List<TicketColumn> get visibleColumns =>
      (_$visibleColumnsComputed ??= Computed<List<TicketColumn>>(
            () => super.visibleColumns,
            name: '_TicketColumnVisibilityStoreBase.visibleColumns',
          ))
          .value;

  late final _$showTitleAtom = Atom(
    name: '_TicketColumnVisibilityStoreBase.showTitle',
    context: context,
  );

  @override
  bool get showTitle {
    _$showTitleAtom.reportRead();
    return super.showTitle;
  }

  @override
  set showTitle(bool value) {
    _$showTitleAtom.reportWrite(value, super.showTitle, () {
      super.showTitle = value;
    });
  }

  late final _$showStatusPriorityAtom = Atom(
    name: '_TicketColumnVisibilityStoreBase.showStatusPriority',
    context: context,
  );

  @override
  bool get showStatusPriority {
    _$showStatusPriorityAtom.reportRead();
    return super.showStatusPriority;
  }

  @override
  set showStatusPriority(bool value) {
    _$showStatusPriorityAtom.reportWrite(value, super.showStatusPriority, () {
      super.showStatusPriority = value;
    });
  }

  late final _$showCustomerAtom = Atom(
    name: '_TicketColumnVisibilityStoreBase.showCustomer',
    context: context,
  );

  @override
  bool get showCustomer {
    _$showCustomerAtom.reportRead();
    return super.showCustomer;
  }

  @override
  set showCustomer(bool value) {
    _$showCustomerAtom.reportWrite(value, super.showCustomer, () {
      super.showCustomer = value;
    });
  }

  late final _$showSourceAtom = Atom(
    name: '_TicketColumnVisibilityStoreBase.showSource',
    context: context,
  );

  @override
  bool get showSource {
    _$showSourceAtom.reportRead();
    return super.showSource;
  }

  @override
  set showSource(bool value) {
    _$showSourceAtom.reportWrite(value, super.showSource, () {
      super.showSource = value;
    });
  }

  late final _$showCreatedByAtom = Atom(
    name: '_TicketColumnVisibilityStoreBase.showCreatedBy',
    context: context,
  );

  @override
  bool get showCreatedBy {
    _$showCreatedByAtom.reportRead();
    return super.showCreatedBy;
  }

  @override
  set showCreatedBy(bool value) {
    _$showCreatedByAtom.reportWrite(value, super.showCreatedBy, () {
      super.showCreatedBy = value;
    });
  }

  late final _$showCSAgentAtom = Atom(
    name: '_TicketColumnVisibilityStoreBase.showCSAgent',
    context: context,
  );

  @override
  bool get showCSAgent {
    _$showCSAgentAtom.reportRead();
    return super.showCSAgent;
  }

  @override
  set showCSAgent(bool value) {
    _$showCSAgentAtom.reportWrite(value, super.showCSAgent, () {
      super.showCSAgent = value;
    });
  }

  late final _$showCreatedDateAtom = Atom(
    name: '_TicketColumnVisibilityStoreBase.showCreatedDate',
    context: context,
  );

  @override
  bool get showCreatedDate {
    _$showCreatedDateAtom.reportRead();
    return super.showCreatedDate;
  }

  @override
  set showCreatedDate(bool value) {
    _$showCreatedDateAtom.reportWrite(value, super.showCreatedDate, () {
      super.showCreatedDate = value;
    });
  }

  late final _$showUpdatedDateAtom = Atom(
    name: '_TicketColumnVisibilityStoreBase.showUpdatedDate',
    context: context,
  );

  @override
  bool get showUpdatedDate {
    _$showUpdatedDateAtom.reportRead();
    return super.showUpdatedDate;
  }

  @override
  set showUpdatedDate(bool value) {
    _$showUpdatedDateAtom.reportWrite(value, super.showUpdatedDate, () {
      super.showUpdatedDate = value;
    });
  }

  late final _$showActionsAtom = Atom(
    name: '_TicketColumnVisibilityStoreBase.showActions',
    context: context,
  );

  @override
  bool get showActions {
    _$showActionsAtom.reportRead();
    return super.showActions;
  }

  @override
  set showActions(bool value) {
    _$showActionsAtom.reportWrite(value, super.showActions, () {
      super.showActions = value;
    });
  }

  late final _$_TicketColumnVisibilityStoreBaseActionController =
      ActionController(
        name: '_TicketColumnVisibilityStoreBase',
        context: context,
      );

  @override
  void setColumnVisibility(TicketColumn column, bool visible) {
    final _$actionInfo = _$_TicketColumnVisibilityStoreBaseActionController
        .startAction(
          name: '_TicketColumnVisibilityStoreBase.setColumnVisibility',
        );
    try {
      return super.setColumnVisibility(column, visible);
    } finally {
      _$_TicketColumnVisibilityStoreBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  String toString() {
    return '''
showTitle: ${showTitle},
showStatusPriority: ${showStatusPriority},
showCustomer: ${showCustomer},
showSource: ${showSource},
showCreatedBy: ${showCreatedBy},
showCSAgent: ${showCSAgent},
showCreatedDate: ${showCreatedDate},
showUpdatedDate: ${showUpdatedDate},
showActions: ${showActions},
visibleColumns: ${visibleColumns}
    ''';
  }
}
