import 'user.dart';

class Reaction {
  final String id;
  final User user;
  final String emoji;
  final int amount;

  const Reaction({
    required this.id,
    required this.user,
    required this.emoji,
    required this.amount,
  });

  Reaction copyWith({
    String? id,
    User? user,
    String? emoji,
    int? amount,
  }) {
    return Reaction(
      id: id ?? this.id,
      user: user ?? this.user,
      emoji: emoji ?? this.emoji,
      amount: amount ?? this.amount,
    );
  }
}
