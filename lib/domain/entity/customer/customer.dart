import 'support_ticket.dart';

class Customer {
  final String id;
  final String fullName;
  final String? email;
  final String? phoneNumber;
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
    this.phoneNumber,
    this.zalo,
    this.messenger,
    this.tags = const [],
    this.segment,
    this.isBlocked = false,
    this.ticket,
  });

  Customer copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? zalo,
    String? messenger,
    List<String>? tags,
    String? segment,
    bool? isBlocked,
    SupportTicket? ticket,
  }) {
    return Customer(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      zalo: zalo ?? this.zalo,
      messenger: messenger ?? this.messenger,
      tags: tags ?? this.tags,
      segment: segment ?? this.segment,
      isBlocked: isBlocked ?? this.isBlocked,
      ticket: ticket ?? this.ticket,
    );
  }
}
