// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSession _$AuthSessionFromJson(Map<String, dynamic> json) => AuthSession(
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
  userId: json['user_id'] as String,
  isNewUser: json['is_new_user'] as bool,
);

Map<String, dynamic> _$AuthSessionToJson(AuthSession instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'user_id': instance.userId,
      'is_new_user': instance.isNewUser,
    };
