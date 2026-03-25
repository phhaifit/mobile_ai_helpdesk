import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../domain/entity/chat/chat_room.dart';

class ChatRoomTile extends StatelessWidget {
  final ChatRoom room;
  final VoidCallback onTap;

  const ChatRoomTile({required this.room, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final bool hasUnread = room.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      splashColor: AppColors.messengerBlue.withOpacity(0.08),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Avatar with online indicator
            _buildAvatar(),
            const SizedBox(width: 12),
            // Name + last message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: hasUnread
                                ? AppColors.textPrimary
                                : Colors.grey,
                            fontWeight: hasUnread
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(room.lastMessageTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: hasUnread
                              ? AppColors.messengerBlue
                              : Colors.grey,
                          fontWeight: hasUnread
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Unread badge or read checkmark
            _buildTrailing(hasUnread),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: room.isAI
                  ? [AppColors.messengerBlue, const Color(0xFF9B51E0)]
                  : [const Color(0xFF6BC5F8), AppColors.messengerBlue],
            ),
          ),
          child: Center(
            child: Text(
              room.avatarInitials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        if (room.isActive)
          Positioned(
            right: 1,
            bottom: 1,
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: AppColors.onlineGreen,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTrailing(bool hasUnread) {
    if (!hasUnread) {
      return const SizedBox(width: 24);
    }
    return Container(
      constraints: const BoxConstraints(minWidth: 22),
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
        color: AppColors.messengerBlue,
        borderRadius: BorderRadius.all(Radius.circular(11)),
      ),
      child: Center(
        child: Text(
          room.unreadCount > 99 ? '99+' : '${room.unreadCount}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final msgDay = DateTime(time.year, time.month, time.day);

    if (msgDay == today) {
      final h = time.hour.toString().padLeft(2, '0');
      final m = time.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } else if (msgDay == yesterday) {
      return 'Yesterday';
    } else {
      return '${time.day}/${time.month}';
    }
  }
}
