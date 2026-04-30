import 'tag.dart';

class Customer {
  final String id;
  final String fullName;
  final List<String> emails;
  final List<String> phones;
  final List<String> zalos;
  final List<String> messengers;
  final DateTime createdAt;
  final DateTime? lastContactedAt;
  final int totalTickets;
  final List<Tag> tags;
  final String? avatarUrl;
  final String? tenantId;
  final String? tenantName;
  final DateTime? updatedAt;
  final List<String> groups;

  const Customer({
    required this.id,
    required this.fullName,
    this.emails = const [],
    this.phones = const [],
    this.zalos = const [],
    this.messengers = const [],
    required this.createdAt,
    this.lastContactedAt,
    this.totalTickets = 0,
    this.tags = const [],
    this.avatarUrl,
    this.tenantId,
    this.tenantName,
    this.updatedAt,
    this.groups = const [],
  });

  Customer copyWith({
    String? id,
    String? fullName,
    List<String>? emails,
    List<String>? phones,
    List<String>? zalos,
    List<String>? messengers,
    DateTime? createdAt,
    DateTime? lastContactedAt,
    int? totalTickets,
    List<Tag>? tags,
    String? avatarUrl,
    String? tenantId,
    String? tenantName,
    DateTime? updatedAt,
    List<String>? groups,
  }) {
    return Customer(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      emails: emails ?? this.emails,
      phones: phones ?? this.phones,
      zalos: zalos ?? this.zalos,
      messengers: messengers ?? this.messengers,
      createdAt: createdAt ?? this.createdAt,
      lastContactedAt: lastContactedAt ?? this.lastContactedAt,
      totalTickets: totalTickets ?? this.totalTickets,
      tags: tags ?? this.tags,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      tenantId: tenantId ?? this.tenantId,
      tenantName: tenantName ?? this.tenantName,
      updatedAt: updatedAt ?? this.updatedAt,
      groups: groups ?? this.groups,
    );
  }
}
