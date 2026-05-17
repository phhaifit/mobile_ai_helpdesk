/// Zalo reaction codes and CDN image URLs used by the Helpdesk API.
class ZaloReactionIcons {
  ZaloReactionIcons._();

  static const String cdnBase = 'https://helpdesk.jarvis.cx/images';

  /// Values accepted by `reactIcon` when calling the react message API.
  static const Set<String> apiReactIcons = <String>{
    '/-strong',
    '/-heart',
    ':>',
    ':o',
    ':-((',
    ':-h',
  };

  static const List<ZaloReactionOption> pickerOptions = <ZaloReactionOption>[
    ZaloReactionOption(type: 'like', reactIcon: '/-strong'),
    ZaloReactionOption(type: 'heart', reactIcon: '/-heart'),
    ZaloReactionOption(type: 'haha', reactIcon: ':>'),
    ZaloReactionOption(type: 'wow', reactIcon: ':o'),
    ZaloReactionOption(type: 'sad', reactIcon: ':-(('),
    ZaloReactionOption(type: 'angry', reactIcon: ':-h'),
  ];

  /// CDN URL: `https://helpdesk.jarvis.cx/images/zalo-{type}-emoji.png`
  static String imageUrlForType(String type) => '$cdnBase/zalo-$type-emoji.png';

  /// Returns the API `reactIcon` for the given value, mapping legacy codes when needed.
  static String normalizeReactIcon(String reactIcon) {
    final String normalized = reactIcon.trim();
    if (apiReactIcons.contains(normalized)) {
      return normalized;
    }
    return _legacyReactIconToApi[normalized] ?? normalized;
  }

  /// Resolves API `emoji` / `reactIcon` to CDN [type] for image display.
  static String? typeFromReactIcon(String reactIcon) {
    final String normalized = normalizeReactIcon(reactIcon);
    final String? fromMap = _reactIconToCdnType[normalized];
    if (fromMap != null) {
      return fromMap;
    }
    if (normalized.startsWith('/-')) {
      final String type = normalized.substring(2);
      if (_knownCdnTypes.contains(type)) {
        return type;
      }
    }
    return null;
  }

  static String imageUrlForReactIcon(String reactIcon) {
    final String? type = typeFromReactIcon(reactIcon);
    if (type == null) {
      return '';
    }
    return imageUrlForType(type);
  }

  static ZaloReactionOption? optionForReactIcon(String reactIcon) {
    final String normalized = normalizeReactIcon(reactIcon);
    for (final ZaloReactionOption option in pickerOptions) {
      if (option.reactIcon == normalized) {
        return option;
      }
    }
    final String? type = typeFromReactIcon(normalized);
    if (type == null) {
      return null;
    }
    return pickerOptions.firstWhere(
      (ZaloReactionOption o) => o.type == type,
      orElse: () => ZaloReactionOption(type: type, reactIcon: normalized),
    );
  }

  static const Set<String> _knownCdnTypes = <String>{
    'like',
    'heart',
    'haha',
    'wow',
    'sad',
    'angry',
  };

  /// Maps API [reactIcon] to CDN filename segment (`zalo-{type}-emoji.png`).
  static const Map<String, String> _reactIconToCdnType = <String, String>{
    '/-strong': 'like',
    '/-heart': 'heart',
    ':>': 'haha',
    ':o': 'wow',
    ':-((': 'sad',
    ':-h': 'angry',
  };

  /// Older clients / messages may still use these codes.
  static const Map<String, String> _legacyReactIconToApi = <String, String>{
    '/-like': '/-strong',
    '/-string': '/-strong',
    '/-haha': ':>',
    '/-wow': ':o',
    '/-cry': ':-((',
    '/-angry': ':-h',
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
