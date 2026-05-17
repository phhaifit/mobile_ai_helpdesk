import 'package:ai_helpdesk/domain/entity/comment/comment.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';

final kTestDate = DateTime(2024, 6, 1, 10, 0);
const kTestCustomerId = 'cust-001';
const kTestTicketId = 'ticket-001';
const kTestAuthorId = 'agent-001';

/// A minimal but fully-populated Ticket domain entity.
final kTestTicket = Ticket(
  id: kTestTicketId,
  title: 'Login issue',
  description: 'Cannot log in',
  status: TicketStatus.open,
  priority: TicketPriority.high,
  category: TicketCategory.technical,
  source: TicketSource.web,
  customerId: kTestCustomerId,
  customerName: 'Nguyen Van A',
  customerEmail: 'a@example.com',
  createdByID: kTestAuthorId,
  createdByName: 'Agent 1',
  createdAt: kTestDate,
  updatedAt: kTestDate,
);

final kTestTicket2 = Ticket(
  id: 'ticket-002',
  title: 'Payment failed',
  description: 'Card declined',
  status: TicketStatus.resolved,
  priority: TicketPriority.medium,
  category: TicketCategory.billing,
  source: TicketSource.email,
  customerId: kTestCustomerId,
  customerName: 'Nguyen Van A',
  customerEmail: 'a@example.com',
  createdByID: kTestAuthorId,
  createdByName: 'Agent 1',
  createdAt: kTestDate,
  updatedAt: kTestDate,
);

final kTestComment = Comment(
  id: 'cmt-001',
  ticketId: kTestTicketId,
  authorId: kTestAuthorId,
  authorName: 'Agent 1',
  content: 'Looking into this now.',
  type: CommentType.public,
  createdAt: kTestDate,
);

final kTestComment2 = Comment(
  id: 'cmt-002',
  ticketId: kTestTicketId,
  authorId: kTestAuthorId,
  authorName: 'Agent 1',
  content: 'Issue escalated.',
  type: CommentType.internal,
  createdAt: kTestDate.add(const Duration(minutes: 5)),
);

/// Raw JSON as returned by GET /api/ticket/customer-ticket
final kApiTicketJson = <String, dynamic>{
  'id': kTestTicketId,
  'title': 'Login issue',
  'status': 'open',
  'priority': 'high',
  'customerId': kTestCustomerId,
  'channelType': 'web',
  'createdAt': '2024-06-01T10:00:00.000Z',
  'updatedAt': '2024-06-01T10:00:00.000Z',
};

/// Raw JSON as returned by GET /api/ticket/comment/get-comment/{id}
final kApiCommentJson = <String, dynamic>{
  'id': 'cmt-001',
  'ticketId': kTestTicketId,
  'content': 'Looking into this now.',
  'authorId': kTestAuthorId,
  'authorName': 'Agent 1',
  'createdAt': '2024-06-01T10:00:00.000Z',
};

/// Server response after POST /api/ticket/comment/add-comment
final kApiAddCommentResponse = <String, dynamic>{
  'id': 'cmt-server-001',
  'ticketId': kTestTicketId,
  'content': 'Looking into this now.',
  'authorId': kTestAuthorId,
  'authorName': 'Agent 1',
  'createdAt': '2024-06-01T10:00:00.000Z',
};

/// WebSocket event payload for a new comment
String kWsNewCommentEvent(String commentId) => '''
{
  "event": "new_comment",
  "data": {
    "id": "$commentId",
    "ticketId": "$kTestTicketId",
    "content": "Real-time update",
    "authorId": "$kTestAuthorId",
    "authorName": "Agent 1",
    "createdAt": "2024-06-01T10:05:00.000Z"
  }
}
''';
