import 'package:ai_helpdesk/data/network/apis/customer/customer_api.dart';
import 'package:ai_helpdesk/data/network/dto/customer/customer_dto.dart';
import 'package:ai_helpdesk/data/repository/customer/customer_repository_impl.dart';
import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerApi extends Mock implements CustomerApi {}

void main() {
  late CustomerRepositoryImpl repository;
  late MockCustomerApi mockApi;

  setUp(() {
    mockApi = MockCustomerApi();
    repository = CustomerRepositoryImpl(mockApi);
  });

  group('CustomerRepositoryImpl Tests', () {
    test('getCustomers converts DTOs to entities', () async {
      final dtos = [
        const CustomerDto(customerID: '1', name: 'User 1'),
        const CustomerDto(customerID: '2', name: 'User 2'),
      ];

      when(() => mockApi.getCustomers(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            search: any(named: 'search'),
            tagIds: any(named: 'tagIds'),
          )).thenAnswer((_) async => dtos);

      final result = await repository.getCustomers();

      expect(result.length, 2);
      expect(result.first.fullName, 'User 1');
      expect(result.first.id, '1');
    });

    test('getCustomerById returns entity if found', () async {
      const dto = CustomerDto(customerID: '1', name: 'User 1');
      when(() => mockApi.getCustomerById('1')).thenAnswer((_) async => dto);

      final result = await repository.getCustomerById('1');

      expect(result?.fullName, 'User 1');
    });

    test('createCustomer delegates to API and returns entity', () async {
      final customer = Customer(
        id: '',
        fullName: 'New User',
        emails: ['test@test.com'],
        phones: [],
        zalos: [],
        messengers: [],
        createdAt: DateTime.now(),
        tags: [],
      );

      const dto = CustomerDto(customerID: 'new_id', name: 'New User');
      
      when(() => mockApi.createCustomer(
            name: any(named: 'name'),
            email: any(named: 'email'),
            phone: any(named: 'phone'),
          )).thenAnswer((_) async => dto);

      final result = await repository.createCustomer(customer);

      expect(result.id, 'new_id');
      verify(() => mockApi.createCustomer(
            name: 'New User',
            email: 'test@test.com',
            phone: null,
          )).called(1);
    });
  });
}
