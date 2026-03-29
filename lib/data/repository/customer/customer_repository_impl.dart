import '../../../domain/entity/customer/customer.dart';
import '../../../domain/entity/customer/tag.dart';
import '../../../domain/repository/customer/customer_repository.dart';
import '../../local/datasources/customer/mock_customer_datasource.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final MockCustomerDataSource _dataSource;

  CustomerRepositoryImpl(this._dataSource);

  @override
  Future<List<Customer>> getCustomers({
    String? query,
    List<String>? tagIds,
  }) {
    return _dataSource.getCustomers(
      query: query,
      tagIds: tagIds,
    );
  }

  @override
  Future<Customer?> getCustomerById(String id) {
    return _dataSource.getCustomerById(id);
  }

  @override
  Future<Customer> createCustomer(Customer customer) {
    return _dataSource.createCustomer(customer);
  }

  @override
  Future<Customer> updateCustomer(Customer customer) {
    return _dataSource.updateCustomer(customer);
  }

  @override
  Future<void> deleteCustomer(String id) {
    return _dataSource.deleteCustomer(id);
  }

  @override
  Future<Customer> mergeCustomers({
    required String targetCustomerId,
    required String sourceCustomerId,
  }) {
    return _dataSource.mergeCustomers(
      targetCustomerId: targetCustomerId,
      sourceCustomerId: sourceCustomerId,
    );
  }

  @override
  Future<List<Tag>> getAvailableTags() {
    return _dataSource.getAvailableTags();
  }

  @override
  Future<Tag> createTag({required String name, required String colorHex}) {
    return _dataSource.createTag(name: name, colorHex: colorHex);
  }

  @override
  Future<Customer> addTagToCustomer(String customerId, String tagId) {
    return _dataSource.addTagToCustomer(customerId, tagId);
  }

  @override
  Future<Customer> removeTagFromCustomer(String customerId, String tagId) {
    return _dataSource.removeTagFromCustomer(customerId, tagId);
  }

  @override
  Future<Customer> addCustomerContact(String customerId, {String? email, String? phone, String? zalo, String? messenger}) {
    return _dataSource.addCustomerContact(customerId, email: email, phone: phone, zalo: zalo, messenger: messenger);
  }

  @override
  Future<Customer> deleteCustomerContact(String customerId, {String? email, String? phone, String? zalo, String? messenger}) {
    return _dataSource.deleteCustomerContact(customerId, email: email, phone: phone, zalo: zalo, messenger: messenger);
  }
}
