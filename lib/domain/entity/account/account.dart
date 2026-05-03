import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

/// Helpdesk account payload returned by `/api/account/sso-validate`.
///
/// `tenantID` is required by every non-auth Helpdesk endpoint and must be
/// cached after a successful sign-in.
@JsonSerializable(fieldRename: FieldRename.none)
class Account {
  @JsonKey(name: 'accountID')
  final String accountId;
  @JsonKey(name: 'tenantID')
  final String? tenantId;
  final String email;
  final String username;
  final String? fullname;
  final String role;
  final String? phoneNumber;
  final String? profilePicture;
  @JsonKey(name: 'customerSupportID')
  final String? customerSupportId;
  final bool isBlocked;
  final String? clientSecretKey;
  @JsonKey(name: 'rocketChatID')
  final String? rocketChatId;
  final String? rocketChatToken;
  final String? lastSeenReleaseNoteVersion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Account({
    required this.accountId,
    required this.tenantId,
    required this.email,
    required this.username,
    required this.fullname,
    required this.role,
    required this.isBlocked,
    this.phoneNumber,
    this.profilePicture,
    this.customerSupportId,
    this.clientSecretKey,
    this.rocketChatId,
    this.rocketChatToken,
    this.lastSeenReleaseNoteVersion,
    this.createdAt,
    this.updatedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  String get initial {
    final trimmed = fullname?.trim() ?? '';
    if (trimmed.isNotEmpty) return trimmed[0].toUpperCase();
    if (username.isNotEmpty) return username[0].toUpperCase();
    if (email.isNotEmpty) return email[0].toUpperCase();
    return 'U';
  }
}
