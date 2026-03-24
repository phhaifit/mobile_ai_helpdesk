import 'package:flutter/material.dart';

import '/utils/locale/app_localization.dart';

/// Animated typing indicator shown while the AI is streaming a response.
class StreamingIndicator extends StatefulWidget {
  const StreamingIndicator({super.key});

  @override
  State<StreamingIndicator> createState() => _StreamingIndicatorState();
}

class _StreamingIndicatorState extends State<StreamingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => Row(
              children: List.generate(3, (i) {
                // Each dot fades in with a slight delay between them.
                final phase = ((_controller.value * 3) - i).clamp(0.0, 1.0);
                final opacity = (phase < 0.5 ? phase * 2 : (1 - phase) * 2)
                    .clamp(0.3, 1.0);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Opacity(
                    opacity: opacity,
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: colorScheme.primary,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            l.translate('playground_ai_typing'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
