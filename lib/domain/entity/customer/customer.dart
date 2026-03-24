import 'support_ticket.dart';

class Customer {
  final String id;
  final String fullName;
  final String? email;
  final String? phone;
  final String? phoneNumber;
  final String? company;
  final DateTime? createdAt;
  final DateTime? lastContactedAt;
  final int totalTickets;
  final String? zalo;
  final String? messenger;
  final List<String> tags;
  final String? segment;
  final bool isBlocked;
  final SupportTicket? ticket;

  Customer({
    required this.id,
    required this.fullName,
    this.email,
    this.phone,
    this.phoneNumber,
    this.company,
    this.createdAt,
    this.lastContactedAt,
    this.totalTickets = 0,
    this.zalo,
    this.messenger,
    this.tags = const [],
    this.segment,
    this.isBlocked = false,
    this.ticket,
  });

  Customer copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? phoneNumber,
    String? company,
    DateTime? createdAt,
    DateTime? lastContactedAt,
    int? totalTickets,
    String? zalo,
    String? messenger,
    List<String>? tags,
    String? segment,
    bool? isBlocked,
    SupportTicket? ticket,
  }) {
    return Customer(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      company: company ?? this.company,
      createdAt: createdAt ?? this.createdAt,
      lastContactedAt: lastContactedAt ?? this.lastContactedAt,
      totalTickets: totalTickets ?? this.totalTickets,
      zalo: zalo ?? this.zalo,
      messenger: messenger ?? this.messenger,
      tags: tags ?? this.tags,
      segment: segment ?? this.segment,
      isBlocked: isBlocked ?? this.isBlocked,
      ticket: ticket ?? this.ticket,
    );
  }

  @override
  String toString() =>
      'Customer(id: $id, fullName: $fullName, email: $email, phone: $phone)';
}
