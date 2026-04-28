// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerDto _$CustomerDtoFromJson(Map<String, dynamic> json) => CustomerDto(
  customerID: json['customerID'] as String?,
  name: json['name'] as String?,
  avatar: json['avatar'] as String?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  deletedAt:
      json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
  tenantId: json['tenantID'] as String?,
  contacts:
      (json['contactInfo'] as List<dynamic>?)
          ?.map((e) => CustomerContactDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  tags:
      (json['tags'] as List<dynamic>?)
          ?.map((e) => CustomerTagDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  groups:
      (json['CustomerGroups'] as List<dynamic>?)
          ?.map((e) => CustomerGroupDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$CustomerDtoToJson(CustomerDto instance) =>
    <String, dynamic>{
      'customerID': instance.customerID,
      'name': instance.name,
      'avatar': instance.avatar,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'contactInfo': instance.contacts,
      'tags': instance.tags,
      'CustomerGroups': instance.groups,
      'tenantID': instance.tenantId,
    };

CustomerContactDto _$CustomerContactDtoFromJson(Map<String, dynamic> json) =>
    CustomerContactDto(
      contactID: json['contactID'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      value: json['value'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      zalophone: json['zalophone'] as String?,
      zaloAccountName: json['zaloAccountName'] as String?,
      zaloAccountAvatar: json['zaloAccountAvatar'] as String?,
    );

Map<String, dynamic> _$CustomerContactDtoToJson(CustomerContactDto instance) =>
    <String, dynamic>{
      'contactID': instance.contactID,
      'name': instance.name,
      'type': instance.type,
      'value': instance.value,
      'email': instance.email,
      'phone': instance.phone,
      'zalophone': instance.zalophone,
      'zaloAccountName': instance.zaloAccountName,
      'zaloAccountAvatar': instance.zaloAccountAvatar,
    };

CustomerTagDto _$CustomerTagDtoFromJson(Map<String, dynamic> json) =>
    CustomerTagDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$CustomerTagDtoToJson(CustomerTagDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
    };

CustomerGroupDto _$CustomerGroupDtoFromJson(Map<String, dynamic> json) =>
    CustomerGroupDto(
      groupID: json['groupID'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$CustomerGroupDtoToJson(CustomerGroupDto instance) =>
    <String, dynamic>{'groupID': instance.groupID, 'name': instance.name};
