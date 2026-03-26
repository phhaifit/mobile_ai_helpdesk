// Screen file map — PrivatePromptEditorScreen (folders and files that define this screen)
// lib/
// ├── presentation/
// │   └── prompt/
// │       ├── private_prompt_editor_screen.dart   # this file
// │       ├── prompt_selection_chips.dart         # category ChoiceChips styling
// │       └── store/
// │           ├── prompt_store.dart               # upsertPrivatePrompt
// │           └── prompt_store.g.dart
// ├── domain/
// │   ├── entity/prompt/prompt.dart
// │   └── repository/prompt/prompt_repository.dart
// ├── data/
// │   └── repository/prompt/mock_prompt_repository_impl.dart
// ├── utils/
// │   ├── routes/routes.dart                     # Routes.promptEditor, ModalRoute arguments: Prompt
// │   └── locale/app_localization.dart
// └── assets/lang/
//     ├── en.json
//     └── vi.json
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';
import 'package:ai_helpdesk/presentation/prompt/prompt_selection_chips.dart';
import 'package:ai_helpdesk/presentation/prompt/store/prompt_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';

class PrivatePromptEditorScreen extends StatefulWidget {
  const PrivatePromptEditorScreen({super.key});

  @override
  State<PrivatePromptEditorScreen> createState() =>
      _PrivatePromptEditorScreenState();
}

class _PrivatePromptEditorScreenState extends State<PrivatePromptEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final PromptStore _store;
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late String _categoryId;
  Prompt? _existing;
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controllersReady) {
      return;
    }
    _controllersReady = true;
    final arg = ModalRoute.of(context)?.settings.arguments;
    _existing = arg is Prompt ? arg : null;
    final existing = _existing;
    if (existing != null) {
      _titleController = TextEditingController(text: existing.title);
      _bodyController = TextEditingController(text: existing.body);
      _categoryId = existing.categoryId;
    } else {
      _titleController = TextEditingController();
      _bodyController = TextEditingController();
      _categoryId = _store.categories
          .firstWhere((c) => c.id != 'all', orElse: () => _store.categories.first)
          .id;
    }
  }

  @override
  void dispose() {
    if (_controllersReady) {
      _titleController.dispose();
      _bodyController.dispose();
    }
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final existing = _existing;
    final prompt = Prompt(
      id: existing?.id ?? '',
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      categoryId: _categoryId,
      isFavorite: existing?.isFavorite ?? false,
      usageCount: existing?.usageCount ?? 0,
      isPrivate: existing?.isPrivate ?? true,
    );
    await _store.upsertPrivatePrompt(prompt);
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
    final categories =
        _store.categories.where((c) => c.id != 'all').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _existing == null
              ? l.translate('prompt_tv_editor_new_title')
              : (_existing!.isPrivate
                  ? l.translate('prompt_tv_editor_edit_title')
                  : l.translate('prompt_tv_editor_edit_any')),
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
            Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: _fieldDecoration(
                        context,
                        label: l.translate('prompt_tv_field_title'),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l.translate('prompt_tv_validation_title');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bodyController,
                      decoration: _fieldDecoration(
                        context,
                        label: l.translate('prompt_tv_field_body'),
                        alignLabelWithHint: true,
                      ),
                      minLines: 5,
                      maxLines: 12,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l.translate('prompt_tv_validation_body');
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.translate('prompt_tv_field_category'),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final c in categories)
                          ChoiceChip(
                            label: Text(
                              l.translate(c.nameKey),
                              style: PromptSelectionChips.labelTextStyle(
                                context,
                                selected: _categoryId == c.id,
                              ),
                            ),
                            selected: _categoryId == c.id,
                            color: PromptSelectionChips.background(context),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _categoryId = c.id);
                              }
                            },
                          ),
                      ],
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
