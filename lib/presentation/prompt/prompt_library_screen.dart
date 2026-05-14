import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';
import 'package:ai_helpdesk/presentation/prompt/store/prompt_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PromptLibraryScreen extends StatefulWidget {
  const PromptLibraryScreen({super.key, this.embedInParent = false});

  final bool embedInParent;

  @override
  State<PromptLibraryScreen> createState() => _PromptLibraryScreenState();
}

class _PromptLibraryScreenState extends State<PromptLibraryScreen> {
  late final PromptStore _store;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<PromptStore>();
    _store.loadTemplates();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openNewTemplate() {
    Navigator.pushNamed(context, Routes.promptEditor).then((_) {
      _store.loadTemplates();
    });
  }

  void _confirmDelete(BuildContext context, ResponseTemplate template) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.translate('prompt_btn_delete')),
        content: Text(l.translate('prompt_tv_delete_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.translate('common_cancel')),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _store.deleteTemplate(template.id);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l.translate('prompt_btn_delete')),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(AppLocalizations l) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: l.translate('prompt_tv_search_hint'),
        prefixIcon: const Icon(Icons.search),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: _store.setSearchQuery,
    );
  }

  Widget _buildTopSection(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.embedInParent) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    l.translate('prompt_tv_library_title'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                IconButton(
                  onPressed: _openNewTemplate,
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: l.translate('prompt_btn_new_template'),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ] else ...[
            const SizedBox(height: 8),
          ],
          _buildSearchField(l),
        ],
      ),
    );
  }

  Widget _buildTemplateList(AppLocalizations l) {
    return Observer(
      builder: (_) {
        if (_store.isLoading && _store.templates.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_store.errorMessage != null && _store.templates.isEmpty) {
          return Center(child: Text(_store.errorMessage!));
        }
        final items = _store.filteredTemplates;
        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.library_books_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.translate('prompt_tv_empty'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => _store.loadTemplates(),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final t = items[index];
              return _TemplateListCard(
                template: t,
                onToggleActive: () => _store.toggleActive(t.id),
                onEdit: () {
                  Navigator.pushNamed(
                    context,
                    Routes.promptEditor,
                    arguments: t,
                  ).then((_) => _store.loadTemplates());
                },
                onDelete: () => _confirmDelete(context, t),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBody(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTopSection(l),
        Expanded(child: _buildTemplateList(l)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    if (widget.embedInParent) {
      return _buildBody(l);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('prompt_tv_library_title')),
        actions: [
          IconButton(
            onPressed: _openNewTemplate,
            icon: const Icon(Icons.add_circle_outline),
            tooltip: l.translate('prompt_btn_new_template'),
          ),
        ],
      ),
      body: _buildBody(l),
    );
  }
}

class _TemplateListCard extends StatelessWidget {
  const _TemplateListCard({
    required this.template,
    required this.onToggleActive,
    required this.onEdit,
    required this.onDelete,
  });

  final ResponseTemplate template;
  final VoidCallback onToggleActive;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Tooltip(
          message: template.isActive
              ? l.translate('prompt_tv_active')
              : l.translate('prompt_tv_inactive'),
          child: Icon(
            Icons.circle,
            size: 12,
            color: template.isActive ? Colors.green : scheme.outline,
          ),
        ),
        title: Text(template.name),
        subtitle: Text(
          template.description.isNotEmpty
              ? template.description
              : template.template,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: l.translate('prompt_btn_edit'),
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 22),
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              tooltip: template.isActive
                  ? l.translate('prompt_tv_deactivate')
                  : l.translate('prompt_tv_activate'),
              onPressed: onToggleActive,
              icon: Icon(
                template.isActive
                    ? Icons.toggle_on_outlined
                    : Icons.toggle_off_outlined,
                size: 26,
                color: template.isActive ? scheme.primary : scheme.outline,
              ),
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              tooltip: l.translate('prompt_btn_delete'),
              onPressed: onDelete,
              icon: Icon(
                Icons.delete_outline,
                size: 22,
                color: scheme.error,
              ),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
