import 'package:ai_helpdesk/domain/entity/account/account.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Account.fromJson', () {
    test('normalizes nullable tenantID and fullname to empty strings', () {
      final json = <String, dynamic>{
        'accountID': 'acc-1',
        'tenantID': null,
        'email': 'user@example.com',
        'username': 'jarvis',
        'fullname': null,
        'role': 'agent',
        'isBlocked': false,
      };

      final account = Account.fromJson(json);

      expect(account.tenantId, '');
      expect(account.fullname, '');
      expect(account.initial, 'J');
      expect(account.toJson()['tenantID'], '');
      expect(account.toJson()['fullname'], '');
    });
  });
}
