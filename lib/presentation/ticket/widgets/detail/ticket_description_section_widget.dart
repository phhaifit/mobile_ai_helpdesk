import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';

class TicketDescriptionSectionWidget extends StatelessWidget {
  final Ticket ticket;

  const TicketDescriptionSectionWidget({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mô tả',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              ticket.description.isNotEmpty ? ticket.description : 'Không có mô tả',
              style: TextStyle(
                fontSize: 14,
                color: ticket.description.isNotEmpty
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
                fontStyle: ticket.description.isEmpty ? FontStyle.italic : FontStyle.normal,
              ),
            ),
            if (ticket.attachments.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Tệp đính kèm',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...ticket.attachments.map(
                (file) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.attach_file, size: 16, color: AppColors.primaryBlue),
                      const SizedBox(width: 8),
                      Text(
                        file,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
