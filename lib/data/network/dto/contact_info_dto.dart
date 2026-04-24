class ContactInfoDto {
  final String contactID;
  final String customerID;
  final String name; // Channel type: messenger, zalo, email, phone, webchat, lazada, zendesk, zohodesk, zalo_personal
  final bool isSpam;
  final String? zaloAccountID;
  final String? email;
  final String? phone;
  final String? messengerAccountID;
  final String? zohoAccountID;

  ContactInfoDto({required this.contactID, required this.customerID, required this.name, required this.isSpam, required this.zaloAccountID, required this.email, required this.phone, required this.messengerAccountID, required this.zohoAccountID});

  factory ContactInfoDto.fromJson(Map<String, dynamic> json) {
    return ContactInfoDto(
      contactID: json['contactID']?.toString() ?? '',
      customerID: json['customerID']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      isSpam: (json['isSpam'] is bool) ? (json['isSpam'] as bool) : false,
      zaloAccountID: json['zaloAccountID']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      messengerAccountID: json['messengerAccountID']?.toString(),
      zohoAccountID: json['zohoAccountID']?.toString(),
    );
  }
}