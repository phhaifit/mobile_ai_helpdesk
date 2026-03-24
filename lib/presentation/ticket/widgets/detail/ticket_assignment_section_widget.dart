import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_detail_store.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/detail/agent_selection_bottom_sheet.dart';

class TicketAssignmentSectionWidget extends StatelessWidget {
  final Ticket ticket;
  final TicketDetailStore store;

  const TicketAssignmentSectionWidget({
    super.key,
    required this.ticket,
    required this.store,
  });

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
              'Phân công & Trạng thái',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            // Assigned agent
            Row(
              children: [
                const Icon(Icons.person, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ticket.assignedAgentName ?? 'Chưa phân công',
                    style: TextStyle(
                      fontSize: 14,
                      color: ticket.assignedAgentId != null
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                      fontStyle: ticket.assignedAgentId == null
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => showAgentSelectionBottomSheet(
                    context: context,
                    agents: store.availableAgents,
                    currentAgentId: ticket.assignedAgentId,
                    onAgentSelected: (agentId) => store.assignAgent(agentId),
                  ),
                  icon: const Icon(Icons.swap_horiz, size: 18),
                  label: const Text('Phân công'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                  ),
                ),
                if (ticket.assignedAgentId != null)
                  TextButton(
                    onPressed: () => store.assignAgent(null),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.errorRed,
                    ),
                    child: const Text('Hủy'),
                  ),
              ],
            ),
            const Divider(height: 24),
            // Status dropdown
            Row(
              children: [
                const Icon(Icons.flag, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                const Text('Trạng thái:', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 12),
                DropdownButton<TicketStatus>(
                  value: ticket.status,
                  underline: const SizedBox(),
                  isDense: true,
                  items: TicketStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.getStatusColor(status),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(status.displayName, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (status) {
                    if (status != null) {
                      store.updateStatus(status);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
