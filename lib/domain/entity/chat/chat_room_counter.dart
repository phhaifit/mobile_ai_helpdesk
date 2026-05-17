/// Aggregated ticket-status counts for chat rooms.
class ChatRoomCounter {
  final int open;
  final int pending;
  final int solved;
  final int closed;

  const ChatRoomCounter({
    required this.open,
    required this.pending,
    required this.solved,
    required this.closed,
  });
}
