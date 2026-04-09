import 'package:json_annotation/json_annotation.dart';
import 'package:ai_helpdesk/domain/entity/auth/user.dart';

part 'auth_response.g.dart';

/// Response from sign-in / sign-up endpoints.
///
/// The real auth API returns `{access_token, refresh_token, user_id}`.
/// [user] is populated separately by calling GET /api/v1/auth/me.
@JsonSerializable()
class AuthResponse {
  @JsonKey(name: 'access_token')
  final String token;

  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  @JsonKey(name: 'user_id')
  final String? userId;

  /// Full user profile — populated after fetching from /auth/me.
  @JsonKey(includeFromJson: false, includeToJson: false)
  final User? user;

  const AuthResponse({
    required this.token,
    this.refreshToken,
    this.userId,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  /// Creates a copy with an attached [User] profile.
  AuthResponse withUser(User user) => AuthResponse(
    token: token,
    refreshToken: refreshToken,
    userId: userId ?? user.id,
    user: user,
  );
}
