// Widget tree (documentation):
// Prompt library layout; primary structure:
// Scaffold
//   ├─ AppBar (when embedInParent is false: title, favorites; bottom TabBar)
//   └─ body: Column
//        ├─ (when embedInParent: title Row + favorites)
//        ├─ Padding → TextField (search)
//        ├─ TabBar (category filter tabs; scrollable) — in body when embedded
//        ├─ Expanded → RefreshIndicator → ListView
//        │     └─ Card → ListTile (title, subtitle usage, favorite, edit if private)
//        └─ (loading / error states via early returns in Observer)
//
// FloatingActionButton → navigates to PrivatePromptEditorScreen (create).
import 'package:ai_helpdesk/constants/dimens.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';
import 'package:ai_helpdesk/presentation/prompt/store/prompt_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PromptLibraryScreen extends StatefulWidget {
  const PromptLibraryScreen({super.key, this.embedInParent = false});

  /// When true (e.g. inside [HomeScreen] tabs), omit own [AppBar] to avoid a double bar.
  final bool embedInParent;

  @override
  State<PromptLibraryScreen> createState() => _PromptLibraryScreenState();
}

class _PromptLibraryScreenState extends State<PromptLibraryScreen>
    with SingleTickerProviderStateMixin {
  late final PromptStore _store;
  late final TabController _categoryTabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<PromptStore>();
    final n = _store.categories.length;
    _categoryTabController = TabController(length: n, vsync: this);
    _categoryTabController.addListener(_onCategoryTabChanged);
    _store.loadPrompts();
  }

  void _onCategoryTabChanged() {
    if (_categoryTabController.indexIsChanging) {
      return;
    }
    final i = _categoryTabController.index;
    if (i >= 0 && i < _store.categories.length) {
      _store.setCategoryFilter(_store.categories[i].id);
    }
  }

  @override
  void dispose() {
    _categoryTabController.removeListener(_onCategoryTabChanged);
    _categoryTabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildFavoritesButton(AppLocalizations l) {
    return Observer(
      builder: (_) {
        return IconButton(
          tooltip: l.translate('prompt_tv_favorites_toggle'),
          onPressed: () {
            _store.setFavoritesOnly(!_store.favoritesOnly);
          },
          icon: Icon(
            _store.favoritesOnly ? Icons.star : Icons.star_border,
            color: _store.favoritesOnly
                ? Theme.of(context).colorScheme.primary
                : null,
          ),
        );
      },
    );
  }

  Widget _buildCategoryTabBar(AppLocalizations l) {
    return TabBar(
      controller: _categoryTabController,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      tabs: [
        for (final c in _store.categories) Tab(text: l.translate(c.nameKey)),
      ],
    );
  }

  Widget _buildBody(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.embedInParent) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimens.horizontalPadding,
              8,
              Dimens.horizontalPadding,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l.translate('prompt_tv_library_title'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _buildFavoritesButton(l),
              ],
            ),
          ),
          _buildCategoryTabBar(l),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Dimens.horizontalPadding,
            12,
            Dimens.horizontalPadding,
            8,
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l.translate('prompt_tv_search_hint'),
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: _store.setSearchQuery,
          ),
        ),
        Expanded(
          child: Observer(
            builder: (_) {
              if (_store.isLoading && _store.prompts.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_store.errorMessage != null && _store.prompts.isEmpty) {
                return Center(child: Text(_store.errorMessage!));
              }
              final items = _store.filteredPrompts;
              if (items.isEmpty) {
                return Center(child: Text(l.translate('prompt_tv_empty')));
              }
              return RefreshIndicator(
                onRefresh: () => _store.loadPrompts(),
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                    left: Dimens.horizontalPadding,
                    right: Dimens.horizontalPadding,
                    bottom: 88,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final p = items[index];
                    return _PromptListCard(
                      prompt: p,
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
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    if (widget.embedInParent) {
      return Scaffold(
        body: _buildBody(l),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, Routes.promptEditor);
          },
          icon: const Icon(Icons.add),
          label: Text(l.translate('prompt_btn_new_private')),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('prompt_tv_library_title')),
        actions: [_buildFavoritesButton(l)],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _buildCategoryTabBar(l),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, Routes.promptEditor);
        },
        icon: const Icon(Icons.add),
        label: Text(l.translate('prompt_btn_new_private')),
      ),
      body: _buildBody(l),
    );
  }
}

class _PromptListCard extends StatelessWidget {
  const _PromptListCard({
    required this.prompt,
    required this.onToggleFavorite,
    this.onEdit,
  });

  final Prompt prompt;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(prompt.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.translate('prompt_tv_used_times').replaceFirst(
                    '%s',
                    '${prompt.usageCount}',
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              prompt.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        leading: Icon(
          prompt.isPrivate ? Icons.lock_outline : Icons.public_outlined,
          color: scheme.primary,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                tooltip: l.translate('prompt_btn_edit'),
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
            IconButton(
              tooltip: l.translate('prompt_tv_favorite'),
              onPressed: onToggleFavorite,
              icon: Icon(
                prompt.isFavorite ? Icons.star : Icons.star_border,
                color: prompt.isFavorite ? scheme.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
