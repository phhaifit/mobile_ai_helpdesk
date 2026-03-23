import 'package:mobile_ai_helpdesk/domain/entity/team_member/team_member.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invitation.g.dart';

enum InvitationStatus { pending, accepted, revoked, expired }

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
  });

  factory Invitation.fromJson(Map<String, dynamic> json) =>
      _$InvitationFromJson(json);

  Map<String, dynamic> toJson() => _$InvitationToJson(this);
}
