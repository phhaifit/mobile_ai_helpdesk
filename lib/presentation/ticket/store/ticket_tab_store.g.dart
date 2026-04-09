// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_tab_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TicketTabStore on _TicketTabStoreBase, Store {
  Computed<String>? _$currentAgentIdComputed;

  @override
  String get currentAgentId =>
      (_$currentAgentIdComputed ??= Computed<String>(
            () => super.currentAgentId,
            name: '_TicketTabStoreBase.currentAgentId',
          ))
          .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(
            () => super.isLoading,
            name: '_TicketTabStoreBase.isLoading',
          ))
          .value;
  Computed<int>? _$ticketCountComputed;

  @override
  int get ticketCount =>
      (_$ticketCountComputed ??= Computed<int>(
            () => super.ticketCount,
            name: '_TicketTabStoreBase.ticketCount',
          ))
          .value;
  Computed<String>? _$tabTitleComputed;

  @override
  String get tabTitle =>
      (_$tabTitleComputed ??= Computed<String>(
            () => super.tabTitle,
            name: '_TicketTabStoreBase.tabTitle',
          ))
          .value;

  late final _$selectedTabIndexAtom = Atom(
    name: '_TicketTabStoreBase.selectedTabIndex',
    context: context,
  );

  @override
  int get selectedTabIndex {
    _$selectedTabIndexAtom.reportRead();
    return super.selectedTabIndex;
  }

  @override
  set selectedTabIndex(int value) {
    _$selectedTabIndexAtom.reportWrite(value, super.selectedTabIndex, () {
      super.selectedTabIndex = value;
    });
  }

  late final _$searchQueryAtom = Atom(
    name: '_TicketTabStoreBase.searchQuery',
    context: context,
  );

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$activeFilterAtom = Atom(
    name: '_TicketTabStoreBase.activeFilter',
    context: context,
  );

  @override
  TicketFilter get activeFilter {
    _$activeFilterAtom.reportRead();
    return super.activeFilter;
  }

  @override
  set activeFilter(TicketFilter value) {
    _$activeFilterAtom.reportWrite(value, super.activeFilter, () {
      super.activeFilter = value;
    });
  }

  late final _$allTicketsAtom = Atom(
    name: '_TicketTabStoreBase.allTickets',
    context: context,
  );

  @override
  List<Ticket> get allTickets {
    _$allTicketsAtom.reportRead();
    return super.allTickets;
  }

  @override
  set allTickets(List<Ticket> value) {
    _$allTicketsAtom.reportWrite(value, super.allTickets, () {
      super.allTickets = value;
    });
  }

  late final _$filteredTicketsAtom = Atom(
    name: '_TicketTabStoreBase.filteredTickets',
    context: context,
  );

  @override
  List<Ticket> get filteredTickets {
    _$filteredTicketsAtom.reportRead();
    return super.filteredTickets;
  }

  @override
  set filteredTickets(List<Ticket> value) {
    _$filteredTicketsAtom.reportWrite(value, super.filteredTickets, () {
      super.filteredTickets = value;
    });
  }

  late final _$isCreateModeAtom = Atom(
    name: '_TicketTabStoreBase.isCreateMode',
    context: context,
  );

  @override
  bool get isCreateMode {
    _$isCreateModeAtom.reportRead();
    return super.isCreateMode;
  }

  @override
  set isCreateMode(bool value) {
    _$isCreateModeAtom.reportWrite(value, super.isCreateMode, () {
      super.isCreateMode = value;
    });
  }

  late final _$loadTicketsFutureAtom = Atom(
    name: '_TicketTabStoreBase.loadTicketsFuture',
    context: context,
  );

  @override
  ObservableFuture<List<Ticket>> get loadTicketsFuture {
    _$loadTicketsFutureAtom.reportRead();
    return super.loadTicketsFuture;
  }

  @override
  set loadTicketsFuture(ObservableFuture<List<Ticket>> value) {
    _$loadTicketsFutureAtom.reportWrite(value, super.loadTicketsFuture, () {
      super.loadTicketsFuture = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_TicketTabStoreBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$loadTicketsAsyncAction = AsyncAction(
    '_TicketTabStoreBase.loadTickets',
    context: context,
  );

  @override
  Future<void> loadTickets() {
    return _$loadTicketsAsyncAction.run(() => super.loadTickets());
  }

  late final _$acceptTicketAsyncAction = AsyncAction(
    '_TicketTabStoreBase.acceptTicket',
    context: context,
  );

  @override
  Future<void> acceptTicket(Ticket ticket) {
    return _$acceptTicketAsyncAction.run(() => super.acceptTicket(ticket));
  }

  late final _$cancelTicketAsyncAction = AsyncAction(
    '_TicketTabStoreBase.cancelTicket',
    context: context,
  );

  @override
  Future<bool> cancelTicket(Ticket ticket) {
    return _$cancelTicketAsyncAction.run(() => super.cancelTicket(ticket));
  }

  late final _$_TicketTabStoreBaseActionController = ActionController(
    name: '_TicketTabStoreBase',
    context: context,
  );

  @override
  void setSelectedTab(int index) {
    final _$actionInfo = _$_TicketTabStoreBaseActionController.startAction(
      name: '_TicketTabStoreBase.setSelectedTab',
    );
    try {
      return super.setSelectedTab(index);
    } finally {
      _$_TicketTabStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchQuery(String query) {
    final _$actionInfo = _$_TicketTabStoreBaseActionController.startAction(
      name: '_TicketTabStoreBase.setSearchQuery',
    );
    try {
      return super.setSearchQuery(query);
    } finally {
      _$_TicketTabStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFilter(TicketFilter filter) {
    final _$actionInfo = _$_TicketTabStoreBaseActionController.startAction(
      name: '_TicketTabStoreBase.setFilter',
    );
    try {
      return super.setFilter(filter);
    } finally {
      _$_TicketTabStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearFilter() {
    final _$actionInfo = _$_TicketTabStoreBaseActionController.startAction(
      name: '_TicketTabStoreBase.clearFilter',
    );
    try {
      return super.clearFilter();
    } finally {
      _$_TicketTabStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _updateFilteredTickets() {
    final _$actionInfo = _$_TicketTabStoreBaseActionController.startAction(
      name: '_TicketTabStoreBase._updateFilteredTickets',
    );
    try {
      return super._updateFilteredTickets();
    } finally {
      _$_TicketTabStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void viewTicketDetails(Ticket ticket) {
    final _$actionInfo = _$_TicketTabStoreBaseActionController.startAction(
      name: '_TicketTabStoreBase.viewTicketDetails',
    );
    try {
      return super.viewTicketDetails(ticket);
    } finally {
      _$_TicketTabStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void openCreateMode() {
    final _$actionInfo = _$_TicketTabStoreBaseActionController.startAction(
      name: '_TicketTabStoreBase.openCreateMode',
    );
    try {
      return super.openCreateMode();
    } finally {
      _$_TicketTabStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeCreateMode() {
    final _$actionInfo = _$_TicketTabStoreBaseActionController.startAction(
      name: '_TicketTabStoreBase.closeCreateMode',
    );
    try {
      return super.closeCreateMode();
    } finally {
      _$_TicketTabStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedTabIndex: ${selectedTabIndex},
searchQuery: ${searchQuery},
activeFilter: ${activeFilter},
allTickets: ${allTickets},
filteredTickets: ${filteredTickets},
isCreateMode: ${isCreateMode},
loadTicketsFuture: ${loadTicketsFuture},
errorMessage: ${errorMessage},
currentAgentId: ${currentAgentId},
isLoading: ${isLoading},
ticketCount: ${ticketCount},
tabTitle: ${tabTitle}
    ''';
  }
}
