import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../domain/entity/chat/chat_room.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String avatarInitials;
  final bool isActive;
  final ChatRoom? room;
  final VoidCallback? onAIAnalysisTap;
  final VoidCallback? onBack;

  const ChatAppBar({
    super.key,
    this.name = 'Jarvis AI',
    this.avatarInitials = 'AI',
    this.isActive = true,
    this.room,
    this.onAIAnalysisTap,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.messengerBlue),
        onPressed: onBack != null
            ? () => onBack!()
            : () => Navigator.of(context).maybePop(),
      ),
      title: Row(
        children: [
          _buildAvatarWithStatus(),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                isActive ? 'Active now' : 'Offline',
                style: TextStyle(
                  color: isActive ? AppColors.onlineGreen : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: "Voice call",
          icon: const Icon(Icons.phone, color: AppColors.messengerBlue),
          onPressed: () {},
        ),
        IconButton(
          tooltip: "Video call",
          icon: const Icon(
            Icons.videocam_rounded,
            color: AppColors.messengerBlue,
          ),
          onPressed: () {},
        ),
        IconButton(
          tooltip: "AI Analysis",
          icon: const Icon(
            Icons.analytics_rounded,
            color: AppColors.messengerBlue,
          ),
          onPressed: onAIAnalysisTap,
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.dividerColor, height: 1),
      ),
    );
  }

  Widget _buildAvatarWithStatus() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.messengerBlue,
          child: Text(
            avatarInitials,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        if (isActive)
          Positioned(
            right: -1,
            bottom: -1,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: AppColors.onlineGreen,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
