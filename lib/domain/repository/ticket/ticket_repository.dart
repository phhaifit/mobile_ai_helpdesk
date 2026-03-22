import 'dart:async';

import '/domain/entity/ticket/ticket.dart';

abstract class TicketRepository {
  Future<List<Ticket>> getTickets();
  Future<Ticket?> getTicketById(String id);
}
