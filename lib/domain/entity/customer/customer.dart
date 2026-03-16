class Customer {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? company;
  final DateTime createdAt;
  final DateTime? lastContactedAt;
  final int totalTickets;

  const Customer({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.company,
    required this.createdAt,
    this.lastContactedAt,
    required this.totalTickets,
  });

  Customer copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? company,
    DateTime? createdAt,
    DateTime? lastContactedAt,
    int? totalTickets,
  }) {
    return Customer(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      company: company ?? this.company,
      createdAt: createdAt ?? this.createdAt,
      lastContactedAt: lastContactedAt ?? this.lastContactedAt,
      totalTickets: totalTickets ?? this.totalTickets,
    );
  }

  @override
  String toString() =>
      'Customer(id: $id, fullName: $fullName, email: $email, phone: $phone)';
}
