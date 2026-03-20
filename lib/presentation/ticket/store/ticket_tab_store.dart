import 'package:mobx/mobx.dart';
import '../../../domain/entity/ticket/ticket.dart';
import '../../../domain/entity/ticket/ticket_filter.dart';
import '../../../data/local/mock_data.dart';

part 'ticket_tab_store.g.dart';

class TicketTabStore = _TicketTabStoreBase with _$TicketTabStore;

abstract class _TicketTabStoreBase with Store {
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

  _TicketTabStoreBase() {
    // Initialize with mock data
    _initializeTickets();
    _updateFilteredTickets();
  }

  void _initializeTickets() {
    final agents = MockDataGenerator.generateAgents();
    final customers = MockDataGenerator.generateCustomers();
    allTickets = MockDataGenerator.generateTickets(agents, customers);
  }

  @action
  void setSelectedTab(int index) {
    selectedTabIndex = index;
    _updateFilteredTickets();
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

    // Filter by tab
    switch (selectedTabIndex) {
      case 0: // "Phiếu hỗ trợ của tôi" - Assigned tickets
        result = result.where((t) => t.assignedAgentId != null).toList();
        break;
      case 1: // "Phiếu chưa tiếp nhận" - Open tickets
        result = result
            .where((t) => t.assignedAgentId == null)
            .toList();
        break;
      case 2: // "Tất cả phiếu hỗ trợ" - All tickets
        break;
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      result = result
          .where(
              (t) => t.title.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    // Apply advanced filter
    result = _applyAdvancedFilter(result);

    filteredTickets = result;
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
  void acceptTicket(Ticket ticket) {
    // TODO: Implement API call to accept ticket
    print('Accepting ticket: ${ticket.id}');
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
