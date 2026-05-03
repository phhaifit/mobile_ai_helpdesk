import 'package:ai_helpdesk/domain/entity/team_member/team_member.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tenant_settings.g.dart';

@JsonSerializable()
class TenantSettings {
  /// Whether members can invite others to the tenant.
  final bool allowInvitations;

  /// Default role assigned to newly accepted invites (unless overridden).
  final TeamRole defaultRole;

  /// If true, audit / verbose logging can be enabled server-side.
  final bool enableAuditLog;

  /// Enables automatic ticket resolution after inactivity.
  @JsonKey(defaultValue: false)
  final bool autoResolutionEnabled;

  /// Auto-resolution timeout in hours.
  @JsonKey(defaultValue: 24)
  final int autoResolutionTimeoutHours;

  const TenantSettings({
    required this.allowInvitations,
    required this.defaultRole,
    required this.enableAuditLog,
    this.autoResolutionEnabled = false,
    this.autoResolutionTimeoutHours = 24,
  });

  factory TenantSettings.fromJson(Map<String, dynamic> json) =>
      _$TenantSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$TenantSettingsToJson(this);
}
