import '../../entity/customer/customer.dart';
import '../../entity/customer/tag.dart';

abstract class CustomerRepository {
  Future<List<Customer>> getCustomers({
    String? query,
    List<String>? tagIds,
    int limit = 20,
    int offset = 0,
  });

  Future<Customer?> getCustomerById(String id);

  Future<Customer> createCustomer(Customer customer);

  Future<Customer> updateCustomer(Customer customer);

  Future<bool> checkValidEmail(String email);

  Future<void> deleteCustomer(String id);

  Future<Customer> mergeCustomers({
    required String primaryCustomerId,
    required String secondaryCustomerId,
  });

  Future<List<Tag>> getAvailableTags();
  Future<Tag> createTag({required String name});

  // New methods based on requirements
  Future<Customer> addTagToCustomer(String customerId, String tagId);
  Future<Customer> removeTagFromCustomer(String customerId, String tagId);
  
  // Updates specific contact fields (if null, they are ignored; if provided, they overwrite)
  Future<Customer> addCustomerContact(String customerId, {String? email, String? phone, String? zalo, String? messenger});
  
  // Deletes specific contact fields by removing them from the list
  Future<Customer> deleteCustomerContact(String customerId, {String? email, String? phone, String? zalo, String? messenger});

  Future<String?> getTenantName(String id);
}
