import '../../../../domain/entity/customer/customer.dart';

abstract class CustomerRepository {
  Future<List<Customer>> getCustomers();
  Future<void> addCustomer(Customer customer);
  Future<void> updateCustomer(Customer customer);
  Future<Customer?> mergeCustomers(String primaryId, String secondaryId);
}
