import 'package:json_annotation/json_annotation.dart';

part 'ticket.g.dart';

enum TicketStatus { open, inProgress, resolved }

enum TicketPriority { low, medium, high, urgent }

@JsonSerializable()
class Ticket {
  final String id;
  final String title;
  final String description;
  final TicketStatus status;
  final TicketPriority priority;
  final String customerName;
  final String channel;
  final DateTime createdAt;

  const Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.customerName,
    required this.channel,
    required this.createdAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

  Map<String, dynamic> toJson() => _$TicketToJson(this);
}
