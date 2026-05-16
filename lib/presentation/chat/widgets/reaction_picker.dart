import 'package:flutter/material.dart';

import '../../../constants/dimens.dart';
import '../../../constants/zalo_reaction_icons.dart';

/// Horizontal picker for Zalo reactions; emits API codes like `/-like`.
class ReactionPicker extends StatelessWidget {
  const ReactionPicker({
    required this.onReactionSelected,
    super.key,
  });

  /// Called with Zalo `reactIcon` / `emoji` value (e.g. `/-heart`).
  final ValueChanged<String> onReactionSelected;

  static const double _itemSize = 40;
  static const double _imageSize = 32;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.spacingM,
        vertical: Dimens.spacingS,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Wrap(
        spacing: Dimens.spacingS,
        runSpacing: Dimens.spacingXs,
        alignment: WrapAlignment.center,
        children: ZaloReactionIcons.pickerOptions.map(_buildReactionTap).toList(),
      ),
    );
  }

  Widget _buildReactionTap(ZaloReactionOption option) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onReactionSelected(option.reactIcon),
        borderRadius: BorderRadius.circular(_itemSize / 2),
        child: SizedBox(
          width: _itemSize,
          height: _itemSize,
          child: Center(
            child: ZaloReactionImage(
              reactIcon: option.reactIcon,
              size: _imageSize,
            ),
          ),
        ),
      ),
    );
  }
}

/// Renders a Zalo reaction from CDN by [reactIcon] (`/-like`, `/-heart`, …).
class ZaloReactionImage extends StatelessWidget {
  const ZaloReactionImage({
    required this.reactIcon,
    this.size = 24,
    super.key,
  });

  final String reactIcon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final String url = ZaloReactionIcons.imageUrlForReactIcon(reactIcon);
    if (url.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: Icon(Icons.emoji_emotions_outlined, size: size * 0.85),
      );
    }

    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
        return Icon(Icons.emoji_emotions_outlined, size: size * 0.85);
      },
    );
  }
}
