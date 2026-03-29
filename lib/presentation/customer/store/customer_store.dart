import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:ai_helpdesk/domain/entity/customer/tag.dart';
import 'package:ai_helpdesk/domain/repository/customer/customer_repository.dart';
import 'package:mobx/mobx.dart';

part 'customer_store.g.dart';

class CustomerStore = _CustomerStore with _$CustomerStore;

abstract class _CustomerStore with Store {
  final CustomerRepository _repository;

  _CustomerStore(this._repository) {
    _init();
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
  Future<void> loadCustomers() async {
    isLoading = true;
    errorMessage = null;
    try {
      final result = await _repository.getCustomers(
        query: searchQuery,
        tagIds: selectedTagIds.isEmpty ? null : selectedTagIds.toList(),
      );
      customers.clear();
      customers.addAll(result);
    } catch (e) {
      errorMessage = 'Failed to load customers: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  void setSearchQuery(String query) {
    searchQuery = query;
    loadCustomers();
  }

  @action
  void toggleTagFilter(String tagId) {
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
        await _repository.createCustomer(customer);
      }
      await loadCustomers();
      return true;
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
  Future<bool> mergeCustomers({required String targetId, required String sourceId}) async {
    isSaving = true;
    try {
      await _repository.mergeCustomers(
        targetCustomerId: targetId,
        sourceCustomerId: sourceId,
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
