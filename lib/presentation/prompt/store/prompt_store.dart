import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';
import 'package:ai_helpdesk/domain/repository/prompt/prompt_repository.dart';
import 'package:mobx/mobx.dart';

part 'prompt_store.g.dart';

class PromptStore = _PromptStore with _$PromptStore;

abstract class _PromptStore with Store {
  final PromptRepository _repository;

  _PromptStore(this._repository);

  @observable
  ObservableList<ResponseTemplate> templates = ObservableList<ResponseTemplate>();

  @observable
  String searchQuery = '';

  @observable
  String? filterAssistantId;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @computed
  List<ResponseTemplate> get filteredTemplates {
    Iterable<ResponseTemplate> list = templates;
    if (filterAssistantId != null && filterAssistantId!.isNotEmpty) {
      list = list.where((t) => t.assistantId == filterAssistantId);
    }
    final q = searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where(
        (t) =>
            t.name.toLowerCase().contains(q) ||
            t.description.toLowerCase().contains(q) ||
            t.template.toLowerCase().contains(q),
      );
    }
    return list.toList();
  }

  @action
  Future<void> loadTemplates({String? assistantId}) async {
    errorMessage = null;
    isLoading = true;
    try {
      final list = await _repository.getTemplates(assistantId: assistantId);
      templates = ObservableList.of(list);
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
  void setFilterAssistantId(String? assistantId) {
    filterAssistantId = assistantId;
  }

  @action
  Future<void> createTemplate(CreateResponseTemplateDto dto) async {
    errorMessage = null;
    try {
      await _repository.createTemplate(dto);
      await loadTemplates();
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> updateTemplate(
    String templateId,
    UpdateResponseTemplateDto dto,
  ) async {
    errorMessage = null;
    try {
      await _repository.updateTemplate(templateId, dto);
      await loadTemplates();
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> deleteTemplate(String templateId) async {
    errorMessage = null;
    try {
      await _repository.deleteTemplate(templateId);
      await loadTemplates();
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> toggleActive(String templateId) async {
    errorMessage = null;
    try {
      await _repository.toggleActive(templateId);
      await loadTemplates();
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  /// Filters templates for slash command picker (by name/template content).
  List<ResponseTemplate> slashFiltered(String queryAfterSlash) {
    // Only show active templates in slash picker
    final active = templates.where((t) => t.isActive);
    final q = queryAfterSlash.trim().toLowerCase();
    if (q.isEmpty) {
      return active.toList();
    }
    return active
        .where(
          (t) =>
              t.name.toLowerCase().contains(q) ||
              t.template.toLowerCase().contains(q),
        )
        .toList();
  }
}
