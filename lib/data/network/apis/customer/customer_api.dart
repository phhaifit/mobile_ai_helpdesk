import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/data/network/dto/customer/customer_dto.dart';
import 'package:dio/dio.dart';

class CustomerApi {
  final DioClient _dioClient;

  CustomerApi(this._dioClient);

  Future<List<CustomerDto>> getCustomers({
    int limit = 20,
    int offset = 0,
    String? search,
    List<String>? tagIds,
  }) async {
    final response = await _dioClient.dio.get(
      Endpoints.customerList(),
      queryParameters: {
        'limit': limit,
        'offset': offset,
        if (search != null && search.isNotEmpty) 'search': search,
        if (tagIds != null && tagIds.isNotEmpty) 'tagIDs': tagIds,
      },
    );

    final data = response.data;
    if (data == null || data['data'] == null) {
      return [];
    }
    
    final list = data['data'] as List;
    return list.map((e) => CustomerDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CustomerDto?> getCustomerById(String id) async {
    final response = await _dioClient.dio.get(Endpoints.customerDetail(id));
    final data = response.data;
    if (data == null || data['data'] == null) {
      return null;
    }
    
    final list = data['data'] as List;
    if (list.isEmpty) return null;
    return CustomerDto.fromJson(list.first as Map<String, dynamic>);
  }

  Future<bool> checkValidEmail(String email) async {
    try {
      final response = await _dioClient.dio.get(
        Endpoints.checkValidEmail(),
        queryParameters: {'email': email},
      );
      return response.data['status'] == 'OK' || response.data['status'] == 'NOT_FOUND';
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 || e.response?.data?['status'] == 'NOT_FOUND') {
        return true; 
      }
      return false;
    }
  }

  Future<CustomerDto> createCustomer({
    required String name,
    String? email,
    String? phone,
  }) async {
    final response = await _dioClient.dio.post(
      Endpoints.createCustomer(),
      data: {
        'name': name,
        if (email != null && email.isNotEmpty) 'email': email,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      },
    );
    return CustomerDto.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<CustomerDto> updateCustomer(
    String id, {
    String? name,
    String? email,
    String? phone,
  }) async {
    final response = await _dioClient.dio.put(
      Endpoints.updateCustomer(id),
      data: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
      },
    );
    return CustomerDto.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> addCustomerTag(String customerId, String tagId) async {
    await _dioClient.dio.post(
      Endpoints.addCustomerTag(customerId),
      data: {'tagId': tagId},
    );
  }

  Future<void> removeCustomerTag(String customerId, String tagId) async {
    await _dioClient.dio.delete(Endpoints.removeCustomerTag(customerId, tagId));
  }

  Future<void> mergeCustomers({
    required String primaryCustomerId,
    required String secondaryCustomerId,
  }) async {
    await _dioClient.dio.post(
      Endpoints.mergeCustomers(),
      data: {
        'primaryCustomerId': primaryCustomerId,
        'secondaryCustomerId': secondaryCustomerId,
      },
    );
  }

  Future<void> addCustomerContact(String customerId, String type, String value) async {
    await _dioClient.dio.post(
      Endpoints.addCustomerContact(customerId),
      data: {
        'type': type,
        'value': value,
      },
    );
  }

  Future<void> deleteCustomerContact(String customerId, String contactId) async {
    await _dioClient.dio.post(
      Endpoints.deleteCustomerContact(),
      data: {
        'customerId': customerId,
        'contactId': contactId,
      },
    );
  }

  Future<void> findAndDeleteContact(String type, String value) async {
    await _dioClient.dio.post(
      Endpoints.findAndDeleteContact(),
      data: {
        'type': type,
        'value': value,
      },
    );
  }

  Future<String?> getTenantName(String id) async {
    try {
      final response = await _dioClient.dio.get(Endpoints.tenant(id));
      return response.data['data']?['name'] as String?;
    } catch (e) {
      return null;
    }
  }
}
