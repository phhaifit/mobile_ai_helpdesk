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
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final bool hasMore;

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
    this.onLoadMore,
    this.isLoadingMore = false,
    this.hasMore = true,
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
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (onLoadMore == null || !hasMore || isLoadingMore) {
                        return false;
                      }

                      if (notification.metrics.axis != Axis.vertical) {
                        return false;
                      }

                      if (notification.metrics.pixels >=
                          notification.metrics.maxScrollExtent - 200) {
                        onLoadMore?.call();
                      }

                      return false;
                    },
                    child: ListView.builder(
                      itemCount: tickets.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= tickets.length) {
                          return _buildLoadingRow();
                        }

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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingRow() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
