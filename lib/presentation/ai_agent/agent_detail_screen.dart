import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/constants/dimens.dart';
import '/di/service_locator.dart';
import '/domain/entity/ai_agent/ai_agent.dart';
import '/presentation/ai_agent/store/ai_agent_store.dart';
import '/utils/locale/app_localization.dart';
import '/utils/routes/routes.dart';

class AgentDetailScreen extends StatefulWidget {
  final AiAgent agent;

  const AgentDetailScreen({super.key, required this.agent});

  @override
  State<AgentDetailScreen> createState() => _AgentDetailScreenState();
}

class _AgentDetailScreenState extends State<AgentDetailScreen> {
  late final AiAgentStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<AiAgentStore>();
  }

  Future<void> _confirmDelete() async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.translate('ai_agent_delete')),
        content: Text(l.translate('ai_agent_delete_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.translate('ai_agent_cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.translate('ai_agent_delete')),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await _store.deleteAgent(widget.agent.id);
      if (!mounted) return;
      if (_store.success) {
        Navigator.pop(context);
      } else if (_store.errorStore.errorMessage.isNotEmpty) {
        FlushbarHelper.createError(
          message: _store.errorStore.errorMessage,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.agent.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l.translate('ai_agent_edit'),
            onPressed: () => Navigator.pushNamed(
              context,
              Routes.agentEdit,
              arguments: widget.agent,
            ),
          ),
          Observer(
            builder: (_) => IconButton(
              icon: _store.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.delete_outline),
              tooltip: l.translate('ai_agent_delete'),
              onPressed: _store.isLoading ? null : _confirmDelete,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DetailRow(
              label: l.translate('ai_agent_name'),
              value: widget.agent.name,
            ),
            _DetailRow(
              label: l.translate('ai_agent_description'),
              value: widget.agent.description.isNotEmpty
                  ? widget.agent.description
                  : '-',
            ),
            _DetailRow(
              label: l.translate('ai_agent_mode'),
              value: l.translate(
                widget.agent.mode == AgentMode.auto
                    ? 'ai_agent_mode_auto'
                    : 'ai_agent_mode_semi_auto',
              ),
            ),
            if (widget.agent.platforms.isNotEmpty)
              _ChipsRow(
                label: l.translate('ai_agent_platforms'),
                items: widget.agent.platforms,
              ),
            if (widget.agent.workflows.isNotEmpty)
              _ChipsRow(
                label: l.translate('ai_agent_workflows'),
                items: widget.agent.workflows,
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.psychology_outlined),
              label: Text(l.translate('ai_agent_open_playground')),
              onPressed: () => Navigator.pushNamed(
                context,
                Routes.playground,
                arguments: widget.agent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.bodyMedium),
          const Divider(),
        ],
      ),
    );
  }
}

class _ChipsRow extends StatelessWidget {
  final String label;
  final List<String> items;

  const _ChipsRow({required this.label, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: items.map((i) => Chip(label: Text(i))).toList(),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
