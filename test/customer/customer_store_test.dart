import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:ai_helpdesk/domain/repository/customer/customer_repository.dart';
import 'package:ai_helpdesk/presentation/customer/store/customer_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}

void main() {
  late CustomerStore store;
  late MockCustomerRepository mockRepo;

  setUp(() {
    mockRepo = MockCustomerRepository();
    
    // Default stubs
    when(() => mockRepo.getAvailableTags()).thenAnswer((_) async => []);
    when(() => mockRepo.getCustomers(
          query: any(named: 'query'),
          tagIds: any(named: 'tagIds'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        )).thenAnswer((_) async => []);
    
    store = CustomerStore(mockRepo);
  });

  group('CustomerStore Tests', () {
    test('Initial state is correct', () async {
      expect(store.customers, isEmpty);
      expect(store.searchQuery, isEmpty);
      expect(store.availableTags, isEmpty);
    });

    test('loadCustomers updates state correctly on success', () async {
      final customers = [
        Customer(
          id: '1',
          fullName: 'User 1',
          emails: [],
          phones: [],
          zalos: [],
          messengers: [],
          createdAt: DateTime.now(),
          tags: [],
        ),
      ];

      when(() => mockRepo.getCustomers(
            query: any(named: 'query'),
            tagIds: any(named: 'tagIds'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => customers);

      await store.loadCustomers();

      expect(store.isLoading, isFalse);
      expect(store.customers.length, 1);
      expect(store.customers.first.fullName, 'User 1');
    });

    test('loadCustomers handles error and sets errorMessage', () async {
      when(() => mockRepo.getCustomers(
            query: any(named: 'query'),
            tagIds: any(named: 'tagIds'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenThrow(Exception('API Error'));

      await store.loadCustomers();

      expect(store.isLoading, isFalse);
      expect(store.errorMessage, contains('Failed to load customers'));
    });

    test('saveCustomer checks email validity for new customers', () async {
      final newCustomer = Customer(
        id: 'temp_id', // Assume new if not in list
        fullName: 'New User',
        emails: ['taken@example.com'],
        phones: [],
        zalos: [],
        messengers: [],
        createdAt: DateTime.now(),
        tags: [],
      );

      when(() => mockRepo.checkValidEmail('taken@example.com')).thenAnswer((_) async => false);

      final result = await store.saveCustomer(newCustomer);

      expect(result, isFalse);
      expect(store.errorMessage, contains('Email address is already in use'));
      verify(() => mockRepo.checkValidEmail('taken@example.com')).called(1);
    });

    test('pagination updates page and appends data', () async {
      final page1 = List.generate(20, (i) => Customer(
        id: 'p1_$i',
        fullName: 'User $i',
        emails: [],
        phones: [],
        zalos: [],
        messengers: [],
        createdAt: DateTime.now(),
        tags: [],
      ));

      final page2 = [
        Customer(
          id: 'p2_1',
          fullName: 'User 21',
          emails: [],
          phones: [],
          zalos: [],
          messengers: [],
          createdAt: DateTime.now(),
          tags: [],
        ),
      ];

      when(() => mockRepo.getCustomers(
            offset: 0,
            limit: 20,
            query: any(named: 'query'),
            tagIds: any(named: 'tagIds'),
          )).thenAnswer((_) async => page1);

      when(() => mockRepo.getCustomers(
            offset: 20,
            limit: 20,
            query: any(named: 'query'),
            tagIds: any(named: 'tagIds'),
          )).thenAnswer((_) async => page2);

      await store.loadCustomers(); // Load first page
      expect(store.customers.length, 20);

      await store.loadCustomers(isLoadMore: true); // Load second page
      expect(store.customers.length, 21);
      expect(store.hasReachedMax, isTrue); // Because page 2 has < 20 items
    });
  });
}
