import 'package:ai_helpdesk/data/local/datasources/customer/mock_customer_datasource.dart';
import 'package:ai_helpdesk/data/network/dto/customer/customer_dto.dart';
import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:ai_helpdesk/domain/entity/customer/tag.dart';
import 'package:ai_helpdesk/domain/repository/customer/customer_repository.dart';
import 'package:ai_helpdesk/presentation/customer/store/customer_store.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRepository implements CustomerRepository {
  List<Customer> _customers = [];
  final List<Tag> _tags = [const Tag(id: 'tag_1', name: 'VIP')];

  set customersData(List<Customer> list) => _customers = list;

  @override
  Future<List<Customer>> getCustomers({
    String? query,
    List<String>? tagIds,
    int limit = 20,
    int offset = 0,
  }) async {
    return _customers;
  }

  @override
  Future<bool> checkValidEmail(String email) async => true;

  @override
  Future<List<Tag>> getAvailableTags() async {
    return _tags;
  }

  @override
  Future<Customer?> getCustomerById(String id) async => null;
  @override
  Future<Customer> createCustomer(Customer customer) async => customer;
  @override
  Future<Customer> updateCustomer(Customer customer) async => customer;
  @override
  Future<void> deleteCustomer(String id) async {}

  @override
  Future<Customer> mergeCustomers({
    required String primaryCustomerId,
    required String secondaryCustomerId,
  }) async {
    return _customers.first;
  }

  @override
  Future<Tag> createTag({required String name}) async => _tags.first;

  @override
  Future<Tag> updateTag({required String id, required String name}) async =>
      _tags.first;

  @override
  Future<void> deleteTag({required String id}) async {}
  @override
  Future<Customer> addTagToCustomer(String customerId, String tagId) async =>
      _customers.first;
  @override
  Future<Customer> removeTagFromCustomer(
    String customerId,
    String tagId,
  ) async => _customers.first;
  @override
  Future<Customer> addCustomerContact(
    String customerId, {
    String? email,
    String? phone,
    String? zalo,
    String? messenger,
  }) async => _customers.first;
  @override
  Future<Customer> deleteCustomerContact(
    String customerId, {
    String? email,
    String? phone,
    String? zalo,
    String? messenger,
  }) async => _customers.first;

  @override
  Future<String?> getTenantName(String id) async => 'Test Tenant';
}

