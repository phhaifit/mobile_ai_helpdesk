import 'package:ai_helpdesk/data/models/ticket/comment_api_model.dart';
import 'package:ai_helpdesk/data/models/ticket/ticket_api_model.dart';
import 'package:ai_helpdesk/data/network/apis/ticket/ticket_api.dart';
import 'package:ai_helpdesk/data/repository/ticket/mock_ticket_repository_impl.dart';
import 'package:ai_helpdesk/domain/entity/agent/agent.dart';
import 'package:ai_helpdesk/domain/entity/comment/comment.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket_query_params.dart';
import 'package:ai_helpdesk/domain/entity/ticket_history/ticket_history.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

/// Real [TicketRepository] implementation.
///
/// **My scope** (customer history + comments) calls the real REST API via
/// [TicketApi].
///
/// **Friend's scope** (ticket list, CRUD, assignment, status) is delegated to
/// [MockTicketRepositoryImpl] until that PR lands.  Swap each delegation for a
/// real API call as the friend's implementation is merged.
class TicketRepositoryImpl implements TicketRepository {
  final TicketApi _api;
  final MockTicketRepositoryImpl _mock;

  TicketRepositoryImpl(this._api, this._mock);

  // ── My scope: Customer ticket history ──────────────────────────────────────

  @override
  Future<List<Ticket>> getCustomerHistory(String customerId) async {
    final raw = await _api.getCustomerTickets(customerId);
    return raw
        .whereType<Map<String, dynamic>>()
        .map(TicketApiModel.fromJson)
        .map((m) => m.toDomain())
        .toList();
  }

  // ── My scope: Comments ─────────────────────────────────────────────────────

  @override
  Future<List<Comment>> getComments(String ticketId) async {
    final raw = await _api.getComments(ticketId);
    return raw
        .whereType<Map<String, dynamic>>()
        .map(CommentApiModel.fromJson)
        .map((m) => m.toDomain())
        .toList();
  }

  @override
  Future<Comment> addComment({
    required String ticketId,
    required Comment comment,
  }) async {
    final data = await _api.addComment(ticketId, comment.content);

    // If the server returned a populated object, use the server-assigned id and
    // timestamp; otherwise fall back to the optimistic comment from the store.
    if (data.isNotEmpty && (data['id'] as String?)?.isNotEmpty == true) {
      final apiModel = CommentApiModel.fromJson(data);
      return comment.copyWith(
        id: apiModel.id,
        createdAt: apiModel.createdAt,
      );
    }
    // Assign a temporary id so the UI can display the comment immediately.
    return comment.copyWith(
      id: comment.id.isNotEmpty
          ? comment.id
          : 'tmp_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  // ── Friend's scope — delegated to mock ────────────────────────────────────

  @override
  Future<List<Ticket>> getTickets({
    TicketQueryParams params = const TicketQueryParams(),
  }) =>
      _mock.getTickets(params: params);

  @override
  Future<Ticket?> getTicketById(String id) => _mock.getTicketById(id);

  @override
  Future<Ticket> createTicket(Ticket ticket) => _mock.createTicket(ticket);

  @override
  Future<Ticket> updateTicket(Ticket ticket) => _mock.updateTicket(ticket);

  @override
  Future<void> deleteTicket(String id) => _mock.deleteTicket(id);

  @override
  Future<Ticket> assignAgent({required String ticketId, String? agentId}) =>
      _mock.assignAgent(ticketId: ticketId, agentId: agentId);

  @override
  Future<List<Agent>> getAvailableAgents() => _mock.getAvailableAgents();

  @override
  Future<List<TicketHistory>> getTicketHistory(String ticketId) =>
      _mock.getTicketHistory(ticketId);
}
