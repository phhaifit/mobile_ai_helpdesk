import 'package:ai_helpdesk/domain/usecase/ticket/get_customer_history_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_ticket_repository.dart';
import '../helpers/ticket_fixtures.dart';

void main() {
  late FakeTicketRepository fakeRepo;
  late GetCustomerHistoryUseCase useCase;

  setUp(() {
    fakeRepo = FakeTicketRepository();
    useCase = GetCustomerHistoryUseCase(fakeRepo);
  });

  group('GetCustomerHistoryUseCase', () {
    test('passes customerId to repository', () async {
      fakeRepo.customerHistoryToReturn = [];

      await useCase(params: kTestCustomerId);

      expect(fakeRepo.capturedCustomerHistoryId, kTestCustomerId);
    });

    test('returns empty list when customer has no tickets', () async {
      fakeRepo.customerHistoryToReturn = [];

      final result = await useCase(params: kTestCustomerId);

      expect(result, isEmpty);
    });

    test('returns all tickets from repository', () async {
      fakeRepo.customerHistoryToReturn = [kTestTicket, kTestTicket2];

      final result = await useCase(params: kTestCustomerId);

      expect(result.length, 2);
      expect(result[0].id, kTestTicket.id);
      expect(result[1].id, kTestTicket2.id);
    });

    test('tickets have correct customerId', () async {
      fakeRepo.customerHistoryToReturn = [kTestTicket, kTestTicket2];

      final result = await useCase(params: kTestCustomerId);

      for (final ticket in result) {
        expect(ticket.customerId, kTestCustomerId);
      }
    });

    test('passes different customerId on second call', () async {
      await useCase(params: 'cust-aaa');
      await useCase(params: 'cust-bbb');

      expect(fakeRepo.capturedCustomerHistoryId, 'cust-bbb');
    });
  });
}
