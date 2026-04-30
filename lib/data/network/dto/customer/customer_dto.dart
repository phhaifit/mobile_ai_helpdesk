import 'package:json_annotation/json_annotation.dart';
import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:ai_helpdesk/domain/entity/customer/tag.dart';

part 'customer_dto.g.dart';

@JsonSerializable()
class CustomerDto {
  final String? customerID;
  final String? name;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  @JsonKey(name: 'contactInfo', defaultValue: [])
  final List<CustomerContactDto> contacts;
  @JsonKey(defaultValue: [])
  final List<CustomerTagDto> tags;
  @JsonKey(name: 'CustomerGroups', defaultValue: [])
  final List<CustomerGroupDto> groups;
  @JsonKey(name: 'tenantID')
  final String? tenantId;

  const CustomerDto({
    this.customerID,
    this.name,
    this.avatar,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.tenantId,
    this.contacts = const [],
    this.tags = const [],
    this.groups = const [],
  });

  factory CustomerDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerDtoFromJson(json);

  Customer toEntity() {
    final List<String> e = [];
    final List<String> p = [];
    final List<String> z = [];
    final List<String> m = [];
    String? foundAvatar = avatar;
    
    for (var contact in contacts) {
      if (contact.name == 'EMAIL') {
        final val = contact.email ?? contact.value;
        if (val != null) e.add(val);
      }
      if (contact.name == 'PHONE') {
        final val = contact.phone ?? contact.value;
        if (val != null) p.add(val);
      }
      if (contact.name == 'ZALO_PERSONAL' && contact.zaloAccountName != null) {
        z.add(contact.zaloAccountName!); 
        if (contact.zalophone != null && contact.zalophone!.isNotEmpty) {
          p.add(contact.zalophone!);
        }
        if (foundAvatar == null || foundAvatar.isEmpty) {
          foundAvatar = contact.zaloAccountAvatar;
        }
      }
      if (contact.name == 'MESSENGER' && contact.value != null) m.add(contact.value!);
    }

    return Customer(
      id: customerID ?? '',
      fullName: name ?? 'Unknown',
      emails: e.toSet().toList(),
      phones: p.toSet().toList(),
      zalos: z.toSet().toList(),
      messengers: m.toSet().toList(),
      createdAt: createdAt ?? DateTime.now(),
      tags: tags.map((t) => Tag(id: t.id ?? '', name: t.name ?? '')).toList(),
      avatarUrl: foundAvatar,
      tenantId: tenantId,
      updatedAt: updatedAt,
      groups: groups.map((g) => g.name ?? '').where((n) => n.isNotEmpty).toList(),
    );
  }

  Map<String, dynamic> toJson() => _$CustomerDtoToJson(this);
}

@JsonSerializable()
class CustomerContactDto {
  final String? contactID;
  final String? name;
  final String? type;
  final String? value;
  final String? email;
  final String? phone;
  final String? zalophone;
  final String? zaloAccountName;
  final String? zaloAccountAvatar;

  const CustomerContactDto({
    this.contactID,
    this.name,
    this.type,
    this.value,
    this.email,
    this.phone,
    this.zalophone,
    this.zaloAccountName,
    this.zaloAccountAvatar,
  });

  factory CustomerContactDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerContactDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerContactDtoToJson(this);
}

@JsonSerializable()
class CustomerTagDto {
  @JsonKey(name: 'tagID')
  final String? id;
  @JsonKey(name: 'tagName')
  final String? name;
  final String? color;

  const CustomerTagDto({this.id, this.name, this.color});

  factory CustomerTagDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerTagDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerTagDtoToJson(this);
}

@JsonSerializable()
class CustomerGroupDto {
  final String? groupID;
  final String? name;

  const CustomerGroupDto({this.groupID, this.name});

  factory CustomerGroupDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerGroupDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerGroupDtoToJson(this);
}
