import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/ai_agent/ai_agent.dart';
import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';
import 'package:ai_helpdesk/presentation/ai_agent/store/ai_agent_store.dart';
import 'package:ai_helpdesk/presentation/prompt/store/prompt_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PrivatePromptEditorScreen extends StatefulWidget {
  const PrivatePromptEditorScreen({super.key});

  @override
  State<PrivatePromptEditorScreen> createState() =>
      _PrivatePromptEditorScreenState();
}

class _PrivatePromptEditorScreenState extends State<PrivatePromptEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final PromptStore _store;
  late final AiAgentStore _agentStore;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _templateController;
  String? _selectedAssistantId;
  late bool _isActive;
  ResponseTemplate? _existing;
  bool _controllersReady = false;

  static const double _fieldRadius = 12;

  InputDecoration _fieldDecoration(
    BuildContext context, {
    required String label,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      labelText: label,
      filled: true,
      alignLabelWithHint: alignLabelWithHint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_fieldRadius),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  void initState() {
    super.initState();
    _store = getIt<PromptStore>();
    _agentStore = getIt<AiAgentStore>();
    if (_agentStore.agents.isEmpty && !_agentStore.isLoading) {
      _agentStore.fetchAgents();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controllersReady) {
      return;
    }
    _controllersReady = true;
    final arg = ModalRoute.of(context)?.settings.arguments;
    _existing = arg is ResponseTemplate ? arg : null;
    final existing = _existing;
    if (existing != null) {
      _nameController = TextEditingController(text: existing.name);
      _descriptionController =
          TextEditingController(text: existing.description);
      _templateController = TextEditingController(text: existing.template);
      _selectedAssistantId =
          existing.assistantId.isNotEmpty ? existing.assistantId : null;
      _isActive = existing.isActive;
    } else {
      _nameController = TextEditingController();
      _descriptionController = TextEditingController();
      _templateController = TextEditingController();
      _selectedAssistantId = null;
      _isActive = true;
    }
  }

  @override
  void dispose() {
    if (_controllersReady) {
      _nameController.dispose();
      _descriptionController.dispose();
      _templateController.dispose();
    }
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final existing = _existing;
    final String assistantId = _selectedAssistantId?.trim() ?? '';
    if (existing != null) {
      await _store.updateTemplate(
        existing.id,
        UpdateResponseTemplateDto(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          template: _templateController.text.trim(),
          isActive: _isActive,
          assistantId: assistantId,
        ),
      );
    } else {
      await _store.createTemplate(
        CreateResponseTemplateDto(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          template: _templateController.text.trim(),
          isActive: _isActive,
          assistantId: assistantId,
        ),
      );
    }
    if (!mounted) {
      return;
    }
    if (_store.errorMessage == null) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_store.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _existing == null
              ? l.translate('prompt_tv_editor_new_title')
              : l.translate('prompt_tv_editor_edit_title'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l.translate('prompt_tv_editor_subtitle'),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            // Name + Description + Template fields
            Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: _fieldDecoration(
                        context,
                        label: l.translate('prompt_tv_field_name'),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l.translate('prompt_tv_validation_name');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: _fieldDecoration(
                        context,
                        label: l.translate('prompt_tv_field_description'),
                      ),
                      textInputAction: TextInputAction.next,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _templateController,
                      decoration: _fieldDecoration(
                        context,
                        label: l.translate('prompt_tv_field_template'),
                        alignLabelWithHint: true,
                      ),
                      minLines: 5,
                      maxLines: 12,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l.translate('prompt_tv_validation_template');
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Assistant ID + Active toggle
            Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Observer(
                      builder: (_) {
                        final List<AiAgent> agents =
                            _agentStore.agents.toList(growable: false);
                        final bool currentInList =
                            _selectedAssistantId == null ||
                                agents.any(
                                  (a) => a.id == _selectedAssistantId,
                                );

                        final List<DropdownMenuItem<String>> items = <
                            DropdownMenuItem<String>>[
                          ...agents.map(
                            (AiAgent a) => DropdownMenuItem<String>(
                              value: a.id,
                              child: Text(
                                a.name.isNotEmpty ? a.name : a.id,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          if (!currentInList && _selectedAssistantId != null)
                            DropdownMenuItem<String>(
                              value: _selectedAssistantId,
                              child: Text(
                                '${_selectedAssistantId!} (unknown)',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ),
                        ];

                        return DropdownButtonFormField<String>(
                          // ignore: deprecated_member_use
                          value: _selectedAssistantId,
                          isExpanded: true,
                          decoration: _fieldDecoration(
                            context,
                            label: l.translate('prompt_tv_field_assistant'),
                          ),
                          items: items,
                          onChanged: (String? value) {
                            setState(() => _selectedAssistantId = value);
                          },
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return l.translate(
                                'prompt_tv_validation_assistant',
                              );
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    if (_agentStore.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: LinearProgressIndicator(minHeight: 2),
                      ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        l.translate('prompt_tv_field_active'),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        _isActive
                            ? l.translate('prompt_tv_active')
                            : l.translate('prompt_tv_inactive'),
                      ),
                      value: _isActive,
                      onChanged: (v) => setState(() => _isActive = v),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _onSave,
                icon: const Icon(Icons.save_outlined),
                label: Text(l.translate('prompt_btn_save')),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_fieldRadius),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
