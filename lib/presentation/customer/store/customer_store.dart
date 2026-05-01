import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:ai_helpdesk/domain/entity/customer/tag.dart';
import 'package:ai_helpdesk/domain/repository/customer/customer_repository.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'customer_store.g.dart';

class CustomerStore = _CustomerStore with _$CustomerStore;

abstract class _CustomerStore with Store {
  final CustomerRepository _repository;
  ReactionDisposer? _searchReaction;

  _CustomerStore(this._repository) {
    _init();
    _setupReactions();
  }

  void _setupReactions() {
    // Debounce search query changes by 500ms
    _searchReaction = reaction(
      (_) => searchQuery,
      (String query) {
        loadCustomers();
      },
      delay: 500,
    );
  }

  @observable
  bool isLoading = false;

  @observable
  bool isSaving = false;

  @observable
  String? errorMessage;

  @observable
  ObservableList<Customer> customers = ObservableList<Customer>();

  @observable
  ObservableList<Tag> availableTags = ObservableList<Tag>();

  @observable
  String searchQuery = '';

  @observable
  ObservableList<String> selectedTagIds = ObservableList<String>();

  @observable
  bool isLoadingMore = false;

  @observable
  bool hasReachedMax = false;

  int _currentPage = 0;
  final int _limit = 20;

  @action
  Future<void> _init() async {
    isLoading = true;
    errorMessage = null;
    try {
      final tags = await _repository.getAvailableTags();
      availableTags.clear();
      availableTags.addAll(tags);
      await loadCustomers();
    } catch (e) {
      errorMessage = 'Failed to initialize: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadCustomers({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (isLoadingMore || hasReachedMax) return;
      isLoadingMore = true;
    } else {
      isLoading = true;
      _currentPage = 0;
      hasReachedMax = false;
      customers.clear();
    }
    
    errorMessage = null;
    try {
      final result = await _repository.getCustomers(
        query: searchQuery,
        tagIds: selectedTagIds.isEmpty ? null : selectedTagIds.toList(),
        offset: _currentPage * _limit,
        limit: _limit,
      );

      if (result.isEmpty) {
        hasReachedMax = true;
      } else {
        if (result.length < _limit) {
          hasReachedMax = true;
        }
        customers.addAll(result);
        _currentPage++;
      }
    } on DioException catch (e) {
      errorMessage = _mapLoadError(e);
    } catch (_) {
      errorMessage = 'load_generic';
    } finally {
      if (isLoadMore) {
        isLoadingMore = false;
      } else {
        isLoading = false;
      }
    }
  }

  @action
  Future<Customer?> loadCustomerById(String id) async {
    try {
      final customer = await _repository.getCustomerById(id);
      if (customer != null && customer.tenantId != null) {
        final tenantName = await _repository.getTenantName(customer.tenantId!);
        return customer.copyWith(tenantName: tenantName);
      }
      return customer;
    } catch (e) {
      errorMessage = 'Failed to load customer details: $e';
      return null;
    }
  }

  @action
  // ignore: use_setters_to_change_properties
  void setSearchQuery(String query) {
    searchQuery = query;
  }

  void dispose() {
    _searchReaction?.call();
  }

  @action
  void toggleTagFilter(String tagId) {
    if (tagId.isEmpty) return;
    if (selectedTagIds.contains(tagId)) {
      selectedTagIds.remove(tagId);
    } else {
      selectedTagIds.add(tagId);
    }
  }

  @action
  void applyFilters() {
    loadCustomers();
  }

  @action
  void clearFilters() {
    selectedTagIds.clear();
    loadCustomers();
  }

