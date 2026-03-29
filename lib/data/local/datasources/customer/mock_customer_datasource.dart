import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:ai_helpdesk/domain/entity/customer/tag.dart';

class MockCustomerDataSource {
  final List<Customer> _customers = [];
  final List<Tag> _tags = [];

  MockCustomerDataSource() {
    _seedData();
  }

  void _seedData() {
    // Tags
    _tags.addAll([
      const Tag(id: 'tag_1', name: 'VIP', colorHex: '#FFD700'),
      const Tag(id: 'tag_2', name: 'New', colorHex: '#00FF00'),
      const Tag(id: 'tag_3', name: 'Luxury', colorHex: '#FF0000'),
    ]);

    // Customers
    final now = DateTime.now();
    _customers.addAll([
      Customer(
        id: 'cust_1',
        fullName: 'Nguyễn Văn Anh',
        emails: ['anh.nguyen@example.com'],
        phones: ['0901234567'],
        zalos: ['0901234567'],
        messengers: ['m.me/anh.nguyen'],
        createdAt: now.subtract(const Duration(days: 100)),
        lastContactedAt: now.subtract(const Duration(days: 2)),
        totalTickets: 5,
        tags: [_tags[0]],
      ),
      Customer(
        id: 'cust_2',
        fullName: 'Trần Thị Hà',
        emails: ['ha.tran@example.com'],
        phones: ['0912345678'],
        createdAt: now.subtract(const Duration(days: 10)),
        lastContactedAt: now.subtract(const Duration(days: 1)),
        totalTickets: 1,
        tags: [_tags[1]],
      ),
      Customer(
        id: 'cust_3',
        fullName: 'Lê Văn Cẩn',
        emails: ['can.le@example.com'],
        phones: ['0987654321'],
        zalos: ['0987654321'],
        createdAt: now.subtract(const Duration(days: 300)),
        lastContactedAt: now.subtract(const Duration(days: 60)),
        totalTickets: 12,
        tags: [_tags[2]],
      ),
    ]);
  }

  Future<List<Customer>> getCustomers({
    String? query,
    List<String>? tagIds,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var result = _customers.toList();

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      result = result.where((c) {
        return c.fullName.toLowerCase().contains(q) ||
            c.emails.any((e) => e.toLowerCase().contains(q)) ||
            c.phones.any((p) => p.contains(q)) ||
            c.zalos.any((z) => z.contains(q)) ||
            c.messengers.any((m) => m.toLowerCase().contains(q));
      }).toList();
    }

    if (tagIds != null && tagIds.isNotEmpty) {
      result = result.where((c) {
        return c.tags.any((t) => tagIds.contains(t.id));
      }).toList();
    }

    return result;
  }

  Future<Customer?> getCustomerById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _customers.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Customer> createCustomer(Customer customer) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newCustomer = customer.copyWith(
      id: 'cust_${DateTime.now().millisecondsSinceEpoch}',
    );
    _customers.add(newCustomer);
    return newCustomer;
  }

  Future<Customer> updateCustomer(Customer customer) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _customers.indexWhere((c) => c.id == customer.id);
    if (index == -1) {
      throw Exception('Customer not found');
    }
    _customers[index] = customer;
    return customer;
  }

  Future<void> deleteCustomer(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _customers.removeWhere((c) => c.id == id);
  }

  Future<Customer> mergeCustomers({
    required String targetCustomerId,
    required String sourceCustomerId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final targetIndex = _customers.indexWhere((c) => c.id == targetCustomerId);
    final sourceIndex = _customers.indexWhere((c) => c.id == sourceCustomerId);

    if (targetIndex == -1 || sourceIndex == -1) {
      throw Exception('Customer not found');
    }

    final target = _customers[targetIndex];
    final source = _customers[sourceIndex];

    final mergedTags = {...target.tags, ...source.tags}.toList();

    final mergedCustomer = target.copyWith(
      totalTickets: target.totalTickets + source.totalTickets,
      tags: mergedTags,
      phones: {...target.phones, ...source.phones}.toList(),
      zalos: {...target.zalos, ...source.zalos}.toList(),
      messengers: {...target.messengers, ...source.messengers}.toList(),
      emails: {...target.emails, ...source.emails}.toList(),
    );

    _customers[targetIndex] = mergedCustomer;
    _customers.removeAt(sourceIndex);

    return mergedCustomer;
  }

  Future<List<Tag>> getAvailableTags() async {
    return _tags.toList();
  }

  Future<Tag> createTag({
    required String name,
    required String colorHex,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newTag = Tag(
      id: 'tag_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      colorHex: colorHex,
    );
    _tags.add(newTag);
    return newTag;
  }

  Future<Customer> addTagToCustomer(String customerId, String tagId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _customers.indexWhere((c) => c.id == customerId);
    if (index == -1) throw Exception('Customer not found');

    final customer = _customers[index];
    if (customer.tags.any((t) => t.id == tagId)) return customer;

    final tag = _tags.firstWhere(
      (t) => t.id == tagId,
      orElse: () => throw Exception('Tag not found'),
    );
    final updated = customer.copyWith(tags: [...customer.tags, tag]);
    _customers[index] = updated;
    return updated;
  }

  Future<Customer> removeTagFromCustomer(
    String customerId,
    String tagId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _customers.indexWhere((c) => c.id == customerId);
    if (index == -1) throw Exception('Customer not found');

    final customer = _customers[index];
    final updatedTags = customer.tags.where((t) => t.id != tagId).toList();
    final updated = customer.copyWith(tags: updatedTags);
    _customers[index] = updated;
    return updated;
  }

  Future<Customer> addCustomerContact(
    String customerId, {
    String? email,
    String? phone,
    String? zalo,
    String? messenger,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _customers.indexWhere((c) => c.id == customerId);
    if (index == -1) throw Exception('Customer not found');

    final customer = _customers[index];
    final updated = customer.copyWith(
      emails: email != null && !customer.emails.contains(email) ? [...customer.emails, email] : customer.emails,
      phones: phone != null && !customer.phones.contains(phone) ? [...customer.phones, phone] : customer.phones,
      zalos: zalo != null && !customer.zalos.contains(zalo) ? [...customer.zalos, zalo] : customer.zalos,
      messengers: messenger != null && !customer.messengers.contains(messenger) ? [...customer.messengers, messenger] : customer.messengers,
    );
    _customers[index] = updated;
    return updated;
  }

  Future<Customer> deleteCustomerContact(
    String customerId, {
    String? email,
    String? phone,
    String? zalo,
    String? messenger,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _customers.indexWhere((c) => c.id == customerId);
    if (index == -1) throw Exception('Customer not found');

    final customer = _customers[index];
    final updated = customer.copyWith(
      emails: email != null ? customer.emails.where((e) => e != email).toList() : customer.emails,
      phones: phone != null ? customer.phones.where((p) => p != phone).toList() : customer.phones,
      zalos: zalo != null ? customer.zalos.where((z) => z != zalo).toList() : customer.zalos,
      messengers: messenger != null ? customer.messengers.where((m) => m != messenger).toList() : customer.messengers,
    );
    _customers[index] = updated;
    return updated;
  }
}
