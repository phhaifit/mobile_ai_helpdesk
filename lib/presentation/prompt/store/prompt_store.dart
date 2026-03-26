import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';
import 'package:ai_helpdesk/domain/repository/prompt/prompt_repository.dart';
import 'package:mobx/mobx.dart';

part 'prompt_store.g.dart';

class PromptStore = _PromptStore with _$PromptStore;

abstract class _PromptStore with Store {
  final PromptRepository _repository;

  _PromptStore(this._repository);

  @observable
  ObservableList<Prompt> prompts = ObservableList<Prompt>();

  @observable
  String searchQuery = '';

  @observable
  String selectedCategoryId = 'all';

  @observable
  bool favoritesOnly = false;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  List<PromptCategory> get categories => _repository.categories;

  @computed
  List<Prompt> get filteredPrompts {
    Iterable<Prompt> list = prompts;
    if (favoritesOnly) {
      list = list.where((p) => p.isFavorite);
    }
    if (selectedCategoryId != 'all') {
      list = list.where((p) => p.categoryId == selectedCategoryId);
    }
    final q = searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where(
        (p) =>
            p.title.toLowerCase().contains(q) ||
            p.body.toLowerCase().contains(q),
      );
    }
    return list.toList();
  }

  @action
  Future<void> loadPrompts({bool useNetworkDelay = true}) async {
    errorMessage = null;
    isLoading = true;
    try {
      final list = await _repository.loadPrompts(useNetworkDelay: useNetworkDelay);
      prompts = ObservableList.of(list);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  void setSearchQuery(String value) {
    searchQuery = value;
  }

  @action
  void setCategoryFilter(String categoryId) {
    selectedCategoryId = categoryId;
  }

  @action
  void setFavoritesOnly(bool value) {
    favoritesOnly = value;
  }

  @action
  Future<void> toggleFavorite(String promptId) async {
    errorMessage = null;
    try {
      await _repository.toggleFavorite(promptId);
      await loadPrompts(useNetworkDelay: false);
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> upsertPrivatePrompt(Prompt prompt) async {
    errorMessage = null;
    try {
      await _repository.upsertPrivatePrompt(prompt);
      await loadPrompts(useNetworkDelay: false);
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> incrementUsage(String promptId) async {
    try {
      await _repository.incrementUsage(promptId);
      await loadPrompts(useNetworkDelay: false);
    } catch (_) {
      // Offline mock: ignore usage sync errors in UI
    }
  }

  /// Filters prompts for slash command picker (public + private, by title/body).
  List<Prompt> slashFiltered(String queryAfterSlash) {
    final q = queryAfterSlash.trim().toLowerCase();
    if (q.isEmpty) {
      return List<Prompt>.from(prompts);
    }
    return prompts
        .where(
          (p) =>
              p.title.toLowerCase().contains(q) ||
              p.body.toLowerCase().contains(q),
        )
        .toList();
  }
}
