import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';

import '../store/ticket_column_visibility_store.dart';
import 'ticket_table_columns.dart';
import 'ticket_table_header_widget.dart';
import 'ticket_table_row_widget.dart';

class TicketTableListWidget extends StatelessWidget {
  final List<Ticket> tickets;
  final List<TicketColumn> visibleColumns;
  final int selectedTabIndex;
  final String currentAgentId;
  final Function(Ticket)? onAcceptTicket;
  final Function(Ticket)? onCancelTicket;
  final Function(Ticket)? onViewDetails;
  final VoidCallback? onFilterPressed;

  const TicketTableListWidget({
    super.key,
    required this.tickets,
    required this.visibleColumns,
    required this.selectedTabIndex,
    required this.currentAgentId,
    this.onAcceptTicket,
    this.onCancelTicket,
    this.onViewDetails,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final estimatedWidth = TicketTableColumns.estimateTableWidth(
          visibleColumns,
        );
        final viewportWidth = constraints.maxWidth;
        final tableWidth = math.max(viewportWidth, estimatedWidth);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
            child: Column(
              children: [
                TicketTableHeaderWidget(
                  visibleColumns: visibleColumns,
                  onFilterPressed: onFilterPressed,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];
                      return TicketTableRowWidget(
                        ticket: ticket,
                        selectedTabIndex: selectedTabIndex,
                        currentAgentId: currentAgentId,
                        visibleColumns: visibleColumns,
                        onAcceptPressed: () => onAcceptTicket?.call(ticket),
                        onCancelPressed: () => onCancelTicket?.call(ticket),
                        onDetailPressed: () => onViewDetails?.call(ticket),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}