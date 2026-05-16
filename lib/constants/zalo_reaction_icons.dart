/// Zalo reaction codes and CDN image URLs used by the Helpdesk API.
class ZaloReactionIcons {
  ZaloReactionIcons._();

  static const String cdnBase = 'https://helpdesk.jarvis.cx/images';

  static const List<ZaloReactionOption> pickerOptions = <ZaloReactionOption>[
    ZaloReactionOption(type: 'like', reactIcon: '/-like'),
    ZaloReactionOption(type: 'heart', reactIcon: '/-heart'),
    ZaloReactionOption(type: 'haha', reactIcon: '/-haha'),
    ZaloReactionOption(type: 'wow', reactIcon: '/-wow'),
    ZaloReactionOption(type: 'angry', reactIcon: '/-angry'),
  ];

  /// CDN URL: `https://helpdesk.jarvis.cx/images/zalo-{type}-emoji.png`
  static String imageUrlForType(String type) => '$cdnBase/zalo-$type-emoji.png';

  /// Resolves API `emoji` / `reactIcon` (e.g. `/-like`) to CDN [type].
  static String? typeFromReactIcon(String reactIcon) {
    final String normalized = reactIcon.trim();
    if (normalized.startsWith('/-')) {
      final String type = normalized.substring(2);
      if (_knownTypes.contains(type)) {
        return type;
      }
    }
    return _legacyReactIconToType[normalized];
  }

  static String imageUrlForReactIcon(String reactIcon) {
    final String? type = typeFromReactIcon(reactIcon);
    if (type == null) {
      return '';
    }
    return imageUrlForType(type);
  }

  static ZaloReactionOption? optionForReactIcon(String reactIcon) {
    for (final ZaloReactionOption option in pickerOptions) {
      if (option.reactIcon == reactIcon) {
        return option;
      }
    }
    final String? type = typeFromReactIcon(reactIcon);
    if (type == null) {
      return null;
    }
    return pickerOptions.firstWhere(
      (ZaloReactionOption o) => o.type == type,
      orElse: () => ZaloReactionOption(type: type, reactIcon: '/-$type'),
    );
  }

  static const Set<String> _knownTypes = <String>{
    'like',
    'heart',
    'haha',
    'wow',
    'angry',
  };

  /// Legacy API codes still present on older messages.
  static const Map<String, String> _legacyReactIconToType = <String, String>{
    '/-strong': 'like',
    '/-cry': 'angry',
  };
}

class ZaloReactionOption {
  final String type;
  final String reactIcon;

  const ZaloReactionOption({
    required this.type,
    required this.reactIcon,
  });

  String get imageUrl => ZaloReactionIcons.imageUrlForType(type);
}
