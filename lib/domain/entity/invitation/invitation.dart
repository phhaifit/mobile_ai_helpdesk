import 'package:ai_helpdesk/domain/entity/team_member/team_member.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invitation.g.dart';

enum InvitationStatus { pending, accepted, revoked, expired, declined, expired_declined }

@JsonSerializable()
class Invitation {
  final String id;
  final String tenantId;
  final String email;
  final TeamRole role;
  final InvitationStatus status;
  final String invitedByMemberId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? acceptedAt;
  final List<String>? channelIds;

  const Invitation({
    required this.id,
    required this.tenantId,
    required this.email,
    required this.role,
    required this.status,
    required this.invitedByMemberId,
    required this.createdAt,
    required this.expiresAt,
    this.acceptedAt,
    this.channelIds,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) {
    final raw = json['data'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['data'] as Map<String, dynamic>)
        : json;

    return Invitation(
      id: _readString(raw, const ['id', 'invitationID']) ?? '',
      tenantId: _readString(raw, const ['tenantId', 'tenantID']) ?? '',
      email: _readString(raw, const ['email']) ?? '',
      role: _parseTeamRole(_readString(raw, const ['role'])),
      status: _parseInvitationStatus(_readString(raw, const ['status'])),
      invitedByMemberId: _readString(raw, const ['invitedByMemberId']) ?? '',
      createdAt: _parseDateTime(raw['createdAt']) ?? DateTime.now(),
      expiresAt: _parseDateTime(raw['expiresAt']) ?? DateTime.now(),
      acceptedAt: _parseDateTime(raw['acceptedAt']),
      channelIds: _readStringList(raw, const ['channelIds', 'channelIDs']),
    );
  }

  Map<String, dynamic> toJson() => _$InvitationToJson(this);

  static String? _readString(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  static List<String>? _readStringList(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value is List) {
        return value.cast<String>();
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

  static TeamRole _parseTeamRole(String? roleString) {
    if (roleString == null) return TeamRole.member;
    try {
      return TeamRole.values.firstWhere(
        (role) => role.name.toUpperCase() == roleString.toUpperCase(),
        orElse: () => TeamRole.member,
      );
    } catch (_) {
      return TeamRole.member;
    }
  }

  static InvitationStatus _parseInvitationStatus(String? statusString) {
    if (statusString == null) return InvitationStatus.pending;
    final normalized = statusString.toLowerCase();
    try {
      return InvitationStatus.values.firstWhere(
        (status) => status.name == normalized,
        orElse: () => InvitationStatus.pending,
      );
    } catch (_) {
      return InvitationStatus.pending;
    }
  }
}
