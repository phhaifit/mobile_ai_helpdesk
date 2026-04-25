class ContactInfoDto {
  final String contactId;
  final String customerId;
  final String name; // Channel type: messenger, zalo, email, phone, webchat, lazada, zendesk, zohodesk, zalo_personal
  final bool isSpam;
  final String? zaloAccountId;
  final String? email;
  final String? phone;
  final String? messengerAccountId;
  final String? zohoAccountId;

  ContactInfoDto({required this.contactId, required this.customerId, required this.name, required this.isSpam, required this.zaloAccountId, required this.email, required this.phone, required this.messengerAccountId, required this.zohoAccountId});

  factory ContactInfoDto.fromJson(Map<String, dynamic> json) {
    return ContactInfoDto(
      contactId: json['contactID']?.toString() ?? '',
      customerId: json['customerID']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      isSpam: (json['isSpam'] is bool) ? (json['isSpam'] as bool) : false,
      zaloAccountId: json['zaloAccountID']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      messengerAccountId: json['messengerAccountID']?.toString(),
      zohoAccountId: json['zohoAccountID']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactID': contactId,
      'customerID': customerId,
      'name': name,
      'isSpam': isSpam,
      'zaloAccountID': zaloAccountId,
      'email': email,
      'phone': phone,
      'messengerAccountID': messengerAccountId,
      'zohoAccountID': zohoAccountId,
    };
  }
}