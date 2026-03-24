import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/constants/dimens.dart';
import '/di/service_locator.dart';
import '/domain/entity/ai_agent/ai_agent.dart';
import '/domain/entity/playground/playground_session.dart';
import '/presentation/playground/store/playground_store.dart';
import '/presentation/playground/widgets/context_selector.dart';
import '/presentation/playground/widgets/draft_response_panel.dart';
import '/presentation/playground/widgets/playground_input_bar.dart';
import '/presentation/playground/widgets/playground_message_bubble.dart';
import '/presentation/playground/widgets/session_history_drawer.dart';
import '/presentation/playground/widgets/streaming_indicator.dart';
import '/presentation/playground/widgets/suggestion_chips.dart';
import '/utils/locale/app_localization.dart';

/// Main AI Chat Playground screen.
///
/// Widget Tree:
/// Scaffold
///   ├── AppBar (title, history drawer button)
///   ├── Drawer → SessionHistoryDrawer
///   └── Body → Column
///       ├── ContextSelector (lazada / normal)
///       ├── SuggestionChips (quick prompts in empty state)
///       ├── Expanded → ListView (messages + StreamingIndicator)
///       ├── DraftResponsePanel (optional, when drafts available)
///       └── PlaygroundInputBar (input + attach)
class PlaygroundScreen extends StatefulWidget {
  /// Optional agent pre-loaded for this playground session.
  final AiAgent? agent;

  const PlaygroundScreen({super.key, this.agent});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  late final PlaygroundStore _store;
  final ScrollController _scrollCtrl = ScrollController();
  PlaygroundContextType _contextType = PlaygroundContextType.normal;
  bool _showDrafts = false;
  List<String> _drafts = [];

  static const _suggestions = [
    'Tôi muốn đổi trả sản phẩm',
    'Đơn hàng của tôi ở đâu?',
    'Chính sách hoàn tiền như thế nào?',
    'Liên hệ hỗ trợ',
  ];

  @override
  void initState() {
    super.initState();
    _store = getIt<PlaygroundStore>();
    _store.fetchSessions().then((_) {
      if (_store.sessions.isNotEmpty && _store.activeSession == null) {
        _store.openSession(_store.sessions.first);
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _newSession() async {
    await _store.createSession(_contextType, widget.agent?.id);
    _scrollToBottom();
  }

  void _onSend(String text) {
    _store.sendMessage(text, attachments: []);
    _scrollToBottom();
    // Generate mock drafts after each message for demonstration.
    setState(() {
      _drafts = [
        'Cảm ơn bạn đã liên hệ! Tôi sẽ xử lý ngay.',
        'Vấn đề của bạn đã được ghi nhận và đội ngũ sẽ liên hệ trong 2 giờ.',
      ];
      _showDrafts = true;
    });
  }

  void _applyDraft(String draft) {
    setState(() {
      _showDrafts = false;
      _drafts = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('playground_title')),
        actions: [
          Observer(
            builder: (_) => IconButton(
              icon: const Icon(Icons.add_comment_outlined),
              tooltip: l.translate('playground_new_session'),
              onPressed: _newSession,
            ),
          ),
        ],
      ),
      drawer: SessionHistoryDrawer(
        store: _store,
        onNewSession: () {
          Navigator.pop(context);
          _newSession();
        },
      ),
      body: Column(
        children: [
          // ─── Context Selector ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.horizontalPadding,
              vertical: 8,
            ),
            child: ContextSelector(
              selected: _contextType,
              onChanged: (type) => setState(() => _contextType = type),
            ),
          ),
          const Divider(height: 1),

          // ─── Messages List ───────────────────────────────────────────────
          Expanded(
            child: Observer(builder: (_) {
              final messages = _store.messages;
              final isStreaming = _store.isStreaming;

              if (_store.activeSession == null) {
                return _EmptyState(
                  suggestions: _suggestions,
                  onSuggestionTap: (s) {
                    _newSession().then((_) => _onSend(s));
                  },
                  onNewSession: _newSession,
                );
              }

              if (messages.isEmpty) {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    SuggestionChips(
                      suggestions: _suggestions,
                      onSelected: _onSend,
                    ),
                  ],
                );
              }

              _scrollToBottom();
              return ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: messages.length + (isStreaming ? 1 : 0),
                itemBuilder: (_, i) {
                  if (isStreaming && i == messages.length) {
                    return const StreamingIndicator();
                  }
                  final msg = messages[i];
                  // Skip empty streaming placeholders — StreamingIndicator
                  // renders above instead.
                  if (msg.isStreaming && msg.content.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return PlaygroundMessageBubble(
                    message: msg,
                    onEdit: () => _showEditDialog(msg.id, msg.content),
                  );
                },
              );
            }),
          ),

          // ─── Draft Response Panel ────────────────────────────────────────
          if (_showDrafts)
            DraftResponsePanel(
              drafts: _drafts,
              onUse: _applyDraft,
              onDismiss: () => setState(() {
                _showDrafts = false;
                _drafts = [];
              }),
            ),

          // ─── Input Bar ───────────────────────────────────────────────────
          Observer(
            builder: (_) => PlaygroundInputBar(
              enabled: _store.activeSession != null && !_store.isStreaming,
              onSend: _onSend,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(String messageId, String currentContent) {
    final ctrl = TextEditingController(text: currentContent);
    showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('playground_edit_message')),
        content: TextField(
          controller: ctrl,
          maxLines: 4,
          autofocus: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context).translate('ai_agent_cancel'),
            ),
          ),
          FilledButton(
            onPressed: () {
              _store.editMessage(messageId, ctrl.text.trim());
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context).translate('ai_agent_save'),
            ),
          ),
        ],
      ),
    ).then((_) => ctrl.dispose());
  }
}

class _EmptyState extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSuggestionTap;
  final VoidCallback onNewSession;

  const _EmptyState({
    required this.suggestions,
    required this.onSuggestionTap,
    required this.onNewSession,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.horizontalPadding * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.psychology_outlined,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l.translate('playground_title'),
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l.translate('playground_no_sessions'),
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.add),
              label: Text(l.translate('playground_new_session')),
              onPressed: onNewSession,
            ),
            const SizedBox(height: 24),
            SuggestionChips(
              suggestions: suggestions,
              onSelected: onSuggestionTap,
            ),
          ],
        ),
      ),
    );
  }
}
