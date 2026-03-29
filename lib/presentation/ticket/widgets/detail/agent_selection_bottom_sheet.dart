import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/agent/agent.dart';

void showAgentSelectionBottomSheet({
  required BuildContext context,
  required List<Agent> agents,
  required String? currentAgentId,
  required ValueChanged<String?> onAgentSelected,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => _AgentSelectionContent(
      agents: agents,
      currentAgentId: currentAgentId,
      onAgentSelected: (agentId) {
        onAgentSelected(agentId);
        Navigator.pop(context);
      },
    ),
  );
}

class _AgentSelectionContent extends StatelessWidget {
  final List<Agent> agents;
  final String? currentAgentId;
  final ValueChanged<String?> onAgentSelected;

  const _AgentSelectionContent({
    required this.agents,
    required this.currentAgentId,
    required this.onAgentSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.dividerColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Chọn nhân viên hỗ trợ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        // Unassign option
        if (currentAgentId != null)
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.inputBackground,
              child: Icon(Icons.person_off, color: AppColors.textTertiary),
            ),
            title: const Text('Hủy phân công'),
            subtitle: const Text('Bỏ phân công nhân viên hiện tại'),
            onTap: () => onAgentSelected(null),
          ),
        const Divider(height: 1),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: agents.length,
            itemBuilder: (context, index) {
              final agent = agents[index];
              final isSelected = agent.id == currentAgentId;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isSelected
                      ? AppColors.primaryBlue
                      : AppColors.inputBackground,
                  child: Text(
                    agent.name.isNotEmpty ? agent.name[0] : '?',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                title: Text(
                  agent.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                subtitle: Text(agent.department),
                trailing: isSelected
                    ? const Icon(Icons.check, color: AppColors.primaryBlue)
                    : null,
                onTap: () => onAgentSelected(agent.id),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
