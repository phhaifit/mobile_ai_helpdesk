import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/colors.dart';
import '../../../constants/dimens.dart';
import '../../../domain/entity/chat/attachment.dart';
import '../../../domain/entity/chat/message.dart';
import 'chat_avatar.dart';
import 'reaction_picker.dart';

double _bubbleMaxWidth(BuildContext context) {
  return math.min(
    Dimens.chatBubbleAbsoluteMaxWidth,
    MediaQuery.sizeOf(context).width * Dimens.chatBubbleMaxWidthFactor,
  );
}

Future<void> _openAttachmentUrl(String url) async {
  final Uri? uri = Uri.tryParse(url);
  if (uri == null) {
    return;
  }
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

class MessageBubble extends StatelessWidget {
  final Message message;

  /// True when this is the first bubble in a consecutive group from same sender.
  final bool isGroupStart;

  /// True when this is the last bubble in a consecutive group from same sender.
  final bool isGroupEnd;

  /// Show the sender's avatar (left side only, on last bubble of group).
  final bool showAvatar;

  /// Callback when a reaction is selected
  final Function(String emoji)? onReactionAdded;

  /// Whether this message is highlighted by search
  final bool isHighlighted;

  const MessageBubble({
    required this.message,
    super.key,
    this.isGroupStart = true,
    this.isGroupEnd = true,
    this.showAvatar = true,
    this.onReactionAdded,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.isMe;

    return Padding(
      padding: EdgeInsets.only(
        top: isGroupStart ? 6 : 2,
        bottom: isGroupEnd ? 8 : 0, // Extra space for reactions
      ),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar placeholder for non-me messages
          if (!isMe) _buildAvatarSlot(),

          // Bubble + metadata column
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Sender name (only for first bubble in group, others only)
                if (!isMe && isGroupStart)
                  Padding(
                    padding: const EdgeInsets.only(left: 46, bottom: 2),
                    child: Text(
                      message.sender.name,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                // Bubble row (avatar + bubble)
                Row(
                  mainAxisAlignment: isMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!isMe) ...[
                      // Show avatar or spacer
                      if (showAvatar) ChatAvatar(name: message.sender.name, avatarUrl: message.sender.avatar, size: 28) else const SizedBox(width: 30),
                      const SizedBox(width: 6),
                    ],

                    Flexible(
                      child: GestureDetector(
                        onLongPress: () => _showReactionPicker(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? AppColors.messengerBlue
                                : AppColors.bubbleGray,
                            borderRadius: _buildBorderRadius(
                              isMe,
                              isGroupStart,
                              isGroupEnd,
                            ),
                            border: isHighlighted
                                ? Border.all(
                                    color: AppColors.textPrimary,
                                    width: 2.5,
                                  )
                                : null,
                            boxShadow: isHighlighted
                                ? [
                                    BoxShadow(
                                      color: AppColors.textPrimary.withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                          child: _buildBubbleChild(context, isMe),
                        ),
                      ),
                    ),

                    if (isMe) const SizedBox(width: 8),
                  ],
                ),

                // Reactions below message
                if (message.reactions.isNotEmpty) _buildReactions(),

                // Timestamp below last bubble in group
                if (isGroupEnd)
                  Padding(
                    padding: EdgeInsets.only(
                      top: 3,
                      left: isMe ? 0 : 46,
                      right: isMe ? 8 : 0,
                    ),
                    child: Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Text(
                          _formatTime(message.timestamp),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          _buildDeliveryStatusIcon(),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubbleChild(BuildContext context, bool isMe) {
    final double maxW = _bubbleMaxWidth(context);

    if (message.attachments.isNotEmpty) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 0; i < message.attachments.length; i++) ...<Widget>[
              if (i > 0) const SizedBox(height: Dimens.spacingS),
              _buildAttachmentBody(message.attachments[i], isMe, maxW),
            ],
          ],
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxW),
      child: Text(
        message.content,
        style: TextStyle(
          color: isMe ? Colors.white : AppColors.textPrimary,
          fontSize: 15,
        ),
        softWrap: true,
        maxLines: null,
      ),
    );
  }

  Widget _buildAttachmentBody(
    Attachment attachment,
    bool isMe,
    double maxWidth,
  ) {
    final bool asImage =
        attachment.type == AttachmentType.image ||
        attachment.type == AttachmentType.sticker;

    if (asImage) {
      return GestureDetector(
        onTap: () => _openAttachmentUrl(attachment.url),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.cardBorderRadius),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: Dimens.chatBubbleImageMaxHeight,
            ),
            child: Image.network(
              attachment.url,
              fit: BoxFit.contain,
              errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
                return Container(
                  padding: const EdgeInsets.all(Dimens.spacingM),
                  color: Colors.grey.shade300,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: isMe ? Colors.white70 : AppColors.textPrimary,
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => _openAttachmentUrl(attachment.url),
      borderRadius: BorderRadius.circular(Dimens.cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: <Widget>[
            Icon(
              _iconForAttachmentType(attachment.type),
              size: Dimens.iconMedium,
              color: isMe ? Colors.white : AppColors.textPrimary,
            ),
            const SizedBox(width: Dimens.spacingS),
            Expanded(
              child: Text(
                attachment.name,
                style: TextStyle(
                  color: isMe ? Colors.white : AppColors.textPrimary,
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForAttachmentType(AttachmentType type) {
    switch (type) {
      case AttachmentType.video:
        return Icons.videocam_outlined;
      case AttachmentType.audio:
        return Icons.audiotrack_outlined;
      case AttachmentType.pdf:
        return Icons.picture_as_pdf_outlined;
      case AttachmentType.document:
        return Icons.description_outlined;
      case AttachmentType.archive:
        return Icons.folder_zip_outlined;
      case AttachmentType.image:
      case AttachmentType.sticker:
        return Icons.image_outlined;
      case AttachmentType.unknown:
        return Icons.insert_drive_file_outlined;
    }
  }

  Widget _buildAvatarSlot() {
    // Reserve space so bubbles align even when no avatar is shown
    return const SizedBox(width: 0);
  }

  BorderRadius _buildBorderRadius(
    bool isMe,
    bool isGroupStart,
    bool isGroupEnd,
  ) {
    const double full = 20;
    const double small = 5;

    if (isMe) {
      return BorderRadius.only(
        topLeft: const Radius.circular(full),
        bottomLeft: const Radius.circular(full),
        topRight: Radius.circular(isGroupStart ? full : small),
        bottomRight: Radius.circular(isGroupEnd ? full : small),
      );
    } else {
      return BorderRadius.only(
        topRight: const Radius.circular(full),
        bottomRight: const Radius.circular(full),
        topLeft: Radius.circular(isGroupStart ? full : small),
        bottomLeft: Radius.circular(isGroupEnd ? full : small),
      );
    }
  }

  String _formatTime(DateTime time) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime msgDay = DateTime(time.year, time.month, time.day);

    final String h = time.hour.toString().padLeft(2, '0');
    final String m = time.minute.toString().padLeft(2, '0');
    final String timeStr = '$h:$m';

    if (msgDay == today) return timeStr;
    return '${time.day}/${time.month} $timeStr';
  }

  Widget _buildDeliveryStatusIcon() {
    // switch (message.readStatus) {
    //   case MessageReadStatus.sent:
    //     return Tooltip(
    //       message: 'Sent',
    //       child: Icon(Icons.done, size: 14, color: Colors.grey.shade600),
    //     );
    //   case MessageReadStatus.delivered:
    //     return Tooltip(
    //       message: 'Delivered',
    //       child: Icon(Icons.done_all, size: 14, color: Colors.grey.shade600),
    //     );
    //   case MessageReadStatus.read:
    //     return const Tooltip(
    //       message: 'Read',
    //       child: Icon(Icons.done_all, size: 14, color: AppColors.messengerBlue),
    //     );
    // }

    return const SizedBox.shrink();
  }

  Widget _buildReactions() {
    return Padding(
      padding: EdgeInsets.only(
        top: 4,
        left: message.isMe ? 0 : 46,
        right: message.isMe ? 8 : 0,
      ),
      child: Wrap(
        spacing: 4,
        children: message.reactions.map((reaction) {
          return GestureDetector(
            onTap: () => onReactionAdded?.call(reaction.emoji),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${reaction.emoji} ${reaction.amount}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showReactionPicker(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx + renderBox.size.width,
        offset.dy + renderBox.size.height,
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          child: ReactionPicker(
            onReactionSelected: (String emoji) {
              onReactionAdded?.call(emoji);
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
