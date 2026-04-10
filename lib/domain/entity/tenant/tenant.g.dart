// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tenant _$TenantFromJson(Map<String, dynamic> json) => Tenant(
  id: json['id'] as String,
  name: json['name'] as String,
  settings: TenantSettings.fromJson(json['settings'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  slug: json['slug'] as String?,
);

Map<String, dynamic> _$TenantToJson(Tenant instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'settings': instance.settings,
  'createdAt': instance.createdAt.toIso8601String(),
};
