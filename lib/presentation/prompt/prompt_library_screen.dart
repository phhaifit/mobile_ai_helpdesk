// Widget tree (documentation):
// embedInParent (home tab): Column
//   ├─ Padding(16) → header Row (headlineMedium + add + favorites) + ChoiceChips + search
//   └─ Expanded → RefreshIndicator → ListView (padding 8, cards like Tickets tab)
// standalone: Scaffold(AppBar + actions) + same body column without duplicate title.
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';
import 'package:ai_helpdesk/presentation/prompt/store/prompt_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PromptLibraryScreen extends StatefulWidget {
  const PromptLibraryScreen({super.key, this.embedInParent = false});

  /// When true (e.g. inside [HomeScreen] tabs), match other tabs: no nested [Scaffold]/[AppBar].
  final bool embedInParent;

  @override
  State<PromptLibraryScreen> createState() => _PromptLibraryScreenState();
}

class _PromptLibraryScreenState extends State<PromptLibraryScreen> {
  late final PromptStore _store;
  final TextEditingController _searchController = TextEditingController();

  static Color _categoryAccentColor(String categoryId) {
    switch (categoryId) {
      case 'support':
        return Colors.blue;
      case 'sales':
        return Colors.teal;
      case 'technical':
        return Colors.deepPurple;
      case 'general':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  void initState() {
    super.initState();
    _store = getIt<PromptStore>();
    _store.loadPrompts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openNewPrivatePrompt() {
    Navigator.pushNamed(context, Routes.promptEditor);
  }

  Widget _buildFavoritesToggle(AppLocalizations l) {
    return Observer(
      builder: (_) {
        final active = _store.favoritesOnly;
        return FilterChip(
          avatar: Icon(
            active ? Icons.star : Icons.star_border,
            size: 18,
            color: active ? null : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          label: Text(l.translate('prompt_tv_favorites_toggle')),
          selected: active,
          onSelected: (_) => _store.setFavoritesOnly(!active),
        );
      },
    );
  }

  Widget _buildCategoryChips(AppLocalizations l) {
    return Observer(
      builder: (_) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final c in _store.categories)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(l.translate(c.nameKey)),
                    selected: _store.selectedCategoryId == c.id,
                    onSelected: (selected) {
                      if (selected) {
                        _store.setCategoryFilter(c.id);
                      } else {
                        _store.setCategoryFilter('all');
                      }
                    },
                  ),
                ),
            ],
          ),
        );
      },
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  onPressed: _openNewPrivatePrompt,
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: l.translate('prompt_btn_new_private'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [_buildFavoritesToggle(l)],
            ),
            const SizedBox(height: 16),
          ] else ...[
            const SizedBox(height: 8),
          ],
          _buildCategoryChips(l),
          const SizedBox(height: 12),
          _buildSearchField(l),
        ],
      ),
    );
  }

  Widget _buildPromptList(AppLocalizations l) {
    return Observer(
      builder: (_) {
        if (_store.isLoading && _store.prompts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_store.errorMessage != null && _store.prompts.isEmpty) {
          return Center(child: Text(_store.errorMessage!));
        }
        final items = _store.filteredPrompts;
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
          onRefresh: () => _store.loadPrompts(),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final p = items[index];
              return _PromptListCard(
                prompt: p,
                accentColor: _categoryAccentColor(p.categoryId),
                onToggleFavorite: () => _store.toggleFavorite(p.id),
                onEdit: p.isPrivate
                    ? () {
                        Navigator.pushNamed(
                          context,
                          Routes.promptEditor,
                          arguments: p,
                        );
                      }
                    : null,
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
        Expanded(child: _buildPromptList(l)),
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
            onPressed: _openNewPrivatePrompt,
            icon: const Icon(Icons.add_circle_outline),
            tooltip: l.translate('prompt_btn_new_private'),
          ),
          Observer(
            builder: (_) {
              final active = _store.favoritesOnly;
              return IconButton(
                tooltip: l.translate('prompt_tv_favorites_toggle'),
                onPressed: () => _store.setFavoritesOnly(!active),
                icon: Icon(
                  active ? Icons.star : Icons.star_border,
                  color: active
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(l),
    );
  }
}

class _PromptListCard extends StatelessWidget {
  const _PromptListCard({
    required this.prompt,
    required this.accentColor,
    required this.onToggleFavorite,
    this.onEdit,
  });

  final Prompt prompt;
  final Color accentColor;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          radius: 6,
          backgroundColor: accentColor,
        ),
        title: Text(prompt.title),
        subtitle: Text(
          '${l.translate('prompt_tv_used_times').replaceFirst('%s', '${prompt.usageCount}')} · ${prompt.body}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                tooltip: l.translate('prompt_btn_edit'),
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 22),
                visualDensity: VisualDensity.compact,
              ),
            IconButton(
              tooltip: l.translate('prompt_tv_favorite'),
              onPressed: onToggleFavorite,
              icon: Icon(
                prompt.isFavorite ? Icons.star : Icons.star_border,
                size: 22,
                color: prompt.isFavorite ? scheme.primary : null,
              ),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
