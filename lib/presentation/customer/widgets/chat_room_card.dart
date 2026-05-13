import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/chat_room/customer_chat_room.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Read-only chat-room summary card shown on the customer detail timeline.
///
/// Tapping the card surfaces a "coming soon" notice — opening the full
/// conversation thread is deferred until a dedicated chat-detail route
/// is shipped.
class ChatRoomCard extends StatelessWidget {
  final CustomerChatRoom room;
  final VoidCallback? onTap;

  const ChatRoomCard({required this.room, super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final descriptor = _resolveChannel(room.channel, l10n);
    final timestamp = room.lastMessageAt;

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: descriptor.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(descriptor.icon, color: descriptor.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            descriptor.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        if (timestamp != null)
                          Text(
                            _formatTimestamp(timestamp),
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      room.lastMessagePreview ?? '—',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                    ),
                    if (room.hasUnread) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${room.unreadCount} chưa đọc',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime ts) {
    final now = DateTime.now();
    final diff = now.difference(ts);
    if (diff.inMinutes < 1) return 'vừa xong';
    if (diff.inHours < 1) return '${diff.inMinutes}p';
    if (diff.inDays < 1) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return DateFormat('dd/MM').format(ts);
  }
}

class _ChannelDescriptor {
  final IconData icon;
  final String label;
  final Color color;
  const _ChannelDescriptor(this.icon, this.label, this.color);
}

_ChannelDescriptor _resolveChannel(String raw, AppLocalizations l10n) {
  switch (raw.toLowerCase()) {
    case 'messenger':
    case 'facebook':
      return _ChannelDescriptor(
        Icons.facebook,
        l10n.translate('chat_channel_messenger'),
        const Color(0xFF0084FF),
      );
    case 'zalo':
    case 'zalo_personal':
      return _ChannelDescriptor(
        Icons.chat_bubble,
        l10n.translate('chat_channel_zalo'),
        const Color(0xFF1877F2),
      );
    case 'webchat':
    case 'web':
      return _ChannelDescriptor(
        Icons.public,
        l10n.translate('chat_channel_webchat'),
        Colors.teal,
      );
    case 'email':
      return _ChannelDescriptor(
        Icons.email_outlined,
        l10n.translate('chat_channel_email'),
        Colors.redAccent,
      );
    case 'phone':
      return _ChannelDescriptor(
        Icons.phone_outlined,
        l10n.translate('chat_channel_phone'),
        Colors.green,
      );
    case 'lazada':
      return _ChannelDescriptor(
        Icons.storefront_outlined,
        l10n.translate('chat_channel_lazada'),
        Colors.orange,
      );
    case 'zendesk':
      return _ChannelDescriptor(
        Icons.support_agent,
        l10n.translate('chat_channel_zendesk'),
        Colors.indigo,
      );
    case 'zohodesk':
      return _ChannelDescriptor(
        Icons.support_agent,
        l10n.translate('chat_channel_zohodesk'),
        Colors.deepPurple,
      );
    default:
      return _ChannelDescriptor(
        Icons.chat_bubble_outline,
        raw.isEmpty ? l10n.translate('chat_channel_unknown') : raw,
        Colors.grey,
      );
  }
}
