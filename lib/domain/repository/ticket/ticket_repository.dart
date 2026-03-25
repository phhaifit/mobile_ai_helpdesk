import 'dart:async';

import 'package:ai_helpdesk/domain/entity/agent/agent.dart';
import 'package:ai_helpdesk/domain/entity/comment/comment.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket_query_params.dart';
import 'package:ai_helpdesk/domain/entity/ticket_history/ticket_history.dart';

abstract class TicketRepository {
  Future<List<Ticket>> getTickets({TicketQueryParams params = const TicketQueryParams()});
  Future<Ticket?> getTicketById(String id);
  Future<Ticket> createTicket(Ticket ticket);
  Future<Ticket> updateTicket(Ticket ticket);
  Future<void> deleteTicket(String id);
  Future<Ticket> assignAgent({required String ticketId, String? agentId});
  Future<Comment> addComment({required String ticketId, required Comment comment});
  Future<List<Comment>> getComments(String ticketId);
  Future<List<Ticket>> getCustomerHistory(String customerId);
  Future<List<Agent>> getAvailableAgents();
  Future<List<TicketHistory>> getTicketHistory(String ticketId);
}
