import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/colors.dart';
import '../../../constants/dimens.dart';
import '../../../domain/entity/chat/attachment.dart';
import '../../../domain/entity/chat/message.dart';
import '../../../domain/entity/chat/message_reply_preview.dart';
import '../../../utils/locale/app_localization.dart';
import 'chat_avatar.dart';
import 'reaction_picker.dart';

const double _replyQuoteBorderRadius = 8;

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

bool _isVisualMedia(Attachment attachment) {
  return attachment.type == AttachmentType.image ||
      attachment.type == AttachmentType.sticker;
}

bool _messageIsVisualMediaOnly(Message message) {
  if (message.attachments.isEmpty) return false;
  return message.attachments.every(_isVisualMedia);
}

class MessageBubble extends StatelessWidget {
  final Message message;

  /// True when this is the first bubble in a consecutive group from same sender.
  final bool isGroupStart;

  /// True when this is the last bubble in a consecutive group from same sender.
  final bool isGroupEnd;

  /// Show the sender's avatar (left side only, on last bubble of group).
  final bool showAvatar;

  /// Zalo reaction selected (`reactIcon` code, e.g. `/-strong`).
  final ValueChanged<String>? onZaloReactionSelected;

  final VoidCallback? onReply;

  /// Whether this message is highlighted by search
  final bool isHighlighted;

