import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'ticket_table_header_widget.dart';
import 'ticket_table_row_widget.dart';

class TicketTableWidget extends StatelessWidget {
  final List<Ticket> tickets;
  final Function(Ticket)? onAcceptTicket;
  final Function(Ticket)? onViewDetails;

  const TicketTableWidget({
    super.key,
    required this.tickets,
    this.onAcceptTicket,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
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
          // Table header
          const TicketTableHeaderWidget(),
          // Table rows
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: tickets
                    .map((ticket) => TicketTableRowWidget(
                          ticket: ticket,
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
        ],
      );
    }

    // Mobile view: Horizontal scroll when needed
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: 800,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Table header
              const TicketTableHeaderWidget(),
              // Table rows
              ...tickets.map((ticket) => TicketTableRowWidget(
                    ticket: ticket,
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
  }
}
