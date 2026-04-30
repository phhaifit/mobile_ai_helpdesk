import '../../../domain/entity/customer/customer.dart';
import '../../../domain/entity/customer/tag.dart';
import '../../../domain/repository/customer/customer_repository.dart';
import '../../network/apis/customer/customer_api.dart';
import '../../network/apis/tag/tag_api.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerApi _api;
  final TagApi _tagApi;

  CustomerRepositoryImpl(this._api, this._tagApi);

  @override
  Future<List<Customer>> getCustomers({
    String? query,
    List<String>? tagIds,
    int limit = 20,
    int offset = 0,
  }) async {
    final dtos = await _api.getCustomers(
      search: query,
      limit: limit,
      offset: offset,
      tagIds: tagIds,
    );
    return dtos.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Customer?> getCustomerById(String id) async {
    final dto = await _api.getCustomerById(id);
    return dto?.toEntity();
  }

  @override
  Future<Customer> createCustomer(Customer customer) async {
    final email = customer.emails.isNotEmpty ? customer.emails.first : null;
    final phone = customer.phones.isNotEmpty ? customer.phones.first : null;
    final dto = await _api.createCustomer(
      name: customer.fullName,
      email: email,
      phone: phone,
    );
    return dto.toEntity();
  }

  @override
  Future<Customer> updateCustomer(Customer customer) async {
    final email = customer.emails.isNotEmpty ? customer.emails.first : null;
    final phone = customer.phones.isNotEmpty ? customer.phones.first : null;
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
    required String primaryCustomerId,
    required String secondaryCustomerId,
  }) async {
    await _api.mergeCustomers(
      primaryCustomerId: primaryCustomerId,
      secondaryCustomerId: secondaryCustomerId,
    );
    // Merge API doesn't return customer, re-fetch
    final dto = await _api.getCustomerById(primaryCustomerId);
    if (dto != null) return dto.toEntity();
    throw Exception('Merged customer not found');
  }

  @override
  Future<List<Tag>> getAvailableTags() async {
    final dtos = await _tagApi.getTags();
    return dtos.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Tag> createTag({required String name}) async {
    final dto = await _tagApi.createTag(name);
    return dto.toEntity();
  }

  @override
  Future<Tag> updateTag({required String id, required String name}) async {
    final dto = await _tagApi.updateTag(id, name);
    return dto.toEntity();
  }

  @override
  Future<void> deleteTag({required String id}) async {
    await _tagApi.deleteTag(id);
  }

  @override
  Future<Customer> addTagToCustomer(String customerId, String tagId) async {
    await _api.addCustomerTag(customerId, tagId);
    final dto = await _api.getCustomerById(customerId);
    if (dto == null) throw Exception('Customer not found after update');
    return dto.toEntity();
  }

  @override
  Future<Customer> removeTagFromCustomer(String customerId, String tagId) async {
    await _api.removeCustomerTag(customerId, tagId);
    final dto = await _api.getCustomerById(customerId);
    if (dto == null) throw Exception('Customer not found after update');
    return dto.toEntity();
  }

  @override
  Future<Customer> addCustomerContact(String customerId, {String? email, String? phone, String? zalo, String? messenger}) async {
    if (email != null && email.isNotEmpty) {
      await _api.addCustomerContact(customerId, 'email', email);
    }
    if (phone != null && phone.isNotEmpty) {
      await _api.addCustomerContact(customerId, 'phone', phone);
    }
    if (zalo != null && zalo.isNotEmpty) {
      await _api.addCustomerContact(customerId, 'zalo', zalo);
    }
    if (messenger != null && messenger.isNotEmpty) {
      await _api.addCustomerContact(customerId, 'messenger', messenger);
    }
    final dto = await _api.getCustomerById(customerId);
    if (dto == null) throw Exception('Customer not found');
    return dto.toEntity();
  }

  @override
  Future<Customer> deleteCustomerContact(String customerId, {String? email, String? phone, String? zalo, String? messenger}) async {
    if (email != null && email.isNotEmpty) {
      await _api.findAndDeleteContact('email', email);
    }
    if (phone != null && phone.isNotEmpty) {
      await _api.findAndDeleteContact('phone', phone);
    }
    if (zalo != null && zalo.isNotEmpty) {
      await _api.findAndDeleteContact('zalo', zalo);
    }
    if (messenger != null && messenger.isNotEmpty) {
      await _api.findAndDeleteContact('messenger', messenger);
    }
    final dto = await _api.getCustomerById(customerId);
    if (dto == null) throw Exception('Customer not found');
    return dto.toEntity();
  }

  @override
  Future<String?> getTenantName(String id) async {
    return _api.getTenantName(id);
  }
}
