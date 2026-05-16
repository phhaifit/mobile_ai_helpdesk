import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../domain/entity/chat/message.dart';
import '../../../utils/locale/app_localization.dart';

/// Composer bar showing which message the agent is replying to.
class ReplyPreviewBar extends StatelessWidget {
  const ReplyPreviewBar({
    required this.message,
    required this.onCancel,
    super.key,
  });

  final Message message;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context);
    final String label = message.isMe
        ? l.translate('chat_reply_to_self')
        : l.translate('chat_reply_to').replaceAll(
              '{name}',
              message.sender.name,
            );
    final String preview = message.content.trim().isEmpty
        ? l.translate('chat_reply_attachment')
        : message.content;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.messengerBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.messengerBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  preview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: onCancel,
            tooltip: l.translate('chat_reply_cancel'),
          ),
        ],
      ),
    );
  }
}
