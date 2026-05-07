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
    } catch (e) {
      errorMessage = 'Failed to load customers: $e';
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
  Future<bool> saveCustomer(Customer customer) async {
    isSaving = true;
    errorMessage = null;
    try {
      if (customers.any((c) => c.id == customer.id)) {
        await _repository.updateCustomer(customer);
      } else {
        if (customer.emails.isNotEmpty) {
          final isEmailValid = await _repository.checkValidEmail(customer.emails.first);
          if (!isEmailValid) {
            errorMessage = 'Email address is already in use or completely invalid.';
            isSaving = false;
            return false;
          }
        }
        await _repository.createCustomer(customer);
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
    try {
      await _repository.mergeCustomers(
        primaryCustomerId: primaryId,
        secondaryCustomerId: secondaryId,
      );
      await loadCustomers();
      return true;
    } catch (e) {
      errorMessage = 'Failed to merge customers: $e';
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
    } catch (e) {
      errorMessage = 'Failed to create tag: $e';
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
    } catch (e) {
      errorMessage = 'Failed to update tag: $e';
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
      return true;
    } catch (e) {
      errorMessage = 'Failed to delete tag: $e';
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
    } catch (e) {
      errorMessage = 'Failed to add tag: $e';
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
    } catch (e) {
      errorMessage = 'Failed to remove tag: $e';
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
