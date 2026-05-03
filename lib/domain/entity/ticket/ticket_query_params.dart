import '../enums.dart';

enum TicketTabScope { my, unassigned, all }

class TicketQueryParams {
  final TicketTabScope tab;
  final String? currentAgentId;
  final int offset;
  final int limit;
  final String? search;
  final List<TicketStatus>? statuses;
  final List<TicketPriority>? priorities;
  final List<TicketSource>? sources;
  final List<TicketCategory>? categories;
  final String? createdById;
  final String? customerId;
  final DateTime? fromDate;
  final DateTime? toDate;

  const TicketQueryParams({
    this.tab = TicketTabScope.all,
    this.currentAgentId,
    this.offset = 0,
    this.limit = 20,
    this.search,
    this.statuses,
    this.priorities,
    this.sources,
    this.categories,
    this.createdById,
    this.customerId,
    this.fromDate,
    this.toDate,
  });

  TicketQueryParams copyWith({
    TicketTabScope? tab,
    String? currentAgentId,
    int? offset,
    int? limit,
    String? search,
    List<TicketStatus>? statuses,
    List<TicketPriority>? priorities,
    List<TicketSource>? sources,
    List<TicketCategory>? categories,
    String? createdById,
    String? customerId,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return TicketQueryParams(
      tab: tab ?? this.tab,
      currentAgentId: currentAgentId ?? this.currentAgentId,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      search: search ?? this.search,
      statuses:
          (statuses?.isEmpty ?? false) ? null : (statuses ?? this.statuses),
      priorities:
          (priorities?.isEmpty ?? false)
              ? null
              : (priorities ?? this.priorities),
      sources: (sources?.isEmpty ?? false) ? null : (sources ?? this.sources),
      categories:
          (categories?.isEmpty ?? false)
              ? null
              : (categories ?? this.categories),
      createdById:
          (createdById?.isEmpty ?? false)
              ? null
              : (createdById ?? this.createdById),
      customerId:
          (customerId?.isEmpty ?? false)
              ? null
              : (customerId ?? this.customerId),
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }
}
