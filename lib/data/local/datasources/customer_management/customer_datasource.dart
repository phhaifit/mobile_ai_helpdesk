import '../../../../domain/entity/customer/customer.dart';
import '../../../../domain/entity/customer/support_ticket.dart';

class CustomerDataSource {
  final List<Customer> _customers = [
    Customer(
      id: '1',
      fullName: 'Nguyễn Huy Nam',
      email: null,
      phoneNumber: '0347606025',
      zalo: null,
      messenger: null,
      tags: ['VIP'],
      segment: 'VIP',
      ticket: SupportTicket(
        id: 't1',
        title: 'Lỗi khi đăng nhập',
        status: TicketStatus.inProgress,
        priority: TicketPriority.high,
        createdAt: DateTime(2026, 3, 11),
      ),
    ),
    Customer(
      id: '2',
      fullName: 'Nguyễn Huy Tấn',
      email: 'nguyenhuytan2004@gmail.com',
      phoneNumber: '0347606022',
      zalo: null,
      messenger: null,
      tags: ['Thường xuyên'],
      segment: 'Thường xuyên',
      ticket: SupportTicket(
        id: 't2',
        title: 'Test',
        status: TicketStatus.inProgress,
        priority: TicketPriority.medium,
        createdAt: DateTime(2026, 3, 11),
      ),
    ),
    Customer(
      id: '3',
      fullName: 'Trần Thị Bích',
      email: 'bich.tran@example.com',
      phoneNumber: '0901234567',
      zalo: '0901234567',
      messenger: null,
      tags: ['Mới', 'Tiềm năng'],
      segment: 'Mới',
      ticket: null,
    ),
    Customer(
      id: '4',
      fullName: 'Lê Văn Cường',
      email: 'cuong.le@company.vn',
      phoneNumber: '0912345678',
      zalo: null,
      messenger: 'fb.me/cuongle',
      tags: ['VIP', 'Thường xuyên'],
      segment: 'VIP',
      ticket: SupportTicket(
        id: 't3',
        title: 'Yêu cầu hoàn tiền',
        status: TicketStatus.pending,
        priority: TicketPriority.high,
        createdAt: DateTime(2026, 3, 10),
      ),
    ),
    Customer(
      id: '5',
      fullName: 'Phạm Minh Đức',
      email: null,
      phoneNumber: '0978123456',
      zalo: '0978123456',
      messenger: null,
      tags: [],
      segment: null,
      isBlocked: true,
      ticket: null,
    ),
  ];

  Future<List<Customer>> getMockCustomers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_customers);
  }

  Future<void> addCustomer(Customer customer) async {
    _customers.add(customer);
  }

  Future<void> updateCustomer(Customer customer) async {
    final index = _customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) _customers[index] = customer;
  }

  Future<Customer?> mergeCustomers(String primaryId, String secondaryId) async {
    final primaryIdx = _customers.indexWhere((c) => c.id == primaryId);
    final secondaryIdx = _customers.indexWhere((c) => c.id == secondaryId);
    if (primaryIdx == -1 || secondaryIdx == -1) return null;

    final primary = _customers[primaryIdx];
    final secondary = _customers[secondaryIdx];
    final merged = primary.copyWith(
      email: primary.email ?? secondary.email,
      phoneNumber: primary.phoneNumber ?? secondary.phoneNumber,
      zalo: primary.zalo ?? secondary.zalo,
      messenger: primary.messenger ?? secondary.messenger,
      tags: {...primary.tags, ...secondary.tags}.toList(),
    );
    _customers[primaryIdx] = merged;
    _customers.removeAt(
      secondaryIdx > primaryIdx ? secondaryIdx : secondaryIdx,
    );
    return merged;
  }
}
