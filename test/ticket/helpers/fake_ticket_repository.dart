import 'package:ai_helpdesk/domain/entity/agent/agent.dart';
import 'package:ai_helpdesk/domain/entity/comment/comment.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket_query_params.dart';
import 'package:ai_helpdesk/domain/entity/ticket_history/ticket_history.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

/// Configurable fake used by use-case and store tests.
/// Set [xxxToReturn] before each test; inspect [capturedXxx] to verify calls.
class FakeTicketRepository implements TicketRepository {
  // --- configurable return values ---
  List<Ticket> customerHistoryToReturn = [];
  List<Comment> commentsToReturn = [];
  Comment? addCommentResult;
  List<Ticket> ticketsToReturn = [];
  Ticket? ticketByIdResult;

  // --- captured arguments ---
  String? capturedCustomerHistoryId;
  String? capturedGetCommentsTicketId;
  String? capturedAddCommentTicketId;
  Comment? capturedAddComment;

  @override
  Future<List<Ticket>> getCustomerHistory(String customerId) async {
    capturedCustomerHistoryId = customerId;
    return customerHistoryToReturn;
  }

  @override
  Future<List<Comment>> getComments(String ticketId) async {
    capturedGetCommentsTicketId = ticketId;
    return commentsToReturn;
  }

  @override
  Future<Comment> addComment({
    required String ticketId,
    required Comment comment,
  }) async {
    capturedAddCommentTicketId = ticketId;
    capturedAddComment = comment;
    return addCommentResult ?? comment;
  }

  // --- stubs for the rest of the interface (not under test here) ---

  @override
  Future<List<Ticket>> getTickets({
    TicketQueryParams params = const TicketQueryParams(),
  }) async => ticketsToReturn;

  @override
  Future<Ticket?> getTicketById(String id) async => ticketByIdResult;

  @override
  Future<Ticket> createTicket(Ticket ticket) async => ticket;

  @override
  Future<Ticket> updateTicket(Ticket ticket) async => ticket;

  @override
  Future<void> deleteTicket(String id) async {}

  @override
  Future<Ticket> assignAgent({
    required String ticketId,
    String? agentId,
  }) async =>
      ticketsToReturn.firstWhere((t) => t.id == ticketId);

  @override
  Future<List<Agent>> getAvailableAgents() async => [];

  @override
  Future<List<TicketHistory>> getTicketHistory(String ticketId) async => [];
}
