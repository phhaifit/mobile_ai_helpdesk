import 'package:mobile_ai_helpdesk/data/local/datasources/customer_management/customer_datasource.dart';
import '../../../../domain/entity/customer/customer.dart';
import '../../../../domain/repository/customer_management/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerDataSource _customerDataSource;

  CustomerRepositoryImpl(this._customerDataSource);

  @override
  Future<List<Customer>> getCustomers() async {
    return await _customerDataSource.getMockCustomers();
  }

  @override
  Future<void> addCustomer(Customer customer) async {
    await _customerDataSource.addCustomer(customer);
  }

  @override
  Future<void> updateCustomer(Customer customer) async {
    await _customerDataSource.updateCustomer(customer);
  }

  @override
  Future<Customer?> mergeCustomers(String primaryId, String secondaryId) async {
    return await _customerDataSource.mergeCustomers(primaryId, secondaryId);
  }
}