  const MessageBubble({
    required this.message,
    super.key,
    this.isGroupStart = true,
    this.isGroupEnd = true,
    this.showAvatar = true,
    this.onZaloReactionSelected,
    this.onReply,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.isMe;
    final double maxBubbleWidth = _bubbleMaxWidth(context);

    return Padding(
      padding: EdgeInsets.only(
        top: isGroupStart ? 6 : 2,
        bottom: isGroupEnd ? 8 : 0, // Extra space for reactions
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          if (message.replyPreview != null)
            Padding(
              padding: EdgeInsets.only(
                left: isMe ? 0 : 46,
                right: isMe ? 8 : 0,
                bottom: 4,
              ),
              child: _buildReplySection(context, isMe, maxBubbleWidth),
            ),
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (!isMe) _buildAvatarSlot(),

              // Bubble + metadata column (loose flex: width follows content, not screen)
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  crossAxisAlignment: isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: <Widget>[
                    // Sender name (hidden on reply messages; context line covers it)
                    if (!isMe && isGroupStart && message.replyPreview == null)
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
                      children: <Widget>[
                        if (!isMe) ...<Widget>[
                          if (showAvatar)
                            ChatAvatar(
                              name: message.sender.name,
                              avatarUrl: message.sender.avatar,
                              size: 28,
                            )
                          else
                            const SizedBox(width: 30),
                          const SizedBox(width: 6),
                        ],
                        Flexible(
                          fit: FlexFit.loose,
                          child: GestureDetector(
                            onLongPress: () => _showMessageActions(context),
                            child: _buildMessageBody(context, isMe),
                          ),
                        ),
                        if (isMe) const SizedBox(width: 8),
                      ],
                    ),

                    if (message.reactions.isNotEmpty) _buildReactions(),

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
                          children: <Widget>[
                            Text(
                              _formatTime(message.timestamp),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            if (isMe) ...<Widget>[
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
        ],
      ),
    );
  }

  Widget _buildMessageBody(BuildContext context, bool isMe) {
    final double maxW = _bubbleMaxWidth(context);

    if (message.attachments.isNotEmpty) {
      return _buildAttachmentsBody(context, isMe, maxW);
    }

    return _buildTextBody(context, isMe, maxW);
  }

  /// Attachment messages: render files/media only (never [Message.content]).
  Widget _buildAttachmentsBody(BuildContext context, bool isMe, double maxW) {
    if (_messageIsVisualMediaOnly(message) && message.replyPreview == null) {
      return _wrapHighlight(
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: _buildVisualMediaList(maxW),
        ),
      );
    }

    final List<Widget> visualMedia = <Widget>[];
    final List<Widget> bubbleChildren = <Widget>[];

    for (final Attachment attachment in message.attachments) {
      if (_isVisualMedia(attachment)) {
        visualMedia.add(_buildVisualMedia(attachment, maxW));
      } else {
        bubbleChildren.add(_buildFileAttachmentRow(attachment, isMe));
      }
    }

    final List<Widget> body = <Widget>[];
    if (bubbleChildren.isNotEmpty) {
      body.add(
        _wrapInTextBubble(
          isMe: isMe,
          maxWidth: maxW,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: bubbleChildren,
          ),
        ),
      );
    }
    if (visualMedia.isNotEmpty) {
      if (body.isNotEmpty) {
        body.add(const SizedBox(height: Dimens.spacingS));
      }
      for (int i = 0; i < visualMedia.length; i++) {
        if (i > 0) {
          body.add(const SizedBox(height: Dimens.spacingS));
        }
        body.add(visualMedia[i]);
      }
    }

    return _wrapHighlight(
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: body,
        ),
      ),
    );
  }

  Widget _buildTextBody(BuildContext context, bool isMe, double maxW) {
    final List<Widget> bubbleChildren = <Widget>[];

    final String text = message.content.trim();
    if (text.isNotEmpty) {
      bubbleChildren.add(
        Text(
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

    if (bubbleChildren.isEmpty) {
      return const SizedBox.shrink();
    }

    return _wrapHighlight(
      _wrapInTextBubble(
        isMe: isMe,
        maxWidth: maxW,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: bubbleChildren,
        ),
      ),
    );
  }

  List<Widget> _buildVisualMediaList(double maxW) {
    return <Widget>[
      for (int i = 0; i < message.attachments.length; i++) ...<Widget>[
        if (i > 0) const SizedBox(height: Dimens.spacingS),
        _buildVisualMedia(message.attachments[i], maxW),
      ],
    ];
  }

  Widget _wrapInTextBubble({
    required bool isMe,
    required double maxWidth,
    required Widget child,
  }) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? AppColors.messengerBlue : AppColors.bubbleGray,
        borderRadius: _buildBorderRadius(isMe, isGroupStart, isGroupEnd),
      ),
      child: child,
    );
  }

  Widget _wrapHighlight(Widget child) {
    if (!isHighlighted) {
      return child;
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textPrimary, width: 2.5),
        borderRadius: _buildBorderRadius(message.isMe, isGroupStart, isGroupEnd),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildVisualMedia(Attachment attachment, double maxWidth) {
    final bool isSticker = attachment.type == AttachmentType.sticker;
    final double maxHeight = isSticker
        ? Dimens.chatBubbleStickerMaxHeight
        : Dimens.chatBubbleImageMaxHeight;
    final double maxW = isSticker
        ? Dimens.chatBubbleStickerMaxWidth
        : maxWidth;

    return GestureDetector(
      onTap: () => _openAttachmentUrl(attachment.url),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.cardBorderRadius),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxW,
            maxHeight: maxHeight,
          ),
          child: Image.network(
            attachment.url,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stack) {
              return Container(
                padding: const EdgeInsets.all(Dimens.spacingM),
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.broken_image_outlined,
                  color: AppColors.textSecondary,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _replyContextLabel(BuildContext context, bool bubbleIsMe) {
    final MessageReplyPreview preview = message.replyPreview!;
    final AppLocalizations l = AppLocalizations.of(context);

    if (bubbleIsMe) {
      if (preview.isMe) {
        return l.translate('chat_you_replied_to_self');
      }
      return l.translate('chat_you_replied_to').replaceAll(
            '{name}',
            preview.senderName,
          );
    }

    if (preview.isMe) {
      return l.translate('chat_replied_to_you').replaceAll(
            '{name}',
            message.sender.name,
          );
    }

    return l.translate('chat_replied_to_self').replaceAll(
          '{name}',
          message.sender.name,
        );
  }

  /// Reply context + quoted message shown above the bubble (Messenger-style).
  Widget _buildReplySection(
    BuildContext context,
    bool isMe,
    double maxWidth,
  ) {
    final Color headerColor =
        isMe ? AppColors.textSecondary : AppColors.messengerBlue;

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          _replyContextLabel(context, isMe),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: headerColor,
          ),
        ),
        const SizedBox(height: 4),
        _buildReplyQuote(context, maxWidth),
      ],
    );
  }

  Widget _buildReplyQuote(BuildContext context, double maxWidth) {
    final MessageReplyPreview preview = message.replyPreview!;
    final AppLocalizations l = AppLocalizations.of(context);
    final String body = preview.content.trim().isEmpty
        ? l.translate('chat_reply_attachment')
        : preview.content;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.bubbleGray,
          borderRadius: BorderRadius.circular(_replyQuoteBorderRadius),
        ),
        child: Text(
          body,
          softWrap: true,
          style: const TextStyle(
            fontSize: 13,
            height: 1.25,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildFileAttachmentRow(Attachment attachment, bool isMe) {
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
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.isZalo)
                  ZaloReactionImage(reactIcon: reaction.emoji, size: 16)
                else
                  Text(
                    reaction.emoji,
                    style: const TextStyle(fontSize: 12),
                  ),
                const SizedBox(width: 4),
                Text(
                  '${reaction.amount}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _showMessageActions(BuildContext context) async {
    final AppLocalizations l = AppLocalizations.of(context);

    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.reply_rounded),
                title: Text(l.translate('chat_reply')),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onReply?.call();
                },
              ),
              if (message.canReactOnZalo)
                ListTile(
                  leading: const Icon(Icons.add_reaction_outlined),
                  title: Text(l.translate('chat_add_reaction')),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _showReactionPicker(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showReactionPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ReactionPicker(
            onReactionSelected: (String reactIcon) {
              Navigator.of(sheetContext).pop();
              onZaloReactionSelected?.call(reactIcon);
            },
          ),
        );
      },
    );
  }
}
