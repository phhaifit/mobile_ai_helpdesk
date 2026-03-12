import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../constants/colors.dart';
import '../../di/service_locator.dart';
import '../../domain/entity/chat/chat_room.dart';
import 'chat_screen.dart';
import 'store/chat_room_store.dart';
import 'widgets/chat_room_tile.dart';

class ChatRoomListScreen extends StatefulWidget {
  final String selectedCategory;
  final VoidCallback onMenuTap;

  const ChatRoomListScreen({
    super.key,
    required this.selectedCategory,
    required this.onMenuTap,
  });

  @override
  State<ChatRoomListScreen> createState() => _ChatRoomListScreenState();
}

class _ChatRoomListScreenState extends State<ChatRoomListScreen> {
  final ChatRoomStore _chatRoomStore = getIt<ChatRoomStore>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _chatRoomStore.fetchChatRooms();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openRoom(ChatRoom room) {
    _chatRoomStore.markAsRead(room.id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatScreen(room: room)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildActiveNowRow(),
          const Divider(height: 1, color: AppColors.dividerColor),
          Expanded(child: _buildRoomList()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Observer(
        builder: (_) => Row(
          children: [
            const Text(
              'Chats',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            if (_chatRoomStore.totalUnread > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.messengerBlue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  '${_chatRoomStore.totalUnread}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        _appBarIconBtn(Icons.camera_alt_outlined, () {}),
        _appBarIconBtn(Icons.menu_rounded, widget.onMenuTap),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.dividerColor, height: 1),
      ),
    );
  }

  Widget _appBarIconBtn(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
      onPressed: onTap,
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
            prefixIcon: Icon(Icons.search_rounded, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          ),
          style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildActiveNowRow() {
    return Observer(
      builder: (_) {
        final activeRooms = _chatRoomStore.chatRooms
            .where((r) => r.isActive)
            .toList();
        if (activeRooms.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 6),
              child: Text(
                'Active Now',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 86,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: activeRooms.length,
                itemBuilder: (_, i) => _buildActiveRoomItem(activeRooms[i]),
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildActiveRoomItem(ChatRoom room) {
    return GestureDetector(
      onTap: () => _openRoom(room),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 52,
                  height: 52,
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
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.onlineGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 60,
              child: Text(
                room.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomList() {
    return Observer(
      builder: (_) {
        if (_chatRoomStore.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.messengerBlue),
          );
        }

        final filtered = _searchQuery.isEmpty
            ? _chatRoomStore.chatRooms
            : _chatRoomStore.chatRooms
                  .where(
                    (r) =>
                        r.name.toLowerCase().contains(_searchQuery) ||
                        r.lastMessage.toLowerCase().contains(_searchQuery),
                  )
                  .toList();

        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search_off_rounded,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(height: 12),
                Text(
                  _searchQuery.isEmpty
                      ? 'No conversations yet'
                      : 'No results for "$_searchQuery"',
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (_, i) => ChatRoomTile(
            room: filtered[i],
            onTap: () => _openRoom(filtered[i]),
          ),
        );
      },
    );
  }
}
