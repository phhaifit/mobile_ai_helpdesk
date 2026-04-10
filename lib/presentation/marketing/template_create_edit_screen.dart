/// WIDGET TREE:
/// Scaffold
///   AppBar(title: create/edit label based on template==null)
///   SingleChildScrollView
///     Column(padding: 16)
///       TextField (name)
///       DropdownButtonFormField (category)
///       DropdownButtonFormField (channel)
///       TextField (content, maxLines: 8)
///       _buildVariableChips()
///       FilledButton('Lưu Template')

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:ai_helpdesk/presentation/marketing/store/marketing_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';

class TemplateCreateEditScreen extends StatefulWidget {
  final MarketingTemplate? template;

  const TemplateCreateEditScreen({super.key, this.template});

  @override
  State<TemplateCreateEditScreen> createState() => _TemplateCreateEditScreenState();
}

class _TemplateCreateEditScreenState extends State<TemplateCreateEditScreen> {
  late final MarketingStore _store;
  final _nameController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<MarketingStore>();
    _store.initDraftFromTemplate(widget.template);
    _nameController.text = _store.draftTemplateName;
    _contentController.text = _store.draftTemplateContent;
    _nameController.addListener(() => _store.setDraftTemplateName(_nameController.text));
    _contentController.addListener(() => _store.setDraftTemplateContent(_contentController.text));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isEdit = widget.template != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? l.translate('marketing_tv_edit_template') : l.translate('marketing_tv_create_template')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Observer(
          builder: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tên template', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Nhập tên template...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label_outline),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Danh mục', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<TemplateCategory>(
                value: _store.draftTemplateCategory,
                decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.category_outlined)),
                items: TemplateCategory.values
                    .map((c) => DropdownMenuItem(value: c, child: Text(_categoryLabel(c, l))))
                    .toList(),
                onChanged: (v) { if (v != null) _store.setDraftTemplateCategory(v); },
              ),
              const SizedBox(height: 16),
              const Text('Kênh gửi', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<CampaignChannel>(
                value: _store.draftTemplateChannel,
                decoration: const InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.send_outlined)),
                items: CampaignChannel.values
                    .map((c) => DropdownMenuItem(value: c, child: Text(_channelLabel(c, l))))
                    .toList(),
                onChanged: (v) { if (v != null) _store.setDraftTemplateChannel(v); },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(child: Text('Nội dung', style: TextStyle(fontWeight: FontWeight.bold))),
                  TextButton.icon(
                    onPressed: _insertVariable,
                    icon: const Icon(Icons.add, size: 14),
                    label: const Text('Thêm biến', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _contentController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: l.translate('marketing_tv_template_content_hint'),
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 8),
              _buildVariableChips(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _store.isSubmitting
                      ? null
                      : () async {
                          await _store.saveTemplate();
                          if (mounted && _store.actionWasSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l.translate('marketing_success_template_saved')),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _store.isSubmitting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(l.translate('marketing_btn_save_template')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVariableChips() {
    final regex = RegExp(r'\{\{(\w+)\}\}');
    final matches = regex.allMatches(_contentController.text);
    final vars = matches.map((m) => m.group(1)!).toSet().toList();
    if (vars.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Biến phát hiện:', style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          children: vars
              .map((v) => Chip(
                    label: Text('{{$v}}', style: const TextStyle(fontSize: 11)),
                    backgroundColor: Colors.blue.shade50,
                    side: BorderSide(color: Colors.blue.shade200),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ))
              .toList(),
        ),
      ],
    );
  }

  void _insertVariable() {
    showDialog(
      context: context,
      builder: (_) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: const Text('Thêm biến'),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(
              hintText: 'Tên biến, vd: customerName',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
            FilledButton(
              onPressed: () {
                if (ctrl.text.isNotEmpty) {
                  final cursor = _contentController.selection.base.offset;
                  final text = _contentController.text;
                  final variable = '{{${ctrl.text.trim()}}}';
                  final newText = cursor >= 0 && cursor <= text.length
                      ? text.substring(0, cursor) + variable + text.substring(cursor)
                      : text + variable;
                  _contentController.text = newText;
                  _store.setDraftTemplateContent(newText);
                }
                Navigator.pop(context);
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  String _categoryLabel(TemplateCategory c, AppLocalizations l) {
    switch (c) {
      case TemplateCategory.promotional: return l.translate('marketing_tv_category_promotional');
      case TemplateCategory.transactional: return l.translate('marketing_tv_category_transactional');
      case TemplateCategory.announcement: return l.translate('marketing_tv_category_announcement');
      case TemplateCategory.reminder: return l.translate('marketing_tv_category_reminder');
    }
  }

  String _channelLabel(CampaignChannel c, AppLocalizations l) {
    switch (c) {
      case CampaignChannel.messenger: return l.translate('marketing_tv_channel_messenger');
      case CampaignChannel.zalo: return l.translate('marketing_tv_channel_zalo');
      case CampaignChannel.email: return l.translate('marketing_tv_channel_email');
      case CampaignChannel.sms: return l.translate('marketing_tv_channel_sms');
    }
  }
}
