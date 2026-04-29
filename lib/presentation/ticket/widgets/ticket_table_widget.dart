import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
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

  const TicketTableWidget({
    super.key,
    required this.tickets,
    this.onAcceptTicket,
    this.onCancelTicket,
    this.onViewDetails,
    this.selectedTabIndex = 1,
    required this.currentAgentId,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (tickets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined, size: 64, color: AppColors.dividerColor),
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
                'Nhấn "Thêm phiếu" để tạo phiếu mới',
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
    );
  }
}
