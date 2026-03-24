import 'package:flutter/material.dart';

import '../store/ticket_column_visibility_store.dart';

class TicketTableColumns {
  static const List<TicketColumn> columnOrder = [
    TicketColumn.title,
    TicketColumn.statusPriority,
    TicketColumn.customer,
    TicketColumn.source,
    TicketColumn.createdBy,
    TicketColumn.csAgent,
    TicketColumn.createdDate,
    TicketColumn.updatedDate,
    TicketColumn.actions,
  ];

  static const Map<TicketColumn, TableColumnWidth> _columnWidths = {
    TicketColumn.title: FlexColumnWidth(2),
    TicketColumn.statusPriority: FlexColumnWidth(1.5),
    TicketColumn.customer: FlexColumnWidth(1.5),
    TicketColumn.source: FlexColumnWidth(1),
    TicketColumn.createdBy: FlexColumnWidth(1),
    TicketColumn.csAgent: FlexColumnWidth(1),
    TicketColumn.createdDate: FlexColumnWidth(1),
    TicketColumn.updatedDate: FlexColumnWidth(1),
    TicketColumn.actions: FlexColumnWidth(1.2),
  };

  static const Map<TicketColumn, double> _estimatedPixelWidths = {
    TicketColumn.title: 260,
    TicketColumn.statusPriority: 220,
    TicketColumn.customer: 220,
    TicketColumn.source: 180,
    TicketColumn.createdBy: 180,
    TicketColumn.csAgent: 180,
    TicketColumn.createdDate: 180,
    TicketColumn.updatedDate: 180,
    TicketColumn.actions: 200,
  };

  static Map<int, TableColumnWidth> buildTableWidths(
    List<TicketColumn> visibleColumns,
  ) {
    final filteredWidths = <int, TableColumnWidth>{};
    var tableIndex = 0;

    for (final column in columnOrder) {
      if (visibleColumns.contains(column)) {
        filteredWidths[tableIndex] = _columnWidths[column]!;
        tableIndex++;
      }
    }

    return filteredWidths;
  }

  static double estimateTableWidth(List<TicketColumn> visibleColumns) {
    var total = 0.0;
    for (final column in visibleColumns) {
      total += _estimatedPixelWidths[column] ?? 180;
    }
    return total;
  }
}