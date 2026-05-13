import 'package:ai_helpdesk/domain/entity/team_member/team_member.dart';
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

  factory Tenant.fromJson(Map<String, dynamic> json) {
    final raw =
        json['data'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(json['data'] as Map<String, dynamic>)
            : json;

    final settingsJson = raw['settings'];
    final settings =
        settingsJson is Map<String, dynamic>
            ? TenantSettings.fromJson(Map<String, dynamic>.from(settingsJson))
            : const TenantSettings(
              allowInvitations: true,
              defaultRole: TeamRole.customerSupport,
              enableAuditLog: false,
            );

    final createdAt = _parseDateTime(raw['createdAt']) ?? DateTime.now();

    return Tenant(
      id: _readString(raw, const ['id', 'tenantID', 'tenantId']) ?? '',
      name: _readString(raw, const ['name', 'tenantName']) ?? '',
      slug: _readString(raw, const ['slug']),
      settings: settings,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => _$TenantToJson(this);

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
