import 'package:json_annotation/json_annotation.dart';

part 'auth_session.g.dart';

/// Credentials returned by Stack Auth after a successful OTP sign-in.
/// Access token is a ~90d JWT; refresh token is used to rotate it.
@JsonSerializable(fieldRename: FieldRename.snake)
class AuthSession {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final bool isNewUser;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.isNewUser,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);

  Map<String, dynamic> toJson() => _$AuthSessionToJson(this);

  AuthSession copyWith({String? accessToken}) => AuthSession(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken,
        userId: userId,
        isNewUser: isNewUser,
      );
}
