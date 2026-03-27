
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';
import 'package:ai_helpdesk/presentation/prompt/prompt_selection_chips.dart';
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

  BorderSide _chipOutlineSide(BuildContext context) {
    return BorderSide(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35),
      width: 1,
    );
  }

  /// Favorites filter — row below title/+ and above category chips.
  Widget _buildFavoritesChip(AppLocalizations l) {
    return Observer(
      builder: (_) {
        final active = _store.favoritesOnly;
        return Align(
          alignment: Alignment.centerLeft,
          child: Tooltip(
            message: l.translate('prompt_tv_favorites_toggle'),
            child: FilterChip(
              showCheckmark: false,
              side: _chipOutlineSide(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              avatar: Icon(
                active ? Icons.star : Icons.star_border,
                size: 18,
                color: PromptSelectionChips.avatarIconColor(
                  context,
                  selected: active,
                ),
              ),
              label: Text(
                l.translate('prompt_tv_favorites_short'),
                style: PromptSelectionChips.labelTextStyle(
                  context,
                  selected: active,
                ),
              ),
              selected: active,
              color: PromptSelectionChips.background(context),
              onSelected: (_) => _store.setFavoritesOnly(!active),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCircularAddButton(AppLocalizations l) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: l.translate('prompt_btn_new_private'),
      child: Material(
        color: scheme.surfaceContainerHighest,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _openNewPrivatePrompt,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.add,
              size: 22,
              color: scheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  /// Category [ChoiceChip]s only (scrollable); outlined / light fill like reference chips.
  Widget _buildCategoryRowOnly(AppLocalizations l) {
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
                    showCheckmark: false,
                    side: _chipOutlineSide(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    label: Text(
                      l.translate(c.nameKey),
                      style: PromptSelectionChips.labelTextStyle(
                        context,
                        selected: _store.selectedCategoryId == c.id,
                      ),
                    ),
                    selected: _store.selectedCategoryId == c.id,
                    color: PromptSelectionChips.background(context),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  l.translate('prompt_tv_library_title'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              _buildCircularAddButton(l),
            ],
          ),
          const SizedBox(height: 12),
          _buildFavoritesChip(l),
          const SizedBox(height: 12),
          _buildCategoryRowOnly(l),
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
                onEdit: () {
                  Navigator.pushNamed(
                    context,
                    Routes.promptEditor,
                    arguments: p,
                  );
                },
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

    final canPop = Navigator.canPop(context);

    return Scaffold(
      appBar: canPop
          ? AppBar(
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.maybePop(context),
              ),
              automaticallyImplyLeading: false,
            )
          : null,
      body: SafeArea(
        top: !canPop,
        bottom: true,
        left: true,
        right: true,
        child: _buildBody(l),
      ),
    );
  }
}

class _PromptListCard extends StatelessWidget {
  const _PromptListCard({
    required this.prompt,
    required this.accentColor,
    required this.onToggleFavorite,
    required this.onEdit,
  });

  final Prompt prompt;
  final Color accentColor;
  final VoidCallback onToggleFavorite;
  final VoidCallback onEdit;

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
            IconButton(
              tooltip: l.translate('prompt_btn_edit'),
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 22),
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              tooltip: l.translate('Favorites only'),
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
