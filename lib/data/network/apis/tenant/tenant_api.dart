import '/core/data/network/dio/dio_client.dart';
import '/data/network/apis/api_response_parser.dart';
import '/data/network/constants/endpoints.dart';
import '/domain/entity/tenant/tenant.dart';
import '/domain/entity/tenant_settings/tenant_settings.dart';

class TenantApi {
  TenantApi(this._dioClient);

  final DioClient _dioClient;

  TenantSettings _parseTenantSettings(dynamic payload) {
    final data = ApiResponseParser.asMap(payload);
    final settings = data['settings'];
    if (settings is Map<String, dynamic>) {
      return TenantSettings.fromJson(settings);
    }
    return TenantSettings.fromJson(data);
  }

  Future<List<Tenant>> getTenants() async {
    final response = await _dioClient.dio.get(Endpoints.accountTenants());
    final payload = ApiResponseParser.asMap(response.data);
    final tenantsValue = payload['tenants'];
    final items = tenantsValue is List
        ? tenantsValue
            .whereType<Map<String, dynamic>>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(growable: false)
        : ApiResponseParser.asMapList(payload);
    return items.map(Tenant.fromJson).toList(growable: false);
  }

  Future<Tenant> getTenantById(String tenantId) async {
    final response = await _dioClient.dio.get(Endpoints.tenant(tenantId));
    return Tenant.fromJson(ApiResponseParser.asMap(response.data));
  }

  Future<void> switchTenant(String tenantId) async {
    await _dioClient.dio.post(
      Endpoints.switchTenant(tenantId),
      data: {'tenantId': tenantId},
    );
  }

  Future<Tenant> createTenant(Tenant tenant) async {
    final payload = <String, dynamic>{
      'name': tenant.name,
      'slug': tenant.slug,
      'settings': tenant.settings.toJson(),
    };
    final response = await _dioClient.dio.post(
      Endpoints.tenants(),
      data: payload,
    );
    return Tenant.fromJson(ApiResponseParser.asMap(response.data));
  }

  Future<Tenant> createTenantOnFirstLogin({
    required String name,
  }) async {
    final response = await _dioClient.dio.post(
      Endpoints.createTenantOnFirstLogin(),
      data: {'name': name},
    );
    return Tenant.fromJson(ApiResponseParser.asMap(response.data));
  }

  Future<void> getTenantJoinInfo() async {
    await _dioClient.dio.get(
      Endpoints.tenantInvitationJoinInfo(),
    );
  }

  Future<Tenant> updateTenant(Tenant tenant) async {
    final response = await _dioClient.dio.put(
      Endpoints.tenant(tenant.id),
      data: <String, dynamic>{
        'name': tenant.name,
      },
    );
    return Tenant.fromJson(ApiResponseParser.asMap(response.data));
  }

  Future<bool> deleteTenant(String tenantId) async {
    final response = await _dioClient.dio.delete(Endpoints.tenant(tenantId));
    return ApiResponseParser.asDeleteSuccess(response.data);
  }

  Future<TenantSettings> getTenantSettings(String tenantId) async {
    final response = await _dioClient.dio.get(Endpoints.tenantSettings(tenantId));
    return _parseTenantSettings(response.data);
  }

  Future<TenantSettings> updateTenantSettings({
    required String tenantId,
    required Map<String, dynamic> payload,
  }) async {
    final response = await _dioClient.dio.put(
      Endpoints.tenantAutoResolution(tenantId),
      data: payload,
    );
    return _parseTenantSettings(response.data);
  }
}
