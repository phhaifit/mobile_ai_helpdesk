class Reaction {
  final String userId;
  final String emoji;
  final int amount;

  const Reaction({required this.userId, required this.emoji, required this.amount});

  /// Create a copy with optional fields
  Reaction copyWith({required String emoji, required int amount}) {
    return Reaction(
      userId: userId,
      emoji: emoji,
      amount: amount,
    );
  }
}
