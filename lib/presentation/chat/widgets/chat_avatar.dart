import 'package:flutter/material.dart';

class ChatAvatar extends StatelessWidget {
  final String? name;
  final String? avatarUrl;
  final String? appAvatarUrl;
  final double size;

  const ChatAvatar({
    super.key,
    this.name,
    this.avatarUrl,
    this.appAvatarUrl,
    this.size = 56.0,
  });

  String _getAvatarInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    final single = parts[0];
    return single.length >= 2
        ? single.substring(0, 2).toUpperCase()
        : single[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage = avatarUrl != null && avatarUrl!.isNotEmpty;
    final String name = this.name ?? 'Unknown';
    final bool hasAppIcon = appAvatarUrl != null && appAvatarUrl!.isNotEmpty;
    final double appIconSize = size * 0.4; // Scales badge relative to avatar size

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main Avatar Circle
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: hasImage
                ? null
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6BC5F8), Color(0xFF2196F3)],
                  ),
          ),
          child: ClipOval(
            child: hasImage
                ? Image.network(
                    avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildInitialAvatar(name),
                  )
                : _buildInitialAvatar(name),
          ),
        ),

        // App Source Badge (Messenger/Zalo)
        if (hasAppIcon)
          Positioned(
            right: -size * 0.03, // Dynamic positioning
            bottom: -size * 0.03,
            child: Container(
              width: appIconSize,
              height: appIconSize,
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.network(
                  appAvatarUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInitialAvatar(String name) {
    return Center(
      child: Text(
        _getAvatarInitials(name),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.28, // Dynamic font size
        ),
      ),
    );
  }
}