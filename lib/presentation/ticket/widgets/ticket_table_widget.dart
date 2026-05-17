import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../store/ticket_column_visibility_store.dart';
import 'ticket_card_widget.dart';
import 'ticket_column_selector_dialog.dart';
import 'ticket_table_list_widget.dart';

class TicketTableWidget extends StatelessWidget {
  final List<Ticket> tickets;
  final Function(Ticket)? onAcceptTicket;
  final Function(Ticket)? onCancelTicket;
  final Function(Ticket)? onViewDetails;
  final int selectedTabIndex;
  final String currentAgentId;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final bool hasMore;

  const TicketTableWidget({
    required this.tickets, required this.currentAgentId, super.key,
    this.onAcceptTicket,
    this.onCancelTicket,
    this.onViewDetails,
    this.selectedTabIndex = 1,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (tickets.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: AppColors.dividerColor,
              ),
              SizedBox(height: 16),
              Text(
                'Không có phiếu nào',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Nhấn nút "Thêm phiếu" phía trên để tạo phiếu mới',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    if (isMobile) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return TicketCardWidget(
            ticket: ticket,
            onTap: () => onViewDetails?.call(ticket),
          );
        },
      );
    }

    final columnVisibilityStore = GetIt.instance<TicketColumnVisibilityStore>();
    return Observer(
      builder: (_) {
        return TicketTableListWidget(
          tickets: tickets,
          visibleColumns: columnVisibilityStore.visibleColumns,
          selectedTabIndex: selectedTabIndex,
          currentAgentId: currentAgentId,
          onAcceptTicket: onAcceptTicket,
          onCancelTicket: onCancelTicket,
          onViewDetails: onViewDetails,
          onLoadMore: onLoadMore,
          isLoadingMore: isLoadingMore,
          hasMore: hasMore,
          onFilterPressed: () {
            showDialog(
              context: context,
              builder:
                  (context) =>
                      TicketColumnSelectorDialog(store: columnVisibilityStore),
            );
          },
        );
      },
    );
  }
}
