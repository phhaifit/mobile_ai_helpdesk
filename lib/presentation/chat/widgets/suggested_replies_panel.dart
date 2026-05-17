import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../utils/locale/app_localization.dart';

class SuggestedRepliesPanel extends StatelessWidget {
  const SuggestedRepliesPanel({
    required this.isExpanded,
    required this.isLoading,
    required this.suggestion,
    required this.errorMessage,
    required this.onRegenerate,
    required this.onToggleExpanded,
    required this.onDismissSuggestion,
    required this.onApplySuggestion,
    super.key,
  });

  final bool isExpanded;
  final bool isLoading;
  final String? suggestion;
  final String? errorMessage;
  final VoidCallback onRegenerate;
  final VoidCallback onToggleExpanded;
  final VoidCallback onDismissSuggestion;
  final ValueChanged<String> onApplySuggestion;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    if (!isLoading && suggestion == null && errorMessage == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.translate('chat_suggested_replies'),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l.translate('chat_regenerate_tooltip'),
                  icon: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh_rounded, size: 20),
                  onPressed: isLoading ? null : onRegenerate,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  tooltip: isExpanded
                      ? l.translate('chat_collapse_panel')
                      : l.translate('chat_expand_panel'),
                  icon: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                  ),
                  onPressed: onToggleExpanded,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            if (isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    l.translate('chat_thinking'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.messengerBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            else if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  errorMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              )
            else if (suggestion != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Material(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => onApplySuggestion(suggestion!),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              suggestion!,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: onDismissSuggestion,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
