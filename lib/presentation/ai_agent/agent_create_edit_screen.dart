import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/constants/dimens.dart';
import '/di/service_locator.dart';
import '/domain/entity/ai_agent/ai_agent.dart';
import '/presentation/ai_agent/store/ai_agent_store.dart';
import '/utils/locale/app_localization.dart';

class AgentCreateEditScreen extends StatefulWidget {
  /// Null = create mode. Non-null = edit mode.
  final AiAgent? agent;

  const AgentCreateEditScreen({super.key, this.agent});

  @override
  State<AgentCreateEditScreen> createState() => _AgentCreateEditScreenState();
}

class _AgentCreateEditScreenState extends State<AgentCreateEditScreen> {
  late final AiAgentStore _store;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _workflowsCtrl;
  AgentMode _mode = AgentMode.auto;
  final Set<String> _platforms = {};

  static const _allPlatforms = ['Messenger', 'Telegram', 'Slack', 'Zalo'];

  bool get _isEditing => widget.agent != null;

  @override
  void initState() {
    super.initState();
    _store = getIt<AiAgentStore>();
    final a = widget.agent;
    _nameCtrl = TextEditingController(text: a?.name ?? '');
    _descCtrl = TextEditingController(text: a?.description ?? '');
    _workflowsCtrl = TextEditingController(
      text: a?.workflows.join(', ') ?? '',
    );
    if (a != null) {
      _mode = a.mode;
      _platforms.addAll(a.platforms);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _workflowsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      FlushbarHelper.createError(
        message: l.translate('ai_agent_name'),
      ).show(context);
      return;
    }

    final workflows = _workflowsCtrl.text
        .split(',')
        .map((w) => w.trim())
        .where((w) => w.isNotEmpty)
        .toList();

    final agent = AiAgent(
      id: widget.agent?.id ?? '',
      name: name,
      description: _descCtrl.text.trim(),
      avatarUrl: widget.agent?.avatarUrl,
      mode: _mode,
      platforms: _platforms.toList(),
      workflows: workflows,
      teamId: widget.agent?.teamId ?? 'team-001',
      createdAt: widget.agent?.createdAt ?? DateTime.now(),
    );

    if (_isEditing) {
      await _store.updateAgent(agent);
    } else {
      await _store.createAgent(agent);
    }

    if (!mounted) return;
    if (_store.success) {
      Navigator.pop(context);
    } else if (_store.errorStore.errorMessage.isNotEmpty) {
      FlushbarHelper.createError(
        message: _store.errorStore.errorMessage,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing
              ? l.translate('ai_agent_edit')
              : l.translate('ai_agent_create'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: l.translate('ai_agent_name'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l.translate('ai_agent_description'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l.translate('ai_agent_mode'),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            SegmentedButton<AgentMode>(
              segments: [
                ButtonSegment(
                  value: AgentMode.auto,
                  label: Text(l.translate('ai_agent_mode_auto')),
                  icon: const Icon(Icons.auto_mode),
                ),
                ButtonSegment(
                  value: AgentMode.semiAuto,
                  label: Text(l.translate('ai_agent_mode_semi_auto')),
                  icon: const Icon(Icons.tune),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (v) => setState(() => _mode = v.first),
            ),
            const SizedBox(height: 16),
            Text(
              l.translate('ai_agent_platforms'),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _allPlatforms
                  .map(
                    (p) => FilterChip(
                      label: Text(p),
                      selected: _platforms.contains(p),
                      onSelected: (selected) => setState(() {
                        selected ? _platforms.add(p) : _platforms.remove(p);
                      }),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _workflowsCtrl,
              decoration: InputDecoration(
                labelText: l.translate('ai_agent_workflows'),
                hintText: 'e.g. Order Tracking, Returns, FAQ',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Observer(
              builder: (_) => FilledButton(
                onPressed: _store.isLoading ? null : _save,
                child: _store.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l.translate('ai_agent_save')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