  @action
  Future<bool> saveCustomer(Customer customer, {Customer? previous}) async {
    isSaving = true;
    errorMessage = null;
    try {
      final isUpdate = previous != null;
      if (isUpdate) {
        await _repository.updateCustomer(customer);
        await _syncCustomerTags(
          customerId: customer.id,
          oldTags: previous.tags,
          newTags: customer.tags,
        );
        await _syncCustomerContacts(
          customerId: customer.id,
          previous: previous,
          current: customer,
        );
      } else {
        if (customer.emails.isNotEmpty) {
          final isEmailAvailable = await _repository.checkEmailAvailability(customer.emails.first);
          if (!isEmailAvailable) {
            errorMessage = 'This email is already in use by another customer.';
            isSaving = false;
            return false;
          }
        }
        final created = await _repository.createCustomer(customer);
        await _syncCustomerTags(
          customerId: created.id,
          oldTags: const <Tag>[],
          newTags: customer.tags,
        );
        await _addExtraContactsForCreate(customerId: created.id, customer: customer);
      }
      await loadCustomers();
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        errorMessage = 'Subscription required. Please upgrade your plan to manage customers.';
      } else {
        errorMessage = e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to save customer';
      }
      return false;
    } catch (e) {
      errorMessage = 'Failed to save customer: $e';
      return false;
    } finally {
      isSaving = false;
    }
  }

  Future<void> _syncCustomerTags({
    required String customerId,
    required List<Tag> oldTags,
    required List<Tag> newTags,
  }) async {
    if (customerId.isEmpty) return;
    final oldIds = oldTags.map((t) => t.id).where((id) => id.isNotEmpty).toSet();
    final newIds = newTags.map((t) => t.id).where((id) => id.isNotEmpty).toSet();
    final toAdd = newIds.difference(oldIds);
    final toRemove = oldIds.difference(newIds);
    for (final id in toAdd) {
      await _repository.addTagToCustomer(customerId, id);
    }
    for (final id in toRemove) {
      await _repository.removeTagFromCustomer(customerId, id);
    }
  }

  Future<void> _syncCustomerContacts({
    required String customerId,
    required Customer previous,
    required Customer current,
  }) async {
    if (customerId.isEmpty) return;
    // Email/phone primary slot is handled by updateCustomer; only sync extras (index >= 1).
    await _diffAndSyncContacts(
      oldVals: _skipFirst(previous.emails),
      newVals: _skipFirst(current.emails),
      add: (v) => _repository.addCustomerContact(customerId, email: v),
      remove: (v) => _repository.deleteCustomerContact(customerId, email: v),
    );
    await _diffAndSyncContacts(
      oldVals: _skipFirst(previous.phones),
      newVals: _skipFirst(current.phones),
      add: (v) => _repository.addCustomerContact(customerId, phone: v),
      remove: (v) => _repository.deleteCustomerContact(customerId, phone: v),
    );
    // Zalo + messenger: no primary concept (updateCustomer doesn't accept them).
    await _diffAndSyncContacts(
      oldVals: previous.zalos,
      newVals: current.zalos,
      add: (v) => _repository.addCustomerContact(customerId, zalo: v),
      remove: (v) => _repository.deleteCustomerContact(customerId, zalo: v),
    );
    await _diffAndSyncContacts(
      oldVals: previous.messengers,
      newVals: current.messengers,
      add: (v) => _repository.addCustomerContact(customerId, messenger: v),
      remove: (v) => _repository.deleteCustomerContact(customerId, messenger: v),
    );
  }

  Future<void> _addExtraContactsForCreate({
    required String customerId,
    required Customer customer,
  }) async {
    if (customerId.isEmpty) return;
    // createCustomer only writes the primary email + primary phone; everything else is an extra contact.
    for (final v in _skipFirst(customer.emails)) {
      await _repository.addCustomerContact(customerId, email: v);
    }
    for (final v in _skipFirst(customer.phones)) {
      await _repository.addCustomerContact(customerId, phone: v);
    }
    for (final v in customer.zalos) {
      await _repository.addCustomerContact(customerId, zalo: v);
    }
    for (final v in customer.messengers) {
      await _repository.addCustomerContact(customerId, messenger: v);
    }
  }

  Future<void> _diffAndSyncContacts({
    required Iterable<String> oldVals,
    required Iterable<String> newVals,
    required Future<void> Function(String value) add,
    required Future<void> Function(String value) remove,
  }) async {
    final oldSet = oldVals.where((v) => v.isNotEmpty).toSet();
    final newSet = newVals.where((v) => v.isNotEmpty).toSet();
    for (final v in newSet.difference(oldSet)) {
      await add(v);
    }
    for (final v in oldSet.difference(newSet)) {
      await remove(v);
    }
  }

  Iterable<String> _skipFirst(List<String> list) =>
      list.length <= 1 ? const <String>[] : list.skip(1);

  String _mapLoadError(DioException e) {
    final code = e.response?.statusCode;
    final status = e.response?.data is Map
        ? (e.response?.data as Map)['status']?.toString()
        : null;
    if (code == 403 || status == 'SUBSCRIPTION_REQUIRED') return 'load_subscription';
    if (code == 401 || status == 'PERMISSION_DENIED') return 'load_permission';
    if (code == 404) return 'load_not_found';
    return 'load_generic';
  }

  String _mapTagError(DioException e, {required String action}) {
    final code = e.response?.statusCode;
    final status = e.response?.data is Map
        ? (e.response?.data as Map)['status']?.toString()
        : null;
    if (status == 'EXISTED') return 'A tag with this name already exists.';
    if (status == 'PERMISSION_DENIED' || code == 403) {
      return "You don't have permission to $action this tag.";
    }
    if (status == 'NOT_FOUND' || code == 404) return 'Tag not found.';
    if (status == 'INVALID_INPUT' || code == 400) return 'Invalid tag name.';
    return 'Failed to $action tag.';
  }

  @action
  Future<bool> deleteCustomer(String id) async {
    isLoading = true;
    try {
      await _repository.deleteCustomer(id);
      await loadCustomers();
      return true;
    } catch (e) {
      errorMessage = 'Failed to delete customer: $e';
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> mergeCustomers({required String primaryId, required String secondaryId}) async {
    isSaving = true;
    errorMessage = null;
    try {
      await _repository.mergeCustomers(
        primaryCustomerId: primaryId,
        secondaryCustomerId: secondaryId,
      );
      await loadCustomers();
      return true;
    } on DioException catch (e) {
      final status = e.response?.data is Map
          ? (e.response?.data as Map)['status']?.toString()
          : null;
      if (status == 'PERMISSION_DENIED' || e.response?.statusCode == 401) {
        errorMessage = 'permission_denied';
      } else if (e.response?.statusCode == 403) {
        errorMessage = 'subscription_required';
      } else {
        errorMessage = 'generic';
      }
      return false;
    } catch (_) {
      errorMessage = 'generic';
      return false;
    } finally {
      isSaving = false;
    }
  }

  @action
  Future<Tag?> createNewTag(String name) async {
    isSaving = true;
    try {
      final newTag = await _repository.createTag(name: name);
      availableTags.add(newTag);
      return newTag;
    } on DioException catch (e) {
      errorMessage = _mapTagError(e, action: 'create');
      return null;
    } catch (_) {
      errorMessage = 'Failed to create tag.';
      return null;
    } finally {
      isSaving = false;
    }
  }

  @action
  Future<bool> updateTag(String tagId, String name) async {
    isSaving = true;
    try {
      final updatedTag = await _repository.updateTag(id: tagId, name: name);
      final index = availableTags.indexWhere((t) => t.id == tagId);
      if (index != -1) {
        availableTags[index] = updatedTag;
      }
      return true;
    } on DioException catch (e) {
      errorMessage = _mapTagError(e, action: 'update');
      return false;
    } catch (_) {
      errorMessage = 'Failed to update tag.';
      return false;
    } finally {
      isSaving = false;
    }
  }

  @action
  Future<bool> deleteTag(String tagId) async {
    isSaving = true;
    try {
      await _repository.deleteTag(id: tagId);
      availableTags.removeWhere((t) => t.id == tagId);
      // Backend soft-deletes tags but keeps them on existing customer-tag links.
      // Strip the tag locally from cached customers so the UI does not show a ghost chip.
      for (var i = 0; i < customers.length; i++) {
        final c = customers[i];
        if (c.tags.any((t) => t.id == tagId)) {
          customers[i] = c.copyWith(
            tags: c.tags.where((t) => t.id != tagId).toList(),
          );
        }
      }
      // Also drop the tag from active filters so the list is not stuck filtering by a tag that no longer exists.
      if (selectedTagIds.remove(tagId)) {
        await loadCustomers();
      }
      return true;
    } on DioException catch (e) {
      errorMessage = _mapTagError(e, action: 'delete');
      return false;
    } catch (_) {
      errorMessage = 'Failed to delete tag.';
      return false;
    } finally {
      isSaving = false;
    }
  }

  @action
  Future<bool> addTagToCustomer(String customerId, String tagId) async {
    isSaving = true;
    try {
      await _repository.addTagToCustomer(customerId, tagId);
      await loadCustomers();
      return true;
    } on DioException catch (e) {
      errorMessage = _mapTagError(e, action: 'assign');
      return false;
    } catch (_) {
      errorMessage = 'Failed to assign tag.';
      return false;
    } finally {
      isSaving = false;
    }
  }

  @action
  Future<bool> removeTagFromCustomer(String customerId, String tagId) async {
    isSaving = true;
    try {
      await _repository.removeTagFromCustomer(customerId, tagId);
      await loadCustomers();
      return true;
    } on DioException catch (e) {
      errorMessage = _mapTagError(e, action: 'remove');
      return false;
    } catch (_) {
      errorMessage = 'Failed to remove tag.';
      return false;
    } finally {
      isSaving = false;
    }
  }

  @action
  Future<bool> updateCustomerContact(String customerId, {String? email, String? phone, String? zalo, String? messenger}) async {
    isSaving = true;
    try {
      await _repository.addCustomerContact(customerId, email: email, phone: phone, zalo: zalo, messenger: messenger);
      await loadCustomers();
      return true;
    } catch (e) {
      errorMessage = 'Failed to update contact: $e';
      return false;
    } finally {
      isSaving = false;
    }
  }

  @action
  Future<bool> removeCustomerContact(String customerId, {String? email, String? phone, String? zalo, String? messenger}) async {
    isSaving = true;
    try {
      await _repository.deleteCustomerContact(customerId, email: email, phone: phone, zalo: zalo, messenger: messenger);
      await loadCustomers();
      return true;
    } catch (e) {
      errorMessage = 'Failed to delete contact: $e';
      return false;
    } finally {
      isSaving = false;
    }
  }
}
