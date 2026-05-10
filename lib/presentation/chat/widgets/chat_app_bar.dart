import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../domain/entity/chat/chat_room.dart';
import 'chatr_avatar.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ChatRoom room;
  final VoidCallback? onAIAnalysisTap;
  final VoidCallback? onBack;
  final VoidCallback? onInfoTap;
  final VoidCallback? onSearchTap;

  const ChatAppBar({
    super.key,
    required this.room,
    this.onAIAnalysisTap,
    this.onBack,
    this.onInfoTap,
    this.onSearchTap,
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
          ChatAvatar(name: room.name, avatarUrl: room.avatarUrl, appAvatarUrl: room.appAvatarUrl, size: 36),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                room.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                spacing: 4,
                children: [
                  ChatAvatar(name: room.channel.name, avatarUrl: room.channel.avatarUrl, size: 16),
                  Text(
                    room.channel.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Search',
          icon: const Icon(Icons.search, color: AppColors.messengerBlue),
          onPressed: onSearchTap,
        ),
        IconButton(
          tooltip: 'Info',
          icon: const Icon(Icons.info_outline, color: AppColors.messengerBlue),
          onPressed: onInfoTap,
        ),
        const SizedBox(width: 10),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.dividerColor, height: 1),
      ),
    );
  }
}
