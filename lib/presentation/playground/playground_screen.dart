import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/constants/dimens.dart';
import '/data/sharedpref/shared_preference_helper.dart';
import '/di/service_locator.dart';
import '/domain/entity/ai_agent/ai_agent.dart';
import '/domain/entity/playground/playground_session.dart';
import '/domain/usecase/media/upload_file_usecase.dart';
import '/presentation/jarvis/store/jarvis_store.dart';
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
  late final JarvisStore _jarvisStore;
  late final SharedPreferenceHelper _prefs;
  final ScrollController _scrollCtrl = ScrollController();
  final TextEditingController _inputCtrl = TextEditingController();
  PlaygroundContextType _contextType = PlaygroundContextType.normal;
  bool _showDrafts = false;
  List<String> _drafts = [];
  List<PlatformFile> _pendingAttachments = [];

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
    _jarvisStore = getIt<JarvisStore>();
    _prefs = getIt<SharedPreferenceHelper>();
    _store.fetchSessions().then((_) {
      if (_store.sessions.isNotEmpty && _store.activeSession == null) {
        _store.openSession(_store.sessions.first);
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _inputCtrl.dispose();
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

  Future<void> _onSend(String text) async {
    final filesToUpload = List<PlatformFile>.from(_pendingAttachments);
    setState(() => _pendingAttachments = []);

    // Upload any attached files and collect their URLs.
    final uploadedUrls = <String>[];
    if (filesToUpload.isNotEmpty) {
      final uploadUseCase = getIt<UploadFileUseCase>();
      final user = await _prefs.getUser();
      final tenantId = user?.id ?? 'default_tenant';
      for (final file in filesToUpload) {
        try {
          final media = await uploadUseCase.call(
            params: UploadFileParams(tenantId: tenantId, file: file),
          );
          uploadedUrls.add(media.url);
        } catch (_) {
          // Skip files that fail to upload — don't block the message.
        }
      }
    }

    // Add user message optimistically via PlaygroundStore (session management).
    await _store.sendMessage(text, attachments: uploadedUrls);
    _scrollToBottom();

    // Call Jarvis Agent for the AI response.
    final user = await _prefs.getUser();
    final tenantId = user?.id ?? 'default_tenant';
    final userId = user?.id ?? 'anonymous';
    final response = await _jarvisStore.sendMessage(
      tenantId: tenantId,
      userId: userId,
      userRole: 'agent',
      message: text,
      sessionId: _store.activeSession?.id,
      imageUrls: uploadedUrls,
    );

    // Surface draft responses from Jarvis when HITL confirmation is needed.
    if (response != null && response.requiresConfirmation) {
      setState(() {
        _drafts = [response.message];
        _showDrafts = true;
      });
    }
  }

  void _applyDraft(String draft) {
    _inputCtrl.text = draft;
    _inputCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: draft.length),
    );
    setState(() {
      _showDrafts = false;
      _drafts = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final bodyContent = Column(
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
            controller: _inputCtrl,
            onSend: _onSend,
            onAttachmentsChanged: (list) =>
                setState(() => _pendingAttachments = list),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (ctx) => Navigator.canPop(ctx)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(ctx),
                )
              : IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
        ),
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
      body: bodyContent,
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
