import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';

/// In-memory ticket store used by [CustomerRepositoryImpl]'s debug fallback
/// so the customer-detail timeline stays exercisable while the backend
/// ticket-history endpoint is unavailable. Seed IDs intentionally match the
/// customers seeded by `MockCustomerDataSource` (`cust_1` / `cust_2` /
/// `cust_3`).
class MockTicketDataSource {
  final List<Ticket> _tickets = [];

  MockTicketDataSource() {
    _seed();
  }

  void _seed() {
    final now = DateTime.now();
    _tickets.addAll([
      Ticket(
        id: 'tkt_1001',
        title: 'Không đăng nhập được tài khoản',
        description: '',
        status: TicketStatus.open,
        priority: TicketPriority.high,
        category: TicketCategory.technical,
        source: TicketSource.messenger,
        customerId: 'cust_1',
        customerName: 'Nguyễn Văn Anh',
        customerEmail: 'anh.nguyen@example.com',
        createdByID: '',
        createdByName: '',
        chatRoomId: 'chr_1001',
        assignedAgentId: 'agent_1',
        assignedAgentName: 'Agent Minh',
        customerSupportName: 'Agent Minh',
        createdAt: now.subtract(const Duration(days: 2, hours: 3)),
        updatedAt: now.subtract(const Duration(hours: 5)),
      ),
      Ticket(
        id: 'tkt_1002',
        title: 'Yêu cầu hoàn tiền đơn #54321',
        description: '',
        status: TicketStatus.pending,
        priority: TicketPriority.medium,
        category: TicketCategory.billing,
        source: TicketSource.zalo,
        customerId: 'cust_1',
        customerName: 'Nguyễn Văn Anh',
        customerEmail: 'anh.nguyen@example.com',
        createdByID: '',
        createdByName: '',
        chatRoomId: 'chr_1002',
        customerSupportName: 'Agent Lan',
        createdAt: now.subtract(const Duration(days: 14)),
        updatedAt: now.subtract(const Duration(days: 7)),
      ),
      Ticket(
        id: 'tkt_1003',
        title: 'Hỏi về chính sách bảo hành',
        description: '',
        status: TicketStatus.resolved,
        priority: TicketPriority.low,
        category: TicketCategory.general,
        source: TicketSource.email,
        customerId: 'cust_1',
        customerName: 'Nguyễn Văn Anh',
        customerEmail: 'anh.nguyen@example.com',
        createdByID: '',
        createdByName: '',
        chatRoomId: null,
        customerSupportName: 'Agent Minh',
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now.subtract(const Duration(days: 40)),
        resolvedAt: now.subtract(const Duration(days: 40)),
      ),
      Ticket(
        id: 'tkt_2001',
        title: 'Đặt lịch tư vấn sản phẩm',
        description: '',
        status: TicketStatus.open,
        priority: TicketPriority.medium,
        category: TicketCategory.general,
        source: TicketSource.web,
        customerId: 'cust_2',
        customerName: 'Trần Thị Hà',
        customerEmail: 'ha.tran@example.com',
        createdByID: '',
        createdByName: '',
        chatRoomId: 'chr_2001',
        customerSupportName: 'Agent Lan',
        createdAt: now.subtract(const Duration(hours: 10)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      Ticket(
        id: 'tkt_3001',
        title: 'Cập nhật thông tin liên hệ',
        description: '',
        status: TicketStatus.closed,
        priority: TicketPriority.low,
        category: TicketCategory.account,
        source: TicketSource.phone,
        customerId: 'cust_3',
        customerName: 'Lê Văn Cẩn',
        customerEmail: 'can.le@example.com',
        createdByID: '',
        createdByName: '',
        chatRoomId: null,
        customerSupportName: 'Agent Minh',
        createdAt: now.subtract(const Duration(days: 90)),
        updatedAt: now.subtract(const Duration(days: 88)),
      ),
      Ticket(
        id: 'tkt_3002',
        title: 'Báo lỗi giao hàng chậm',
        description: '',
        status: TicketStatus.resolved,
        priority: TicketPriority.high,
        category: TicketCategory.other,
        source: TicketSource.zalo,
        customerId: 'cust_3',
        customerName: 'Lê Văn Cẩn',
        customerEmail: 'can.le@example.com',
        createdByID: '',
        createdByName: '',
        chatRoomId: 'chr_3002',
        customerSupportName: 'Agent Lan',
        createdAt: now.subtract(const Duration(days: 120)),
        updatedAt: now.subtract(const Duration(days: 110)),
        resolvedAt: now.subtract(const Duration(days: 110)),
      ),
    ]);
  }

  Future<List<Ticket>> getCustomerTickets(
    String customerId, {
    int limit = 20,
    int offset = 0,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final all = _tickets.where((t) => t.customerId == customerId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (offset >= all.length) return const [];
    final end = (offset + limit).clamp(0, all.length);
    return all.sublist(offset, end);
  }

  Future<Ticket?> getTicketById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    try {
      return _tickets.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
