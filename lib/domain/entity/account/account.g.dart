// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
  accountId: json['accountID'] as String,
  tenantId: json['tenantID'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  fullname: json['fullname'] as String,
  role: json['role'] as String,
  isBlocked: json['isBlocked'] as bool,
  phoneNumber: json['phoneNumber'] as String?,
  profilePicture: json['profilePicture'] as String?,
  customerSupportId: json['customerSupportID'] as String?,
  clientSecretKey: json['clientSecretKey'] as String?,
  rocketChatId: json['rocketChatID'] as String?,
  rocketChatToken: json['rocketChatToken'] as String?,
  lastSeenReleaseNoteVersion: json['lastSeenReleaseNoteVersion'] as String?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
  'accountID': instance.accountId,
  'tenantID': instance.tenantId,
  'email': instance.email,
  'username': instance.username,
  'fullname': instance.fullname,
  'role': instance.role,
  'phoneNumber': instance.phoneNumber,
  'profilePicture': instance.profilePicture,
  'customerSupportID': instance.customerSupportId,
  'isBlocked': instance.isBlocked,
  'clientSecretKey': instance.clientSecretKey,
  'rocketChatID': instance.rocketChatId,
  'rocketChatToken': instance.rocketChatToken,
  'lastSeenReleaseNoteVersion': instance.lastSeenReleaseNoteVersion,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
