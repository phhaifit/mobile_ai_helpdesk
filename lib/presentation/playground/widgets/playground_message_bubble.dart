import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '/constants/colors.dart';
import '/domain/entity/playground/playground_message.dart';

/// A single message bubble in the playground chat.
class PlaygroundMessageBubble extends StatelessWidget {
  final PlaygroundMessage message;
  final VoidCallback? onEdit;

  const PlaygroundMessageBubble({
    super.key,
    required this.message,
    this.onEdit,
  });

  bool get _isUser => message.role == MessageRole.user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment:
            _isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!_isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.primaryContainer,
              child: const Icon(Icons.psychology, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: _isUser ? onEdit : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _isUser
                      ? colorScheme.primary
                      : AppColors.bubbleGray,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(_isUser ? 18 : 4),
                    bottomRight: Radius.circular(_isUser ? 4 : 18),
                  ),
                ),
                child: _isUser
                    ? _UserContent(message: message)
                    : _AiContent(message: message),
              ),
            ),
          ),
          if (_isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.secondaryContainer,
              child: const Icon(Icons.person, size: 18),
            ),
          ],
        ],
      ),
    );
  }
}

class _UserContent extends StatelessWidget {
  final PlaygroundMessage message;

  const _UserContent({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          message.content,
          style: TextStyle(color: colorScheme.onPrimary),
        ),
        if (message.attachments.isNotEmpty) ...[
          const SizedBox(height: 6),
          Wrap(
            spacing: 4,
            children: message.attachments
                .map(
                  (a) => Chip(
                    avatar: const Icon(Icons.attach_file, size: 14),
                    label: Text(
                      a.split('/').last,
                      style: const TextStyle(fontSize: 11),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _AiContent extends StatelessWidget {
  final PlaygroundMessage message;

  const _AiContent({required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.content.isEmpty) {
      // Placeholder for streaming — parent uses StreamingIndicator instead.
      return const SizedBox.shrink();
    }
    return MarkdownBody(
      data: message.content,
      styleSheet: MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
        ),
        code: const TextStyle(
          fontFamily: 'monospace',
          backgroundColor: Color(0xFFE8E8E8),
          fontSize: 12,
        ),
      ),
    );
  }
}
