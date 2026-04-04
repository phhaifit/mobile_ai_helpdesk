import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_ai_helpdesk/domain/entity/auth/user.dart';

part 'auth_response.g.dart';

/// Auth response after successful login/register
@JsonSerializable()
class AuthResponse {
  final String token;
  final String? refreshToken;
  final User user;

  const AuthResponse({
    required this.token,
    required this.user,
    this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
