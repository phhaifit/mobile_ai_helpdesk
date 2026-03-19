// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  status: $enumDecode(_$TicketStatusEnumMap, json['status']),
  priority: $enumDecode(_$TicketPriorityEnumMap, json['priority']),
  customerName: json['customerName'] as String,
  channel: json['channel'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'status': _$TicketStatusEnumMap[instance.status]!,
  'priority': _$TicketPriorityEnumMap[instance.priority]!,
  'customerName': instance.customerName,
  'channel': instance.channel,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$TicketStatusEnumMap = {
  TicketStatus.open: 'open',
  TicketStatus.inProgress: 'inProgress',
  TicketStatus.resolved: 'resolved',
};

const _$TicketPriorityEnumMap = {
  TicketPriority.low: 'low',
  TicketPriority.medium: 'medium',
  TicketPriority.high: 'high',
  TicketPriority.urgent: 'urgent',
};
