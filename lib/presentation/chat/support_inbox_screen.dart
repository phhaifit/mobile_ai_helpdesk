import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../constants/colors.dart';
import '../../di/service_locator.dart';
import '../../domain/entity/chat/chat_room.dart';
import 'chat_screen.dart';
import 'contact_info_panel.dart';
import 'store/chat_room_store.dart';
import 'widgets/chat_room_tile.dart';

class SupportInboxScreen extends StatefulWidget {
  final VoidCallback? onMenuTap;

  const SupportInboxScreen({super.key, this.onMenuTap});

  @override
  State<SupportInboxScreen> createState() => _SupportInboxScreenState();
}

class _SupportInboxScreenState extends State<SupportInboxScreen> {
  final ChatRoomStore _store = getIt<ChatRoomStore>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  ChatRoom? _selectedRoom;

  @override
  void initState() {
    super.initState();
    _store.fetchChatRooms();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectRoom(ChatRoom room) {
    setState(() {
      _selectedRoom = room;
      _store.markAsRead(room.id);
    });
  }

  void _openRoom(ChatRoom room) {
    _selectRoom(room);
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 900) {
      // Trên mobile/tablet nhỏ, mở màn hình chat đầy đủ
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatScreen(room: room)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth < 900;

    if (isMobile) {
      // Mobile: Chỉ hiện danh sách
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildRoomList(),
      );
    }

    if (isTablet) {
      // Tablet: Danh sách + Chat (2 cột)
      return Scaffold(
        body: Row(
          children: [
            // Danh sách (30% chiều rộng)
            Container(
              width: screenWidth * 0.35,
              color: Colors.white,
              child: Column(
                children: [
                  _buildSearchBar(),
                  Expanded(child: _buildRoomList()),
                ],
              ),
            ),
            // Divider
            Container(width: 1, color: AppColors.dividerColor),
            // Chat (70% chiều rộng)
            Expanded(
              child: _selectedRoom != null
                  ? ChatScreen(room: _selectedRoom!)
                  : _buildEmptyChat(),
            ),
          ],
        ),
      );
    }

    // Desktop: 3 cột (Danh sách | Chat | Thông tin)
    return Scaffold(
      body: Row(
        children: [
          // Danh sách phòng chat (25% chiều rộng)
          Container(
            width: screenWidth * 0.25,
            color: Colors.white,
            child: Column(
              children: [
                _buildSearchBar(),
                Expanded(child: _buildRoomList()),
              ],
            ),
          ),
          // Divider
          Container(width: 1, color: AppColors.dividerColor),

          // Chat (50% chiều rộng)
          Expanded(
            flex: 2,
            child: _selectedRoom != null
                ? ChatScreen(room: _selectedRoom!)
                : _buildEmptyChat(),
          ),
          // Divider
          Container(width: 1, color: AppColors.dividerColor),

          // Thông tin liên hệ (25% chiều rộng)
          _selectedRoom != null
              ? ContactInfoPanel(room: _selectedRoom!)
              : Container(
                  width: screenWidth * 0.25,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'Chọn một phòng chat để xem thông tin',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
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
              'Hộp thư hỗ trợ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            if (_store.totalUnread > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.messengerBlue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  '${_store.totalUnread}',
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
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Color(0xFF333333)),
        onPressed: widget.onMenuTap,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm khách hàng',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: AppColors.messengerBlue),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: AppColors.messengerBlue),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          isDense: true,
        ),
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  Widget _buildRoomList() {
    return Observer(
      builder: (_) {
        if (_store.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final rooms = _store.chatRooms
            .where((r) => r.name.toLowerCase().contains(_searchQuery))
            .toList();

        if (rooms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 48,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 12),
                Text(
                  'Không tìm thấy phòng chat',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context, index) => Container(
            color: _selectedRoom?.id == rooms[index].id
                ? AppColors.backgroundGrey
                : Colors.transparent,
            child: ChatRoomTile(
              room: rooms[index],
              onTap: () => _openRoom(rooms[index]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyChat() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mail_outline_rounded,
              size: 80,
              color: AppColors.messengerBlue.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chọn một phòng chat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bắt đầu trao đổi với khách hàng',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
