import 'package:mobx/mobx.dart';
import '../../../domain/entity/ticket/ticket.dart';
import '../../../domain/entity/ticket/ticket_filter.dart';
import '../../../domain/entity/ticket/ticket_query_params.dart';
import '../../../domain/usecase/ticket/assign_agent_usecase.dart';
import '../../../domain/usecase/ticket/get_tickets_usecase.dart';
import '../../stores/session_store.dart';

part 'ticket_tab_store.g.dart';

class TicketTabStore = _TicketTabStoreBase with _$TicketTabStore;

abstract class _TicketTabStoreBase with Store {
  final SessionStore _sessionStore;
  final GetTicketsUseCase _getTicketsUseCase;
  final AssignAgentUseCase _assignAgentUseCase;

  @observable
  int selectedTabIndex = 1; // Default to "Phiếu chưa tiếp nhận"

  @observable
  String searchQuery = '';

  @observable
  TicketFilter activeFilter = TicketFilter.empty();

  @observable
  List<Ticket> allTickets = [];

  @observable
  List<Ticket> filteredTickets = [];

  @observable
  bool isCreateMode = false;

  @observable
  ObservableFuture<List<Ticket>> loadTicketsFuture =
      ObservableFuture.value(const []);

  @observable
  String? errorMessage;

  _TicketTabStoreBase(
    this._sessionStore,
    this._getTicketsUseCase,
    this._assignAgentUseCase,
  ) {
    loadTickets();
    _updateFilteredTickets();
  }

  @computed
  String get currentAgentId => _sessionStore.currentAgentId;

  @computed
  bool get isLoading => loadTicketsFuture.status == FutureStatus.pending;

  TicketTabScope get _currentTabScope {
    switch (selectedTabIndex) {
      case 0:
        return TicketTabScope.my;
      case 1:
        return TicketTabScope.unassigned;
      case 2:
      default:
        return TicketTabScope.all;
    }
  }

  @action
  Future<void> loadTickets() async {
    errorMessage = null;

    final params = TicketQueryParams(
      tab: _currentTabScope,
      currentAgentId: currentAgentId,
    );

    loadTicketsFuture = ObservableFuture(
      _getTicketsUseCase.call(params: params),
    );

    try {
      allTickets = await loadTicketsFuture;
      _updateFilteredTickets();
    } catch (e) {
      errorMessage = e.toString();
      allTickets = [];
      filteredTickets = [];
    }
  }

  @action
  void setSelectedTab(int index) {
    selectedTabIndex = index;
    loadTickets();
  }

  @action
  void setSearchQuery(String query) {
    searchQuery = query;
    _updateFilteredTickets();
  }

  @action
  void setFilter(TicketFilter filter) {
    activeFilter = filter;
    _updateFilteredTickets();
  }

  @action
  void clearFilter() {
    activeFilter = TicketFilter.empty();
    _updateFilteredTickets();
  }

  @action
  void _updateFilteredTickets() {
    List<Ticket> result = List.from(allTickets);

    result = _applyTabFilter(result);
    result = _applySearchFilter(result);

    // Apply advanced filter
    result = _applyAdvancedFilter(result);

    filteredTickets = result;
  }

  List<Ticket> _applyTabFilter(List<Ticket> tickets) {
    switch (selectedTabIndex) {
      case 0: // "Phiếu hỗ trợ của tôi" - Assigned to current agent
        return tickets
            .where((ticket) => ticket.assignedAgentId == currentAgentId)
            .toList();
      case 1: // "Phiếu chưa tiếp nhận"
        return tickets
            .where((ticket) => ticket.assignedAgentId == null)
            .toList();
      case 2: // "Tất cả phiếu hỗ trợ"
      default:
        return tickets;
    }
  }

  List<Ticket> _applySearchFilter(List<Ticket> tickets) {
    if (searchQuery.isEmpty) {
      return tickets;
    }

    final normalizedQuery = searchQuery.toLowerCase();
    return tickets
        .where((ticket) =>
            ticket.title.toLowerCase().contains(normalizedQuery) ||
            ticket.id.toLowerCase().contains(normalizedQuery) ||
            ticket.customerName.toLowerCase().contains(normalizedQuery))
        .toList();
  }

  List<Ticket> _applyAdvancedFilter(List<Ticket> tickets) {
    if (activeFilter.isEmpty) {
      return tickets;
    }

    return tickets.where((ticket) {
      // Filter by statuses
      if (activeFilter.statuses != null && activeFilter.statuses!.isNotEmpty) {
        if (!activeFilter.statuses!.contains(ticket.status)) {
          return false;
        }
      }

      // Filter by priorities
      if (activeFilter.priorities != null && activeFilter.priorities!.isNotEmpty) {
        if (!activeFilter.priorities!.contains(ticket.priority)) {
          return false;
        }
      }

      // Filter by sources
      if (activeFilter.sources != null && activeFilter.sources!.isNotEmpty) {
        if (!activeFilter.sources!.contains(ticket.source)) {
          return false;
        }
      }

      // Filter by categories
      if (activeFilter.categories != null && activeFilter.categories!.isNotEmpty) {
        if (!activeFilter.categories!.contains(ticket.category)) {
          return false;
        }
      }

      // Filter by created by (agent)
      if (activeFilter.createdById != null && activeFilter.createdById!.isNotEmpty) {
        if (ticket.createdByID != activeFilter.createdById) {
          return false;
        }
      }

      // Filter by customer
      if (activeFilter.customerId != null && activeFilter.customerId!.isNotEmpty) {
        if (ticket.customerId != activeFilter.customerId) {
          return false;
        }
      }

      // Filter by date range
      if (activeFilter.fromDate != null) {
        final fromDateStart = DateTime(
          activeFilter.fromDate!.year,
          activeFilter.fromDate!.month,
          activeFilter.fromDate!.day,
        );
        if (ticket.createdAt.isBefore(fromDateStart)) {
          return false;
        }
      }

      if (activeFilter.toDate != null) {
        final toDateEnd = DateTime(
          activeFilter.toDate!.year,
          activeFilter.toDate!.month,
          activeFilter.toDate!.day,
          23,
          59,
          59,
        );
        if (ticket.createdAt.isAfter(toDateEnd)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @computed
  int get ticketCount => filteredTickets.length;

  @computed
  String get tabTitle {
    switch (selectedTabIndex) {
      case 0:
        return 'Phiếu hỗ trợ của tôi';
      case 1:
        return 'Phiếu chưa tiếp nhận';
      case 2:
        return 'Tất cả phiếu hỗ trợ';
      default:
        return 'Phiếu hỗ trợ';
    }
  }

  @action
  Future<void> acceptTicket(Ticket ticket) async {
    try {
      errorMessage = null;
      await _assignAgentUseCase.call(
        params: AssignAgentParams(
          ticketId: ticket.id,
          agentId: currentAgentId,
        ),
      );
      await loadTickets();
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  void viewTicketDetails(Ticket ticket) {
    // TODO: Navigate to ticket detail screen
    print('Viewing details for ticket: ${ticket.id}');
  }

  @action
  void openCreateMode() {
    isCreateMode = true;
  }

  @action
  void closeCreateMode() {
    isCreateMode = false;
  }
}
