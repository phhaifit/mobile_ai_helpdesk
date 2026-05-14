import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entity/customer/customer.dart';
import '../../../domain/entity/customer/tag.dart';
import '../../../domain/repository/customer/customer_repository.dart';
import '../../local/datasources/customer/mock_customer_datasource.dart';
import '../../network/apis/customer/customer_api.dart';
import '../../network/apis/tag/tag_api.dart';

/// In debug builds, transient/missing-endpoint errors fall back to [MockCustomerDataSource]
/// so the UI flow stays exercisable while the backend is unavailable.
/// Auth/permission errors (401/403) intentionally still propagate so the upgrade flow
/// and login redirect behave realistically.
class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerApi _api;
  final TagApi _tagApi;
  final MockCustomerDataSource? _mock;

  CustomerRepositoryImpl(this._api, this._tagApi, [this._mock]);

  bool _shouldFallback(DioException e) {
    if (!kDebugMode || _mock == null) return false;
    final code = e.response?.statusCode;
    if (code == null) return true; // connection / timeout / unknown
    if (code == 404) return true; // endpoint missing
    if (code >= 500) return true; // backend crash
    return false; // 401/403/422/etc propagate
  }

  Future<T> _fallback<T>(
    String op,
    Future<T> Function() apiCall,
    Future<T> Function(MockCustomerDataSource mock) mockCall,
  ) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      if (_shouldFallback(e)) {
        if (kDebugMode) {
          // ignore: avoid_print
          print('[CustomerRepo] $op failed (${e.response?.statusCode ?? e.type.name}); using mock data.');
        }
        return await mockCall(_mock!);
      }
      rethrow;
    }
  }

  @override
  Future<List<Customer>> getCustomers({
    String? query,
    List<String>? tagIds,
    int limit = 20,
    int offset = 0,
  }) {
    return _fallback(
      'getCustomers',
      () async {
        final dtos = await _api.getCustomers(
          search: query,
          limit: limit,
          offset: offset,
          tagIds: tagIds,
        );
        return dtos.map((e) => e.toEntity()).toList();
      },
      (mock) => mock.getCustomers(
        query: query,
        tagIds: tagIds,
        limit: limit,
        offset: offset,
      ),
    );
  }

  @override
  Future<Customer?> getCustomerById(String id) {
    return _fallback(
      'getCustomerById',
      () async {
        final dto = await _api.getCustomerById(id);
        return dto?.toEntity();
      },
      (mock) => mock.getCustomerById(id),
    );
  }

  @override
  Future<Customer> createCustomer(Customer customer) {
    return _fallback(
      'createCustomer',
      () async {
        final email = customer.emails.isNotEmpty ? customer.emails.first : null;
        final phone = customer.phones.isNotEmpty ? customer.phones.first : null;
        final dto = await _api.createCustomer(
          name: customer.fullName,
          email: email,
          phone: phone,
        );
        return dto.toEntity();
      },
      (mock) => mock.createCustomer(customer),
    );
  }

  @override
  Future<Customer> updateCustomer(Customer customer) {
    return _fallback(
      'updateCustomer',
      () async {
        final email = customer.emails.isNotEmpty ? customer.emails.first : null;
        final phone = customer.phones.isNotEmpty ? customer.phones.first : null;
        final dto = await _api.updateCustomer(
          customer.id,
          name: customer.fullName,
          email: email,
          phone: phone,
        );
        return dto.toEntity();
      },
      (mock) => mock.updateCustomer(customer),
    );
  }

  @override
  Future<bool> checkEmailAvailability(String email) {
    return _fallback(
      'checkEmailAvailability',
      () => _api.checkEmailAvailability(email),
      (mock) => mock.checkEmailAvailability(email),
    );
  }

  @override
  Future<void> deleteCustomer(String id) async {
    return _fallback(
      'deleteCustomer',
      () async {
        // Currently no delete customer API documented in the ticket
        throw UnimplementedError('Delete customer API not provided');
      },
      (mock) => mock.deleteCustomer(id),
    );
  }

  @override
  Future<Customer> mergeCustomers({
    required String primaryCustomerId,
    required String secondaryCustomerId,
  }) {
    return _fallback(
      'mergeCustomers',
      () async {
        await _api.mergeCustomers(
          primaryCustomerId: primaryCustomerId,
          secondaryCustomerId: secondaryCustomerId,
        );
        // Merge API doesn't return customer, re-fetch
        final dto = await _api.getCustomerById(primaryCustomerId);
        if (dto != null) return dto.toEntity();
        throw Exception('Merged customer not found');
      },
      (mock) => mock.mergeCustomers(
        primaryCustomerId: primaryCustomerId,
        secondaryCustomerId: secondaryCustomerId,
      ),
    );
  }

  @override
  Future<List<Tag>> getAvailableTags() {
    return _fallback(
      'getAvailableTags',
      () async {
        final dtos = await _tagApi.getTags();
        return dtos.map((e) => e.toEntity()).toList();
      },
      (mock) => mock.getAvailableTags(),
    );
  }

  @override
  Future<Tag> createTag({required String name}) {
    return _fallback(
      'createTag',
      () async {
        final dto = await _tagApi.createTag(name);
        return dto.toEntity();
      },
      (mock) => mock.createTag(name: name),
    );
  }

  @override
  Future<Tag> updateTag({required String id, required String name}) {
    return _fallback(
      'updateTag',
      () async {
        final dto = await _tagApi.updateTag(id, name);
        return dto.toEntity();
      },
      (mock) => mock.updateTag(id: id, name: name),
    );
  }

  @override
  Future<void> deleteTag({required String id}) {
    return _fallback(
      'deleteTag',
      () => _tagApi.deleteTag(id),
      (mock) => mock.deleteTag(id: id),
    );
  }

  @override
  Future<Customer> addTagToCustomer(String customerId, String tagId) {
    return _fallback(
      'addTagToCustomer',
      () async {
        await _api.addCustomerTag(customerId, tagId);
        final dto = await _api.getCustomerById(customerId);
        if (dto == null) throw Exception('Customer not found after update');
        return dto.toEntity();
      },
      (mock) => mock.addTagToCustomer(customerId, tagId),
    );
  }

  @override
  Future<Customer> removeTagFromCustomer(String customerId, String tagId) {
    return _fallback(
      'removeTagFromCustomer',
      () async {
        await _api.removeCustomerTag(customerId, tagId);
        final dto = await _api.getCustomerById(customerId);
        if (dto == null) throw Exception('Customer not found after update');
        return dto.toEntity();
      },
      (mock) => mock.removeTagFromCustomer(customerId, tagId),
    );
  }

  @override
  Future<Customer> addCustomerContact(String customerId, {String? email, String? phone, String? zalo, String? messenger}) {
    return _fallback(
      'addCustomerContact',
      () async {
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
          // Messenger contacts are wire-typed as 'facebook' per backend enum.
          await _api.addCustomerContact(customerId, 'facebook', messenger);
        }
        final dto = await _api.getCustomerById(customerId);
        if (dto == null) throw Exception('Customer not found');
        return dto.toEntity();
      },
      (mock) => mock.addCustomerContact(
        customerId,
        email: email,
        phone: phone,
        zalo: zalo,
        messenger: messenger,
      ),
    );
  }

  @override
  Future<Customer> deleteCustomerContact(String customerId, {String? email, String? phone, String? zalo, String? messenger}) {
    return _fallback(
      'deleteCustomerContact',
      () async {
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
          await _api.findAndDeleteContact('facebook', messenger);
        }
        final dto = await _api.getCustomerById(customerId);
        if (dto == null) throw Exception('Customer not found');
        return dto.toEntity();
      },
      (mock) => mock.deleteCustomerContact(
        customerId,
        email: email,
        phone: phone,
        zalo: zalo,
        messenger: messenger,
      ),
    );
  }

  @override
  Future<String?> getTenantName(String id) {
    return _fallback(
      'getTenantName',
      () => _api.getTenantName(id),
      (mock) => mock.getTenantName(id),
    );
  }
}
