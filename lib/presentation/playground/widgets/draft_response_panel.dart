import 'package:flutter/material.dart';

import '/utils/locale/app_localization.dart';

/// Shows a list of draft/suggested responses that the agent pre-generated.
/// User can apply a draft directly to the input, or dismiss the panel.
class DraftResponsePanel extends StatelessWidget {
  final List<String> drafts;
  final ValueChanged<String> onUse;
  final VoidCallback onDismiss;

  const DraftResponsePanel({
    super.key,
    required this.drafts,
    required this.onUse,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (drafts.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.secondary, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 8, right: 4),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 6),
                Text(
                  l.translate('playground_draft_responses'),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onDismiss,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...drafts.map(
            (draft) => ListTile(
              dense: true,
              title: Text(
                draft,
                style: theme.textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: TextButton(
                onPressed: () => onUse(draft),
                child: Text(l.translate('playground_use_draft')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
