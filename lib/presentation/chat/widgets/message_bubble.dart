import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../domain/entity/chat/message.dart';
import 'reaction_picker.dart';

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

  const MessageBubble({
    super.key,
    required this.message,
    this.isGroupStart = true,
    this.isGroupEnd = true,
    this.showAvatar = true,
    this.onReactionAdded,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.isMe;
    final double screenWidth = MediaQuery.of(context).size.width;

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
                      message.senderName,
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
                      if (showAvatar)
                        _buildAvatar()
                      else
                        const SizedBox(width: 30),
                      const SizedBox(width: 6),
                    ],

                    GestureDetector(
                      onLongPress: () => _showReactionPicker(context),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: screenWidth * 0.68,
                        ),
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
                          ),
                          child: Text(
                            message.content,
                            style: TextStyle(
                              color: isMe
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontSize: 15,
                            ),
                          ),
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
                          _buildReadStatusIcon(),
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

  Widget _buildAvatarSlot() {
    // Reserve space so bubbles align even when no avatar is shown
    return const SizedBox(width: 0);
  }

  Widget _buildAvatar() {
    final initial = message.senderName.isNotEmpty
        ? message.senderName[0].toUpperCase()
        : '?';
    return CircleAvatar(
      radius: 15,
      backgroundColor: AppColors.messengerBlue,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDay = DateTime(time.year, time.month, time.day);

    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    final timeStr = '$h:$m';

    if (msgDay == today) return timeStr;
    return '${time.day}/${time.month} $timeStr';
  }

  Widget _buildReadStatusIcon() {
    switch (message.readStatus) {
      case MessageReadStatus.sent:
        return Tooltip(
          message: 'Sent',
          child: Icon(Icons.done, size: 14, color: Colors.grey.shade600),
        );
      case MessageReadStatus.delivered:
        return Tooltip(
          message: 'Delivered',
          child: Icon(Icons.done_all, size: 14, color: Colors.grey.shade600),
        );
      case MessageReadStatus.read:
        return Tooltip(
          message: 'Read',
          child: Icon(Icons.done_all, size: 14, color: AppColors.messengerBlue),
        );
    }
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
                '${reaction.emoji} ${reaction.userNames.length}',
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
      items: [
        PopupMenuItem<String>(
          child: ReactionPicker(
            onReactionSelected: (emoji) {
              onReactionAdded?.call(emoji);
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
