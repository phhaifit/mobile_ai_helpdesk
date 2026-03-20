import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import '../store/ticket_column_visibility_store.dart';
import 'ticket_column_selector_dialog.dart';
import 'ticket_table_list_widget.dart';

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

    return Observer(
      builder: (_) {
        return TicketTableListWidget(
          tickets: tickets,
          visibleColumns: columnVisibilityStore.visibleColumns,
          selectedTabIndex: selectedTabIndex,
          onAcceptTicket: onAcceptTicket,
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
