class Reaction {
  final String emoji;
  final List<String> userNames; // Users who reacted with this emoji

  const Reaction({required this.emoji, required this.userNames});

  /// Create a copy with optional fields
  Reaction copyWith({String? emoji, List<String>? userNames}) {
    return Reaction(
      emoji: emoji ?? this.emoji,
      userNames: userNames ?? this.userNames,
    );
  }
}
