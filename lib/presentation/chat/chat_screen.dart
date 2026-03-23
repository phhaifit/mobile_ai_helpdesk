// Screen file map — ChatScreen (prompt slash flow: folders and files that define this screen)
// lib/
// ├── presentation/
// │   ├── home/
// │   │   └── home.dart                         # TabBarView: ChatScreen(embedInParent: true)
// │   ├── chat/
// │   │   ├── chat_screen.dart                  # this file; TextField, PromptStore.slashFiltered
// │   │   └── slash_prompt_picker_overlay.dart  # overlay when composer starts with /
// │   └── prompt/store/
// │       ├── prompt_store.dart                 # loadPrompts, incrementUsage, slashFiltered
// │       └── prompt_store.g.dart
// ├── domain/
// │   ├── entity/prompt/prompt.dart
// │   └── repository/prompt/prompt_repository.dart
// ├── data/repository/prompt/mock_prompt_repository_impl.dart
// ├── utils/locale/app_localization.dart
// └── assets/lang/
//     ├── en.json
//     └── vi.json
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';
import 'package:ai_helpdesk/presentation/chat/slash_prompt_picker_overlay.dart';
import 'package:ai_helpdesk/presentation/prompt/store/prompt_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.embedInParent = false});

  final bool embedInParent;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatMessage {
  _ChatMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;
}

class _ChatScreenState extends State<ChatScreen> {
  late final PromptStore _promptStore;
  final TextEditingController _composer = TextEditingController();
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: 'Welcome. Type a message or start with / to pick a saved prompt.',
      isUser: false,
    ),
  ];
  bool _slashMode = false;

  @override
  void initState() {
    super.initState();
    _promptStore = getIt<PromptStore>();
    _composer.addListener(_onComposerChanged);
    if (_promptStore.prompts.isEmpty) {
      _promptStore.loadPrompts(useNetworkDelay: false);
    }
  }

  void _onComposerChanged() {
    final t = _composer.text;
    final next = t.startsWith('/');
    if (next != _slashMode) {
      setState(() => _slashMode = next);
    } else if (_slashMode) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _composer.removeListener(_onComposerChanged);
    _composer.dispose();
    super.dispose();
  }

  String get _slashQuery =>
      _slashMode && _composer.text.startsWith('/')
          ? _composer.text.substring(1)
          : '';

  void _sendText() {
    final text = _composer.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _messages.add(
        _ChatMessage(
          text: '(Mock) Message received. Prompt usage is tracked when you insert via /.',
          isUser: false,
        ),
      );
    });
    _composer.clear();
    setState(() => _slashMode = false);
  }

  void _applyPrompt(Prompt p) {
    _composer.text = p.body;
    _composer.selection = TextSelection.collapsed(offset: _composer.text.length);
    setState(() => _slashMode = false);
    _promptStore.incrementUsage(p.id);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final content = Column(
        children: [
          if (widget.embedInParent)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l.translate('prompt_tv_chat_title'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                return Align(
                  alignment:
                      m.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * 0.82,
                    ),
                    decoration: BoxDecoration(
                      color: m.isUser
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(m.text),
                  ),
                );
              },
            ),
          ),
          if (_slashMode)
            Observer(
              builder: (_) {
                final filtered = _promptStore.slashFiltered(_slashQuery);
                return SlashPromptPickerOverlay(
                  prompts: filtered,
                  onSelected: _applyPrompt,
                );
              },
            ),
          SafeArea(
            top: false,
            child: Material(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 4, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _composer,
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: l.translate('prompt_tv_chat_hint'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendText(),
                      ),
                    ),
                    IconButton(
                      onPressed: _sendText,
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

    if (widget.embedInParent) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('prompt_tv_chat_title')),
      ),
      body: content,
    );
  }
}
