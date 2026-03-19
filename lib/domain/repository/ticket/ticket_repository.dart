import 'dart:async';

import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';

abstract class TicketRepository {
  Future<List<Ticket>> getTickets();
  Future<Ticket?> getTicketById(String id);
}
