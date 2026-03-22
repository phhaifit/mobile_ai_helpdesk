// Widget tree (documentation):
// Scaffold
//   ├─ AppBar (title: new vs edit)
//   └─ Form
//        └─ SingleChildScrollView
//             └─ Column
//                  ├─ TextFormField (title)
//                  ├─ TextFormField (body, multiline)
//                  ├─ DropdownButtonFormField<String> (category)
//                  └─ FilledButton (save)
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';
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
      isPrivate: true,
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
    final categories =
        _store.categories.where((c) => c.id != 'all').toList();

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
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l.translate('prompt_tv_field_title'),
                border: const OutlineInputBorder(),
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
              decoration: InputDecoration(
                labelText: l.translate('prompt_tv_field_body'),
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              minLines: 4,
              maxLines: 10,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return l.translate('prompt_tv_validation_body');
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownMenu<String>(
              width: MediaQuery.sizeOf(context).width - 32,
              initialSelection: _categoryId,
              label: Text(l.translate('prompt_tv_field_category')),
              onSelected: (v) {
                if (v != null) {
                  setState(() => _categoryId = v);
                }
              },
              dropdownMenuEntries: [
                for (final c in categories)
                  DropdownMenuEntry<String>(
                    value: c.id,
                    label: l.translate(c.nameKey),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _onSave,
              child: Text(l.translate('prompt_btn_save')),
            ),
          ],
        ),
      ),
    );
  }
}
