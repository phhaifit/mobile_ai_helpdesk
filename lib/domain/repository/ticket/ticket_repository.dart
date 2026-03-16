import 'dart:async';

import 'package:ai_helpdesk/domain/entity/agent/agent.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';

abstract class TicketRepository {
  Future<List<Ticket>> getTickets();
  Future<Ticket?> getTicketById(String id);
  Future<Ticket> createTicket(Ticket ticket);
  Future<Ticket> updateTicket(Ticket ticket);
  Future<void> deleteTicket(String id);
  Future<List<Agent>> getAvailableAgents();
}
