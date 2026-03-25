import '../enums.dart';

/// Filter state model for ticket queries
class TicketFilter {
  final List<TicketStatus>? statuses;
  final List<TicketPriority>? priorities;
  final List<TicketSource>? sources;
  final List<TicketCategory>? categories;
  final String? createdById;
  final String? customerId;
  final DateTime? fromDate;
  final DateTime? toDate;

  const TicketFilter({
    this.statuses,
    this.priorities,
    this.sources,
    this.categories,
    this.createdById,
    this.customerId,
    this.fromDate,
    this.toDate,
  });

  /// Create empty filter (no filtering applied)
  factory TicketFilter.empty() {
    return const TicketFilter();
  }

  /// Check if any filter is active
  bool get isEmpty {
    return statuses == null &&
        priorities == null &&
        sources == null &&
        categories == null &&
        createdById == null &&
        customerId == null &&
        fromDate == null &&
        toDate == null;
  }

  /// Count active filters
  int get activeFilterCount {
    int count = 0;
    if (statuses != null) count++;
    if (priorities != null) count++;
    if (sources != null) count++;
    if (categories != null) count++;
    if (createdById != null) count++;
    if (customerId != null) count++;
    if (fromDate != null || toDate != null) count++;
    return count;
  }

  /// Create a copy with some fields replaced
  TicketFilter copyWith({
    List<TicketStatus>? statuses,
    List<TicketPriority>? priorities,
    List<TicketSource>? sources,
    List<TicketCategory>? categories,
    String? createdById,
    String? customerId,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return TicketFilter(
      // If list is empty, set to null; if not provided, keep existing
      statuses: (statuses?.isEmpty ?? false) ? null : (statuses ?? this.statuses),
      priorities: (priorities?.isEmpty ?? false) ? null : (priorities ?? this.priorities),
      sources: (sources?.isEmpty ?? false) ? null : (sources ?? this.sources),
      categories: (categories?.isEmpty ?? false) ? null : (categories ?? this.categories),
      createdById: (createdById?.isEmpty ?? false) ? null : (createdById ?? this.createdById),
      customerId: (customerId?.isEmpty ?? false) ? null : (customerId ?? this.customerId),
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  String toString() => 'TicketFilter(statuses: $statuses, priorities: $priorities, sources: $sources, categories: $categories, createdById: $createdById, customerId: $customerId, fromDate: $fromDate, toDate: $toDate)';
}
