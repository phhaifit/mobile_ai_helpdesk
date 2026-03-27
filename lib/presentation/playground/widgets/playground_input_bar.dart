import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '/constants/colors.dart';
import '/utils/locale/app_localization.dart';

/// Bottom input bar for the playground chat.
/// Supports text input and file attachment via [file_picker].
class PlaygroundInputBar extends StatefulWidget {
  final bool enabled;
  final ValueChanged<String> onSend;
  final ValueChanged<List<String>>? onAttachmentsChanged;

  /// Optional external controller. When provided, the widget uses it
  /// directly and does NOT dispose it — the caller is responsible.
  final TextEditingController? controller;

  const PlaygroundInputBar({
    super.key,
    required this.onSend,
    this.onAttachmentsChanged,
    this.controller,
    this.enabled = true,
  });

  @override
  State<PlaygroundInputBar> createState() => _PlaygroundInputBarState();
}

class _PlaygroundInputBarState extends State<PlaygroundInputBar> {
  late final TextEditingController _controller;
  bool _ownsController = false;
  final List<String> _attachments = [];

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    setState(() => _attachments.clear());
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: kIsWeb,
    );
    if (result == null) return;
    // On web, file.path is always null — use file.name for display on all platforms.
    final names = result.files.map((f) => f.name).toList();
    setState(() => _attachments.addAll(names));
    widget.onAttachmentsChanged?.call(_attachments);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      color: AppColors.inputBackground,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_attachments.isNotEmpty)
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _attachments.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (_, i) => Chip(
                    label: Text(
                      _attachments[i].split(RegExp(r'[/\\]')).last,
                      style: const TextStyle(fontSize: 11),
                    ),
                    avatar: const Icon(Icons.attach_file, size: 14),
                    onDeleted: () => setState(() => _attachments.removeAt(i)),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  tooltip: l.translate('playground_attach_file'),
                  onPressed: widget.enabled ? _pickFiles : null,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: widget.enabled,
                    maxLines: 4,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: l.translate('playground_type_message'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: widget.enabled
                        ? (v) {
                            if (v.trim().isNotEmpty) _handleSend();
                          }
                        : null,
                  ),
                ),
                const SizedBox(width: 4),
                FilledButton(
                  onPressed: widget.enabled ? _handleSend : null,
                  style: FilledButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.send, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
