import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../domain/entity/chat/chat_room.dart';
import 'widgets/chat_app_bar.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/ai_analysis_panel.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom? room;
  final int? scrollToMessageId;

  const ChatScreen({super.key, this.room, this.scrollToMessageId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  bool _showAIPanel = false;
  late AnimationController _panelAnimationController;
  late Animation<Offset> _panelSlideAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollPositionChanged);
    _inputFocusNode.addListener(_onInputFocusChanged);

    // Initialize AI Panel animation controller
    _panelAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _panelSlideAnimation =
        Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(
          CurvedAnimation(
            parent: _panelAnimationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  void _onScrollPositionChanged() {
    // Implementation for scroll position change
  }

  void _onInputFocusChanged() {
    if (_inputFocusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _toggleAIPanel() {
    setState(() {
      _showAIPanel = !_showAIPanel;
      if (_showAIPanel) {
        _panelAnimationController.forward();
      } else {
        _panelAnimationController.reverse();
      }
    });
  }

  void _closeAIPanel() {
    setState(() {
      _showAIPanel = false;
      _panelAnimationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.room == null) {
      return const SizedBox.expand(
        child: Center(child: Text('Chọn một phòng chat để bắt đầu')),
      );
    }

    return Scaffold(
      appBar: ChatAppBar(
        name: widget.room!.name,
        avatarInitials: widget.room!.avatarInitials,
        isActive: widget.room!.isActive,
        room: widget.room,
        onAIAnalysisTap: _toggleAIPanel,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Messages list
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    // Messages would be displayed here
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mail_outline_rounded,
                            size: 64,
                            color: AppColors.messengerBlue.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Chưa tìm thấy tin nhắn nào cho phiếu này',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Hãy bắt đầu cuộc trò chuyện với khách hàng để hiểu hơn về yêu cầu của họ!',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Input bar
              ChatInputBar(
                controller: _textController,
                onSend: () {
                  if (_textController.text.isNotEmpty) {
                    // Handle send message
                    _textController.clear();
                  }
                },
                focusNode: _inputFocusNode,
              ),
            ],
          ),
          // AI Analysis Panel (slides in from right)
          if (_showAIPanel)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: SlideTransition(
                position: _panelSlideAnimation,
                child: AIAnalysisPanel(
                  slideAnimation: _panelSlideAnimation,
                  onClose: _closeAIPanel,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _inputFocusNode.dispose();
    _panelAnimationController.dispose();
    super.dispose();
  }
}
