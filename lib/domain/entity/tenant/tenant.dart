import 'package:ai_helpdesk/domain/entity/tenant_settings/tenant_settings.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tenant.g.dart';

@JsonSerializable()
class Tenant {
  final String id;
  final String name;
  final String? slug;
  final TenantSettings settings;
  final DateTime createdAt;

  const Tenant({
    required this.id,
    required this.name,
    required this.settings,
    required this.createdAt,
    this.slug,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);

  Map<String, dynamic> toJson() => _$TenantToJson(this);
}

