class TicketHistory {
  final String id;
  final String ticketId;
  final String changedBy;
  final String changedByName;
  final String changeType;
  final String oldValue;
  final String newValue;
  final DateTime changedAt;
  final String description;

  const TicketHistory({
    required this.id,
    required this.ticketId,
    required this.changedBy,
    required this.changedByName,
    required this.changeType,
    required this.oldValue,
    required this.newValue,
    required this.changedAt,
    required this.description,
  });

  TicketHistory copyWith({
    String? id,
    String? ticketId,
    String? changedBy,
    String? changedByName,
    String? changeType,
    String? oldValue,
    String? newValue,
    DateTime? changedAt,
    String? description,
  }) {
    return TicketHistory(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      changedBy: changedBy ?? this.changedBy,
      changedByName: changedByName ?? this.changedByName,
      changeType: changeType ?? this.changeType,
      oldValue: oldValue ?? this.oldValue,
      newValue: newValue ?? this.newValue,
      changedAt: changedAt ?? this.changedAt,
      description: description ?? this.description,
    );
  }

  @override
  String toString() =>
      'TicketHistory(id: $id, ticketId: $ticketId, changeType: $changeType)';
}
