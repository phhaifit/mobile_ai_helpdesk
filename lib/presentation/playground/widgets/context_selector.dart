import 'package:flutter/material.dart';

import '/domain/entity/playground/playground_session.dart';
import '/utils/locale/app_localization.dart';

class ContextSelector extends StatelessWidget {
  final PlaygroundContextType selected;
  final ValueChanged<PlaygroundContextType> onChanged;

  const ContextSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SegmentedButton<PlaygroundContextType>(
      segments: [
        ButtonSegment(
          value: PlaygroundContextType.lazada,
          icon: const Icon(Icons.shopping_bag_outlined, size: 18),
          label: Text(l.translate('playground_context_lazada')),
        ),
        ButtonSegment(
          value: PlaygroundContextType.normal,
          icon: const Icon(Icons.support_agent_outlined, size: 18),
          label: Text(l.translate('playground_context_normal')),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (v) => onChanged(v.first),
    );
  }
}
