import 'package:ai_helpdesk/data/models/ticket/comment_api_model.dart';
import 'package:ai_helpdesk/data/models/ticket/ticket_api_model.dart';
import 'package:ai_helpdesk/data/network/apis/chat_room/chat_room_api.dart';
import 'package:ai_helpdesk/data/network/apis/ticket/ticket_api.dart';
import 'package:ai_helpdesk/data/repository/ticket/mock_ticket_repository_impl.dart';
import 'package:ai_helpdesk/domain/entity/agent/agent.dart';
import 'package:ai_helpdesk/domain/entity/comment/comment.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket_query_params.dart';
import 'package:ai_helpdesk/domain/entity/ticket_history/ticket_history.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketApi _ticketApi;
  final ChatRoomApi _chatRoomApi;
  final MockTicketRepositoryImpl _mock;

  TicketRepositoryImpl(this._ticketApi, this._chatRoomApi, this._mock);

  // ── Customer ticket history ────────────────────────────────────────────────

  @override
  Future<List<Ticket>> getCustomerHistory(String customerId) async {
    final raw = await _ticketApi.getCustomerHistory(customerId);
    return raw
        .whereType<Map<String, dynamic>>()
        .map(TicketApiModel.fromJson)
        .map((m) => m.toDomain())
        .toList();
  }

  // ── Chat-room messages (surfaced as "comments") ────────────────────────────

  @override
  Future<List<Comment>> getComments(String ticketId) async {
    try {
      final ticketData = await _ticketApi.getTicketDetail(ticketId);
      final chatRoomId = ticketData['chatRoomId'] as String?;
      if (chatRoomId == null || chatRoomId.isEmpty) return const [];

      final raw = await _chatRoomApi.getMessages(chatRoomId);
      return raw
          .whereType<Map<String, dynamic>>()
          .map(CommentApiModel.fromJson)
          .map((m) => m.toDomain())
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<Comment> addComment({
    required String ticketId,
    required Comment comment,
  }) async {
    try {
      final ticketData = await _ticketApi.getTicketDetail(ticketId);
      final chatRoomId = ticketData['chatRoomId'] as String?;
      if (chatRoomId == null || chatRoomId.isEmpty) {
        return _optimisticComment(comment);
      }

      final detail = await _chatRoomApi.getChatRoomDetail(chatRoomId);
      final lastMessage = detail['lastMessage'] as Map?;
      final channelId = lastMessage?['channelID'] as String? ?? '';
      final contactId = lastMessage?['contactID'] as String?;

      if (channelId.isEmpty) return _optimisticComment(comment);

      final data = await _chatRoomApi.sendMessage(
        chatRoomId: chatRoomId,
        channelId: channelId,
        content: comment.content,
        contactId: contactId,
      );

      if (data.isNotEmpty) {
        final model = CommentApiModel.fromJson(data);
        return comment.copyWith(id: model.id, createdAt: model.createdAt);
      }
      return _optimisticComment(comment);
    } catch (_) {
      return _optimisticComment(comment);
    }
  }

  Comment _optimisticComment(Comment comment) => comment.copyWith(
        id: comment.id.isNotEmpty
            ? comment.id
            : 'tmp_${DateTime.now().millisecondsSinceEpoch}',
      );

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
