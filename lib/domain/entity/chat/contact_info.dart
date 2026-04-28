import '../../enums/chat/contact_channel.dart';

class ContactInfo {
  final String id;
  final String customerId;
  final ContactChannel channel;
  final bool isSpam;

  final String? email;
  final String? phone;
  final String? externalAccountId;

  const ContactInfo({
    required this.id,
    required this.customerId,
    required this.channel,
    required this.isSpam,
    this.email,
    this.phone,
    this.externalAccountId,
  });
}