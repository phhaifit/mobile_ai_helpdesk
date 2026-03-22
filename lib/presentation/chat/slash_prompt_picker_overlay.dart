// Widget tree (documentation):
// Material (elevation + clip)
//   └─ ConstrainedBox (maxHeight)
//        ├─ Padding → Text (header / empty state)
//        └─ Expanded → ListView.separated
//             └─ ListTile (title, subtitle usage) → onTap
import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';

class SlashPromptPickerOverlay extends StatelessWidget {
  const SlashPromptPickerOverlay({
    required this.prompts,
    required this.onSelected,
    super.key,
  });

  final List<Prompt> prompts;
  final ValueChanged<Prompt> onSelected;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 6,
      color: scheme.surfaceContainerHigh,
      child: prompts.isEmpty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l.translate('prompt_tv_slash_header'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.translate('prompt_tv_slash_empty'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : SizedBox(
              height: 220,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                    child: Text(
                      l.translate('prompt_tv_slash_header'),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 8),
                      itemCount: prompts.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final p = prompts[index];
                        return ListTile(
                          dense: true,
                          title: Text(
                            p.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            l.translate('prompt_tv_used_times').replaceFirst(
                                  '%s',
                                  '${p.usageCount}',
                                ),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          onTap: () => onSelected(p),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
