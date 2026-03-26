import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/constants/dimens.dart';
import '/di/service_locator.dart';
import '/domain/entity/ai_agent/ai_agent.dart';
import '/presentation/ai_agent/store/ai_agent_store.dart';
import '/utils/locale/app_localization.dart';
import '/utils/routes/routes.dart';

class AgentListScreen extends StatefulWidget {
  const AgentListScreen({super.key});

  @override
  State<AgentListScreen> createState() => _AgentListScreenState();
}

class _AgentListScreenState extends State<AgentListScreen> {
  late final AiAgentStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<AiAgentStore>();
    _store.fetchAgents();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final content = Observer(builder: (_) {
      if (_store.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_store.errorStore.errorMessage.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _store.errorStore.errorMessage,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: _store.fetchAgents,
                child: Text(l.translate('common_try_again')),
              ),
            ],
          ),
        );
      }
      if (_store.agents.isEmpty) {
        return Center(child: Text(l.translate('ai_agent_no_agents')));
      }
      return ListView.separated(
        padding: const EdgeInsets.all(Dimens.horizontalPadding),
        itemCount: _store.agents.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) => _AgentCard(
          agent: _store.agents[i],
          onTap: () => Navigator.pushNamed(
            context,
            Routes.agentDetail,
            arguments: _store.agents[i],
          ),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('ai_agent_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_outlined),
            tooltip: l.translate('ai_agent_team_assistant_title'),
            onPressed: () => Navigator.pushNamed(context, Routes.teamAssistant),
          ),
        ],
      ),
      body: content,
      floatingActionButton: FloatingActionButton(
        tooltip: l.translate('ai_agent_create'),
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, Routes.agentCreate),
      ),
    );
  }
}

class _AgentCard extends StatelessWidget {
  final AiAgent agent;
  final VoidCallback onTap;

  const _AgentCard({required this.agent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      agent.name.isNotEmpty
                          ? agent.name[0].toUpperCase()
                          : '?',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agent.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (agent.description.isNotEmpty)
                          Text(
                            agent.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  _ModeBadge(mode: agent.mode),
                ],
              ),
              if (agent.platforms.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: agent.platforms
                      .map(
                        (p) => Chip(
                          label: Text(p),
                          labelStyle: theme.textTheme.labelSmall,
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeBadge extends StatelessWidget {
  final AgentMode mode;

  const _ModeBadge({required this.mode});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isAuto = mode == AgentMode.auto;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAuto ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        l.translate(
          isAuto ? 'ai_agent_mode_auto' : 'ai_agent_mode_semi_auto',
        ),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isAuto ? Colors.green.shade800 : Colors.orange.shade800,
        ),
      ),
    );
  }
}
