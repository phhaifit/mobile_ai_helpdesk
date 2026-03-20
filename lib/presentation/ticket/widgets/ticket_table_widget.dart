import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import '../store/ticket_column_visibility_store.dart';
import 'ticket_table_header_widget.dart';
import 'ticket_table_row_widget.dart';
import 'ticket_column_selector_dialog.dart';

class TicketTableWidget extends StatelessWidget {
  final List<Ticket> tickets;
  final Function(Ticket)? onAcceptTicket;
  final Function(Ticket)? onViewDetails;
  final int selectedTabIndex;

  const TicketTableWidget({
    super.key,
    required this.tickets,
    this.onAcceptTicket,
    this.onViewDetails,
    this.selectedTabIndex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final columnVisibilityStore = GetIt.instance<TicketColumnVisibilityStore>();

    if (tickets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 80,
                color: AppColors.dividerColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'Không có phiếu nào',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Nhấn nút "Thêm phiếu" phía trên để tạo phiếu mới',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    // Desktop view: Full width
    if (!isMobile) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Table header with filter button
          Observer(
            builder: (_) {
              // Calculate if horizontal scroll is needed
              final visibleColumnCount = columnVisibilityStore.visibleColumns.length;
              final estimatedTableWidth = _calculateTableWidth(visibleColumnCount);
              final needsHorizontalScroll = columnVisibilityStore.visibleColumns.length > 4;

              if (needsHorizontalScroll) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: estimatedTableWidth,
                    child: TicketTableHeaderWidget(
                      visibleColumns: columnVisibilityStore.visibleColumns,
                      onFilterPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => TicketColumnSelectorDialog(
                            store: columnVisibilityStore,
                          ),
                        );
                      },
                    ),
                  ),
                );
              }

              return TicketTableHeaderWidget(
                visibleColumns: columnVisibilityStore.visibleColumns,
                onFilterPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => TicketColumnSelectorDialog(
                      store: columnVisibilityStore,
                    ),
                  );
                },
              );
            },
          ),
          // Table rows
          Expanded(
            child: Observer(
              builder: (_) {
                final visibleColumnCount = columnVisibilityStore.visibleColumns.length;
                final estimatedTableWidth = _calculateTableWidth(visibleColumnCount);
                final needsHorizontalScroll = columnVisibilityStore.visibleColumns.length > 4;

                if (needsHorizontalScroll) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: estimatedTableWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: tickets
                              .map((ticket) => TicketTableRowWidget(
                                    ticket: ticket,
                                    selectedTabIndex: selectedTabIndex,
                                    visibleColumns: columnVisibilityStore.visibleColumns,
                                    onAcceptPressed: () {
                                      onAcceptTicket?.call(ticket);
                                    },
                                    onDetailPressed: () {
                                      onViewDetails?.call(ticket);
                                    },
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: tickets
                        .map((ticket) => TicketTableRowWidget(
                              ticket: ticket,
                              selectedTabIndex: selectedTabIndex,
                              visibleColumns: columnVisibilityStore.visibleColumns,
                              onAcceptPressed: () {
                                onAcceptTicket?.call(ticket);
                              },
                              onDetailPressed: () {
                                onViewDetails?.call(ticket);
                              },
                            ))
                        .toList(),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    // Mobile view: Horizontal scroll when needed
    return Observer(
      builder: (_) {
        final estimatedTableWidth = _calculateTableWidth(columnVisibilityStore.visibleColumns.length);
        final tableWidth = estimatedTableWidth > screenWidth ? estimatedTableWidth : screenWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: tableWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Table header with filter button
                  TicketTableHeaderWidget(
                    visibleColumns: columnVisibilityStore.visibleColumns,
                    onFilterPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => TicketColumnSelectorDialog(
                          store: columnVisibilityStore,
                        ),
                      );
                    },
                  ),
                  // Table rows
                  ...tickets.map((ticket) => TicketTableRowWidget(
                        ticket: ticket,
                        selectedTabIndex: selectedTabIndex,
                        visibleColumns: columnVisibilityStore.visibleColumns,
                        onAcceptPressed: () {
                          onAcceptTicket?.call(ticket);
                        },
                        onDetailPressed: () {
                          onViewDetails?.call(ticket);
                        },
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double _calculateTableWidth(int visibleColumnCount) {
    // Base width = 150 per column (average)
    // This is an estimate to determine if horizontal scroll is needed
    const double baseColumnWidth = 180;
    return visibleColumnCount * baseColumnWidth;
  }
}