void main() {
  group('MockCustomerDataSource Tests', () {
    late MockCustomerDataSource dataSource;

    setUp(() {
      dataSource = MockCustomerDataSource();
    });

    test('Initial data is seeded', () async {
      final customers = await dataSource.getCustomers();
      expect(customers.length, 3);
    });

    test('Search by name works', () async {
      final results = await dataSource.getCustomers(query: 'Nguyễn Văn Anh');
      expect(results.length, 1);
      expect(results.first.fullName, 'Nguyễn Văn Anh');
    });

    test('Tag filtering works', () async {
      final results = await dataSource.getCustomers(tagIds: ['tag_1']);
      expect(results.length, 1);
      expect(results.first.tags.any((t) => t.name == 'VIP'), isTrue);
    });

    test('Merge customers combines logic works correctly', () async {
      final result = await dataSource.mergeCustomers(
        primaryCustomerId: 'cust_1',
        secondaryCustomerId: 'cust_2',
      );

      // Check merged fields
      expect(result.fullName, 'Nguyễn Văn Anh'); // Target name
      expect(result.totalTickets, 6); // 5 + 1
      expect(result.tags.length, 2); // VIP + New

      // Verify contacts union correctly
      expect(
        result.emails,
        containsAll(['anh.nguyen@example.com', 'ha.tran@example.com']),
      );
      expect(result.phones, containsAll(['0901234567', '0912345678']));
      expect(result.zalos, contains('0901234567'));
      expect(result.messengers, contains('m.me/anh.nguyen'));
    });

    test('Add and remove contact info works correctly', () async {
      // Add email
      await dataSource.addCustomerContact(
        'cust_3',
        email: 'extra.can@example.com',
      );
      var updated = await dataSource.getCustomerById('cust_3');
      expect(
        updated!.emails,
        containsAll(['can.le@example.com', 'extra.can@example.com']),
      );

      // Remove email
      await dataSource.deleteCustomerContact(
        'cust_3',
        email: 'extra.can@example.com',
      );
      updated = await dataSource.getCustomerById('cust_3');
      expect(updated!.emails, ['can.le@example.com']); // Restored state
    });
  });

  group('CustomerStore Tests', () {
    late CustomerStore store;
    late MockRepository mockRepo;

    setUp(() {
      mockRepo = MockRepository();
      store = CustomerStore(mockRepo);
    });

    test('Store initializes and loads tags', () async {
      // Small delay because _init is async called from constructor
      await Future.delayed(const Duration(milliseconds: 100));
      expect(store.availableTags.length, 1);
      expect(store.availableTags.first.name, 'VIP');
    });

    test('setSearchQuery updates query and triggers loading', () async {
      mockRepo.customersData = [
        Customer(
          id: '1',
          fullName: 'Test User',
          createdAt: DateTime.now(),
          lastContactedAt: DateTime.now(),
          totalTickets: 0,
          tags: [],
          emails: [],
          phones: [],
          zalos: [],
          messengers: [],
        ),
      ];

      store.setSearchQuery('Test');
      expect(store.searchQuery, 'Test');
      expect(store.isLoading, isTrue); // Triggers load immediately
    });

    test('toggleTagFilter and applyFilters work', () async {
      store.toggleTagFilter('tag_1');
      expect(store.selectedTagIds.contains('tag_1'), isTrue);

      store.applyFilters();
      expect(store.isLoading, isTrue);
    });
  });

  group('CustomerDto Mapping Tests', () {
    test('toEntity maps tenantID and avatarUrl correctly', () {
      final json = {
        'customerID': 'cus_123',
        'name': 'Test User',
        'tenantID': 'tenant_999',
        'updatedAt': '2026-04-28T10:00:00.000Z',
        'CustomerGroups': [
          {'groupID': 'grp_1', 'name': 'VIP Group'},
        ],
        'avatar': 'https://example.com/photo.jpg',
        'contactInfo': [
          {'name': 'EMAIL', 'email': 'dto@example.com'},
          {'name': 'PHONE', 'phone': '0123456789'},
          {
            'name': 'ZALO_PERSONAL',
            'zaloAccountName': 'ZaloName',
            'zalophone': '0999888777',
            'zaloAccountAvatar': 'https://zalo.com/ava.jpg',
          },
        ],
      };

      final dto = CustomerDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.id, 'cus_123');
      expect(entity.tenantId, 'tenant_999');
      expect(entity.avatarUrl, 'https://example.com/photo.jpg');
      expect(entity.emails, contains('dto@example.com'));
      expect(entity.phones, containsAll(['0123456789', '0999888777']));
      expect(entity.zalos, contains('ZaloName'));
      expect(entity.groups, contains('VIP Group'));
      expect(entity.updatedAt, isNotNull);
    });

    test(
      'toEntity falls back to Zalo avatar if top-level avatar is missing',
      () {
        final json = {
          'customerID': 'cus_123',
          'name': 'Test User',
          'contactInfo': [
            {
              'name': 'ZALO_PERSONAL',
              'zaloAccountName': 'ZaloName',
              'zaloAccountAvatar': 'https://zalo.com/ava.jpg',
            },
          ],
        };

        final dto = CustomerDto.fromJson(json);
        final entity = dto.toEntity();

        expect(entity.avatarUrl, 'https://zalo.com/ava.jpg');
      },
    );

    test('toEntity deduplicates phone numbers', () {
      final json = {
        'name': 'Test',
        'contactInfo': [
          {'name': 'PHONE', 'phone': '090'},
          {'name': 'ZALO_PERSONAL', 'zaloAccountName': 'Z', 'zalophone': '090'},
        ],
      };

      final dto = CustomerDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.phones.length, 1);
      expect(entity.phones.first, '090');
    });
  });
}
