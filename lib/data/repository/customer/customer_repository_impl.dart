import '../../../domain/entity/customer/customer.dart';
import '../../../domain/entity/customer/tag.dart';
import '../../../domain/repository/customer/customer_repository.dart';
import '../../network/apis/customer/customer_api.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerApi _api;

  CustomerRepositoryImpl(this._api);

  @override
  Future<List<Customer>> getCustomers({
    String? query,
    List<String>? tagIds,
    int limit = 20,
    int offset = 0,
  }) async {
    final dtos = await _api.getCustomers(search: query, limit: limit, offset: offset);
    return dtos.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Customer?> getCustomerById(String id) async {
    final dto = await _api.getCustomerById(id);
    return dto?.toEntity();
  }

  @override
  Future<Customer> createCustomer(Customer customer) async {
    // Note: The API validation endpoint should be called in UseCase/Store
    // We only have the first email and phone right now
    final email = customer.emails.isNotEmpty ? customer.emails.first : '';
    final phone = customer.phones.isNotEmpty ? customer.phones.first : '';
    final dto = await _api.createCustomer(
      name: customer.fullName,
      email: email,
      phone: phone,
    );
    return dto.toEntity();
  }

  @override
  Future<Customer> updateCustomer(Customer customer) async {
    final email = customer.emails.isNotEmpty ? customer.emails.first : '';
    final phone = customer.phones.isNotEmpty ? customer.phones.first : '';
    final dto = await _api.updateCustomer(
      customer.id,
      name: customer.fullName,
      email: email,
      phone: phone,
    );
    return dto.toEntity();
  }

  @override
  Future<bool> checkValidEmail(String email) async {
    return _api.checkValidEmail(email);
  }

  @override
  Future<void> deleteCustomer(String id) async {
    // Currently no delete customer API documented in the ticket
    throw UnimplementedError('Delete customer API not provided');
  }

  @override
  Future<Customer> mergeCustomers({
    required String targetCustomerId,
    required String sourceCustomerId,
  }) async {
    await _api.mergeCustomers(targetCustomerId, sourceCustomerId);
    // Merge API doesn't return customer, re-fetch
    final dto = await _api.getCustomerById(targetCustomerId);
    if (dto != null) return dto.toEntity();
    throw Exception('Merged customer not found');
  }

  @override
  Future<List<Tag>> getAvailableTags() async {
    // Backend API for getting available tags not provided, return a mock list for UI testing
    return [
      const Tag(id: 'tag_vip', name: 'VIP'),
      const Tag(id: 'tag_new', name: 'New'),
      const Tag(id: 'tag_lead', name: 'Lead'),
    ];
  }

  @override
  Future<Tag> createTag({required String name}) async {
    // Tag API not fully described, using mock for now to not break the UI flow
    return Tag(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name);
  }

  @override
  Future<Customer> addTagToCustomer(String customerId, String tagId) async {
    await _api.addCustomerTag(customerId, tagId);
    final dto = await _api.getCustomerById(customerId);
    return dto!.toEntity();
  }

  @override
  Future<Customer> removeTagFromCustomer(String customerId, String tagId) async {
    await _api.removeCustomerTag(customerId, tagId);
    final dto = await _api.getCustomerById(customerId);
    return dto!.toEntity();
  }

  @override
  Future<Customer> addCustomerContact(String customerId, {String? email, String? phone, String? zalo, String? messenger}) async {
    if (email != null && email.isNotEmpty) {
      await _api.addCustomerContact(customerId, 'email', email);
    }
    if (phone != null && phone.isNotEmpty) {
      await _api.addCustomerContact(customerId, 'phone', phone);
    }
    final dto = await _api.getCustomerById(customerId);
    return dto!.toEntity();
  }

  @override
  Future<Customer> deleteCustomerContact(String customerId, {String? email, String? phone, String? zalo, String? messenger}) async {
    // For delete, we need the contactId! The mock took value/type...
    // Let's use the findAndDeleteContact if available, or just throw for now.
    if (email != null && email.isNotEmpty) {
      await _api.findAndDeleteContact('email', email);
    }
    if (phone != null && phone.isNotEmpty) {
      await _api.findAndDeleteContact('phone', phone);
    }
    final dto = await _api.getCustomerById(customerId);
    return dto!.toEntity();
  }

  @override
  Future<String?> getTenantName(String id) async {
    return _api.getTenantName(id);
  }
}
