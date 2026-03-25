import 'package:ai_helpdesk/domain/entity/enums.dart';

class ContactInfo {
  final ContactType type;
  final String value;

  ContactInfo({
    required this.type,
    required this.value,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactInfo &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          value == other.value;

  @override
  int get hashCode => type.hashCode ^ value.hashCode;
}
