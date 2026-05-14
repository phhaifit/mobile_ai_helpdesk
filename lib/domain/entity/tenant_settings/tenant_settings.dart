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

  factory TenantSettings.fromJson(Map<String, dynamic> json) {
    final normalized = _normalize(json);
    return TenantSettings(
      allowInvitations: normalized['allowInvitations'] as bool? ?? true,
      defaultRole: _parseDefaultRole(normalized['defaultRole']),
      enableAuditLog: normalized['enableAuditLog'] as bool? ?? false,
      autoResolutionEnabled: _readAutoResolutionEnabled(normalized),
      autoResolutionTimeoutHours: _readAutoResolutionTimeoutHours(normalized),
    );
  }

  Map<String, dynamic> toJson() => _$TenantSettingsToJson(this);

  TenantSettings copyWith({
    bool? allowInvitations,
    TeamRole? defaultRole,
    bool? enableAuditLog,
    bool? autoResolutionEnabled,
    int? autoResolutionTimeoutHours,
  }) {
    return TenantSettings(
      allowInvitations: allowInvitations ?? this.allowInvitations,
      defaultRole: defaultRole ?? this.defaultRole,
      enableAuditLog: enableAuditLog ?? this.enableAuditLog,
      autoResolutionEnabled:
          autoResolutionEnabled ?? this.autoResolutionEnabled,
      autoResolutionTimeoutHours:
          autoResolutionTimeoutHours ?? this.autoResolutionTimeoutHours,
    );
  }

  static Map<String, dynamic> _normalize(Map<String, dynamic> json) {
    final data =
        json['data'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(json['data'] as Map<String, dynamic>)
            : Map<String, dynamic>.from(json);

    final settings = data['settings'];
    if (settings is Map<String, dynamic>) {
      return Map<String, dynamic>.from(settings);
    }
    return data;
  }

  static TeamRole _parseDefaultRole(dynamic value) {
    if (value is String) {
      for (final entry in _$TeamRoleEnumMap.entries) {
        if (entry.value == value) {
          return entry.key;
        }
      }
    }
    return TeamRole.customerSupport;
  }

  static bool _readAutoResolutionEnabled(Map<String, dynamic> json) {
    final explicit = json['autoResolutionEnabled'] ?? json['enabled'];
    if (explicit is bool) {
      return explicit;
    }

    final timeout = _tryReadAutoResolutionTimeoutHours(json);
    return timeout != null && timeout > 0;
  }

  static int _readAutoResolutionTimeoutHours(Map<String, dynamic> json) {
    final value =
        json['autoResolutionTimeoutHours'] ?? json['autoResolveAfterHours'];
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 24;
    }
    return 24;
  }

  static int? _tryReadAutoResolutionTimeoutHours(Map<String, dynamic> json) {
    if (!json.containsKey('autoResolutionTimeoutHours') &&
        !json.containsKey('autoResolveAfterHours')) {
      return null;
    }

    final value =
        json['autoResolutionTimeoutHours'] ?? json['autoResolveAfterHours'];
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}
