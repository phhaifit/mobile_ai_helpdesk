import 'package:ai_helpdesk/data/network/dto/ticket/ticket_dto.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TicketDto.toEntity', () {
    test('maps required fields and preserves chatRoomId + customerSupportName', () {
      final dto = TicketDto.fromJson({
        'id': 'tkt_1',
        'title': 'Đăng nhập lỗi',
        'status': 'open',
        'priority': 'high',
        'assigneeId': 'agent_1',
        'customerId': 'cust_1',
        'chatRoomId': 'chr_1',
        'channelType': 'messenger',
        'customerSupportName': 'Agent Minh',
        'createdAt': '2026-01-15T10:30:00.000Z',
        'updatedAt': '2026-01-15T11:00:00.000Z',
      });

      final ticket = dto.toEntity();

      expect(ticket.id, 'tkt_1');
      expect(ticket.title, 'Đăng nhập lỗi');
      expect(ticket.status, TicketStatus.open);
      expect(ticket.priority, TicketPriority.high);
      expect(ticket.source, TicketSource.messenger);
      expect(ticket.customerId, 'cust_1');
      expect(ticket.chatRoomId, 'chr_1');
      expect(ticket.assignedAgentId, 'agent_1');
      expect(ticket.customerSupportName, 'Agent Minh');
    });

    test('maps backend status "solved" to mobile TicketStatus.resolved', () {
      final dto = TicketDto.fromJson({'id': '1', 'status': 'solved'});
      expect(dto.toEntity().status, TicketStatus.resolved);
    });

    test('falls back to TicketSource.web for unknown channelType', () {
      final dto = TicketDto.fromJson({'id': '1', 'channelType': 'lazada'});
      expect(dto.toEntity().source, TicketSource.web);
    });

    test('injects customerName / customerEmail from context when provided', () {
      final dto = TicketDto.fromJson({'id': '1'});
      final ticket = dto.toEntity(
        customerName: 'Nguyễn Văn A',
        customerEmail: 'a@example.com',
      );
      expect(ticket.customerName, 'Nguyễn Văn A');
      expect(ticket.customerEmail, 'a@example.com');
    });
  });
}
