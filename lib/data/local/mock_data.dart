import '../../domain/entity/agent/agent.dart';
import '../../domain/entity/comment/comment.dart';
import '../../domain/entity/customer/customer.dart';
import '../../domain/entity/enums.dart';
import '../../domain/entity/ticket/ticket.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class MockDataGenerator {
  // Vietnamese first names
  static const List<String> vietnameseFirstNames = [
    'Nguyễn', 'Trần', 'Phạm', 'Hoàng', 'Phan', 'Vũ', 'Đặng', 'Bùi', 'Đỗ', 'Hồ',
    'Dương', 'Đào', 'Lý', 'Tô', 'Tạ', 'Cao', 'Đinh', 'Thái', 'Lê', 'Mạc',
  ];

  // Vietnamese last names
  static const List<String> vietnameseLastNames = [
    'An', 'Ánh', 'Anh', 'Bằng', 'Bình', 'Công', 'Duy', 'Đức', 'Giang',
    'Hạ', 'Hải', 'Hương', 'Hưởng', 'Khánh', 'Kiên', 'Linh', 'Liên',
    'Long', 'Lợi', 'Minh', 'Mộng', 'Mục', 'Mỹ', 'Na', 'Nam', 'Nhi',
    'Niên', 'Nơi', 'Oanh', 'Phương', 'Quân', 'Quốc', 'Rồng', 'Sâm', 'Sơn',
    'Tài', 'Tâm', 'Thi', 'Thắng', 'Thảo', 'Thị', 'Thịnh', 'Thôi', 'Thu',
    'Thuận', 'Thuỷ', 'Thúy', 'Tiến', 'Tịnh', 'Tố', 'Tôi', 'Tú', 'Tuấn',
    'Tuyên', 'Tuyến', 'Tuyết', 'Uyên', 'Uyển', 'Vân', 'Vệ', 'Việt', 'Vĩ',
    'Vũ', 'Vũng', 'Xanh', 'Xuân', 'Xương', 'Yến', 'Yêu', 'Ý', 'Ân',
  ];

  // Ticket title templates
  static const List<String> ticketTitles = [
    'Không thể đăng nhập vào tài khoản',
    'Yêu cầu cập nhật thông tin cá nhân',
    'Vấn đề thanh toán đơn hàng',
    'Lỗi khi tải dữ liệu',
    'Cần hỗ trợ kỹ thuật ngay',
    'Hoàn tiền cho giao dịch thất bại',
    'Không nhận được xác thực qua email',
    'Cần thay đổi mật khẩu',
    'Lỗi kết nối máy chủ',
    'Yêu cầu tạo tài khoản mới',
    'Không thể xoá tài khoản',
    'Lỗi hiển thị giao diện',
    'Vấn đề với ứng dụng mobile',
    'Cần báo cáo vấn đề',
    'Yêu cầu hỗ trợ vé hỗ trợ',
  ];

  // Description templates
  static const List<String> descriptionTemplates = [
    'Tôi đang gặp vấn đề khi cố gắng truy cập tài khoản của mình. Lỗi thường xuyên xuất hiện sau khi tôi nhập thông tin đăng nhập.',
    'Cần cập nhật địa chỉ và số điện thoại trong hồ sơ cá nhân của tôi.',
    'Tôi đã thực hiện thanh toán nhưng tiền chưa được ghi nhận trong hệ thống.',
    'Ứng dụng bị giật và tải chậm khi sử dụng trên máy tính của tôi.',
    'Cần hỗ trợ khẩn cấp - không thể hoàn thành giao dịch quan trọng.',
    'Đã thanh toán nhưng không nhận được xác nhận. Vui lòng kiểm tra và hoàn lại tiền.',
    'Tôi không nhận được email xác thực từ hệ thống sau khi đăng ký.',
    'Muốn thay đổi mật khẩu nhưng quên mật khẩu cũ.',
    'Khi cố kết nối, tôi luôn nhận được thông báo lỗi máy chủ.',
    'Muốn tạo một tài khoản mới cho toàn bộ gia đình của tôi.',
  ];

  // Departments
  static const List<String> departments = [
    'Hỗ trợ Kỹ thuật',
    'Phòng Bán hàng',
    'Dịch vụ Khách hàng',
    'Bộ phận Tài chính',
    'Hỗ trợ Thanh toán',
  ];

  /// Generate list of mock agents
  static List<Agent> generateAgents() {
    final agents = <Agent>[];
    const agentCount = 8;

    for (int i = 0; i < agentCount; i++) {
      final firstName = vietnameseFirstNames[i % vietnameseFirstNames.length];
      final lastName = vietnameseLastNames[i % vietnameseLastNames.length];
      final name = '$firstName $lastName';

      agents.add(Agent(
        id: 'agent_${i + 1}',
        name: name,
        email: 'agent${i + 1}@helpdesk.com',
        avatar: 'https://i.pravatar.cc/150?img=${i + 1}',
        department: departments[i % departments.length],
        isActive: i < 6, // 6 out of 8 are active
        createdAt: DateTime.now().subtract(Duration(days: 360 - (i * 30))),
      ));
    }

    return agents;
  }

  /// Generate list of mock customers
  static List<Customer> generateCustomers() {
    final customers = <Customer>[];
    const customerCount = 15;
    final companies = [
      'Công ty Cổ phần Công nghệ XYZ',
      'Doanh nghiệp Tư nhân ABC',
      'Tập đoàn Thương mại VietName',
      'Công ty TNHH Đa nước ngoài',
      'Công ty Cổ phần Viễn thông',
      'Doanh nghiệp Nhà nước',
      'Công ty Cổ phần Bất động sản',
      'Tập đoàn Thương mại Quốc tế',
      'Công ty Cổ phần Tài chính',
      'Doanh nghiệp Gia đình',
    ];

    for (int i = 0; i < customerCount; i++) {
      final firstName = vietnameseFirstNames[i % vietnameseFirstNames.length];
      final lastName = vietnameseLastNames[i % vietnameseLastNames.length];
      final fullName = '$firstName $lastName';

      customers.add(Customer(
        id: 'cust_${i + 1}',
        fullName: fullName,
        email: 'customer${i + 1}@example.com',
        phone: '0${9 + (i % 8)}${String.fromCharCodes(List.generate(8, (index) => 48 + (i + index) % 10))}',
        company: i % 3 == 0 ? companies[i % companies.length] : null,
        createdAt: DateTime.now().subtract(Duration(days: 730 - (i * 40))),
        lastContactedAt: DateTime.now().subtract(Duration(days: i % 30)),
        totalTickets: 2 + (i % 8),
      ));
    }

    return customers;
  }

  /// Generate list of mock tickets
  static List<Ticket> generateTickets(
    List<Agent> agents,
    List<Customer> customers,
  ) {
    final tickets = <Ticket>[];
    const ticketCount = 50;

    for (int i = 0; i < ticketCount; i++) {
      final customer = customers[i % customers.length];
      final statusValues = TicketStatus.values;
      final priorityValues = TicketPriority.values;
      final categoryValues = TicketCategory.values;
      final sourceValues = TicketSource.values;

      // Assign agent to some tickets (75%)
      Agent? assignedAgent;
      if (i % 4 != 0) {
        assignedAgent = agents[i % agents.length];
      }

      final createdDate =
          DateTime.now().subtract(Duration(hours: 300 - (i * 5)));
      final updatedDate = createdDate.add(Duration(hours: i % 20));
      final isResolved = i % 3 == 0;
      final resolvedDate = isResolved
          ? updatedDate.add(Duration(hours: 2 + (i % 8)))
          : null;

      tickets.add(Ticket(
        id: 'TKT-${String.fromCharCodes(List.generate(6, (ind) => 48 + ((i + ind) % 10)))}',
        title: ticketTitles[i % ticketTitles.length],
        description: descriptionTemplates[i % descriptionTemplates.length],
        status: statusValues[i % statusValues.length],
        priority: priorityValues[i % priorityValues.length],
        category: categoryValues[i % categoryValues.length],
        source: sourceValues[i % sourceValues.length],
        createdByID: agents[i % agents.length].id,
        createdByName: agents[i % agents.length].name,
        customerId: customer.id,
        customerName: customer.fullName,
        customerEmail: customer.email,
        assignedAgentId: assignedAgent?.id,
        assignedAgentName: assignedAgent?.name,
        createdAt: createdDate,
        updatedAt: updatedDate,
        resolvedAt: resolvedDate,
        notes: i % 5 == 0 ? 'Ghi chú nội bộ: Khách hàng VIP cần ưu tiên' : null,
        attachments: i % 4 == 0 ? ['file_${i}_1.pdf', 'screenshot_${i}.png'] : [],
        unreadCount: (i % 7) > 0 ? i % 7 : 0,
      ));
    }

    return tickets;
  }

  /// Generate comments for a ticket (optional)
  static List<Comment> generateCommentsForTicket(
    String ticketId,
    List<Agent> agents,
  ) {
    final comments = <Comment>[];
    const commentCount = 3;

    for (int i = 0; i < commentCount; i++) {
      final agent = agents[i % agents.length];
      final isPublic = i % 2 == 0;

      comments.add(Comment(
        id: uuid.v4(),
        ticketId: ticketId,
        authorId: agent.id,
        authorName: agent.name,
        authorAvatar: agent.avatar,
        content:
            'Đây là bình luận từ agent về vấn đề của khách hàng. Tôi đang kiểm tra và sẽ cập nhật sớm.',
        type: isPublic ? CommentType.public : CommentType.internal,
        createdAt: DateTime.now().subtract(Duration(hours: commentCount - i)),
      ));
    }

    return comments;
  }
}
