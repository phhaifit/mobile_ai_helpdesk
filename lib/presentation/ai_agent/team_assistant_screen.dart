import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/constants/dimens.dart';
import '/di/service_locator.dart';
import '/presentation/ai_agent/store/ai_agent_store.dart';
import '/utils/locale/app_localization.dart';

class TeamAssistantScreen extends StatefulWidget {
  const TeamAssistantScreen({super.key});

  @override
  State<TeamAssistantScreen> createState() => _TeamAssistantScreenState();
}

class _TeamAssistantScreenState extends State<TeamAssistantScreen> {
  late final AiAgentStore _store;
  String? _selectedAgentId;

  @override
  void initState() {
    super.initState();
    _store = getIt<AiAgentStore>();
    if (_store.agents.isEmpty) _store.fetchAgents();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('ai_agent_team_assistant_title')),
      ),
      body: Observer(builder: (_) {
        if (_store.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimens.horizontalPadding),
              child: Text(
                l.translate('ai_agent_team_assistant_info'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _store.agents.isEmpty
                  ? Center(
                      child: Text(l.translate('ai_agent_no_agents')),
                    )
                  : ListView.builder(
                      itemCount: _store.agents.length,
                      itemBuilder: (_, i) {
                        final agent = _store.agents[i];
                        return RadioListTile<String>(
                          value: agent.id,
                          groupValue: _selectedAgentId,
                          onChanged: (id) =>
                              setState(() => _selectedAgentId = id),
                          title: Text(agent.name),
                          subtitle: agent.description.isNotEmpty
                              ? Text(
                                  agent.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : null,
                          secondary: CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            child: Text(
                              agent.name.isNotEmpty
                                  ? agent.name[0].toUpperCase()
                                  : '?',
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (_selectedAgentId != null)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.horizontalPadding),
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check),
                    label: Text(l.translate('ai_agent_save')),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
