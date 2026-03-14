import 'package:mobx/mobx.dart';
import '../../../domain/entity/customer/customer.dart';
import '../../../domain/repository/customer_management/customer_repository.dart';

part 'customer_store.g.dart';

class CustomerStore = _CustomerStore with _$CustomerStore;

abstract class _CustomerStore with Store {
  final CustomerRepository _customerRepository;

  _CustomerStore(this._customerRepository);

  @observable
  ObservableList<Customer> customers = ObservableList<Customer>();

  @observable
  bool isLoading = false;

  @observable
  String searchQuery = '';

  @observable
  ObservableList<String> selectedTagFilters = ObservableList<String>();

  @observable
  ObservableList<String> systemTags = ObservableList<String>();

  @computed
  List<Customer> get filteredCustomers {
    return customers.where((c) {
      if (c.isBlocked) return false;
      final q = searchQuery.toLowerCase();
      final matchesSearch =
          q.isEmpty ||
          c.fullName.toLowerCase().contains(q) ||
          (c.email?.toLowerCase().contains(q) ?? false) ||
          (c.phoneNumber?.contains(q) ?? false);
      final matchesTags =
          selectedTagFilters.isEmpty ||
          selectedTagFilters.any((t) => c.tags.contains(t));
      return matchesSearch && matchesTags;
    }).toList();
  }

  @computed
  List<Customer> get blockedCustomers =>
      customers.where((c) => c.isBlocked).toList();

  @computed
  int get totalCount => customers.where((c) => !c.isBlocked).length;

  @computed
  List<String> get allAvailableTags {
    final tags = <String>{};
    // Add tags from customers
    for (final c in customers) {
      tags.addAll(c.tags);
    }
    // Add system-wide tags
    tags.addAll(systemTags);
    return tags.toList()..sort();
  }

  @action
  Future<void> fetchCustomers() async {
    isLoading = true;
    final list = await _customerRepository.getCustomers();
    customers
      ..clear()
      ..addAll(list);
    isLoading = false;
  }

  @action
  void setSearchQuery(String query) {
    searchQuery = query;
  }

  @action
  void toggleTagFilter(String tag) {
    if (selectedTagFilters.contains(tag)) {
      selectedTagFilters.remove(tag);
    } else {
      selectedTagFilters.add(tag);
    }
  }

  @action
  void clearTagFilters() {
    selectedTagFilters.clear();
  }

  @action
  Future<void> addCustomer(Customer customer) async {
    await _customerRepository.addCustomer(customer);
    customers.add(customer);
  }

  @action
  Future<void> updateCustomer(Customer customer) async {
    await _customerRepository.updateCustomer(customer);
    final index = customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) customers[index] = customer;
  }

  @action
  void blockCustomer(String id) {
    final index = customers.indexWhere((c) => c.id == id);
    if (index != -1) {
      customers[index] = customers[index].copyWith(isBlocked: true);
    }
  }

  @action
  void unblockCustomer(String id) {
    final index = customers.indexWhere((c) => c.id == id);
    if (index != -1) {
      customers[index] = customers[index].copyWith(isBlocked: false);
    }
  }

  @action
  Future<void> mergeCustomers(String primaryId, String secondaryId) async {
    final merged = await _customerRepository.mergeCustomers(
      primaryId,
      secondaryId,
    );
    if (merged != null) {
      customers.removeWhere((c) => c.id == secondaryId);
      final idx = customers.indexWhere((c) => c.id == primaryId);
      if (idx != -1) customers[idx] = merged;
    }
  }

  @action
  void addTag(String tag) {
    if (!systemTags.contains(tag) && tag.trim().isNotEmpty) {
      systemTags.add(tag.trim());
    }
  }
}
