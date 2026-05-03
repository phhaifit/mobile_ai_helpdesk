import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:ai_helpdesk/presentation/marketing/store/marketing_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';

class TemplateLibraryScreen extends StatefulWidget {
  final bool showAppBar;
  final VoidCallback? onMenuTap;

  const TemplateLibraryScreen({
    super.key,
    this.showAppBar = true,
    this.onMenuTap,
  });

  @override
  State<TemplateLibraryScreen> createState() => _TemplateLibraryScreenState();
}

class _TemplateLibraryScreenState extends State<TemplateLibraryScreen> {
  late final MarketingStore _store;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<MarketingStore>();
    if (_store.templates.isEmpty) _store.fetchOverview();
    _searchController.addListener(
      () => _store.setTemplateSearchQuery(_searchController.text),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateDialog(BuildContext context, AppLocalizations l) {
    final nameController = TextEditingController();
    CampaignChannel selectedChannel = CampaignChannel.messenger;

    showDialog(
      context: context,
      builder: (ctx) {
        final width = MediaQuery.of(context).size.width;
        final isSmall = width < 500;

        return StatefulBuilder(
          builder:
              (ctx, setDialogState) => AlertDialog(
                title: Text(
                  l.translate('marketing_tv_create_template'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                content: SizedBox(
                  width: isSmall ? width * 0.85 : 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tên template',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Nhập tên template...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Nền tảng',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<CampaignChannel>(
                        value: selectedChannel,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: CampaignChannel.messenger,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 16,
                                  color: _channelColor(
                                    CampaignChannel.messenger,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l.translate('marketing_tv_channel_messenger'),
                                ),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: CampaignChannel.zalo,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.message_outlined,
                                  size: 16,
                                  color: _channelColor(CampaignChannel.zalo),
                                ),
                                const SizedBox(width: 8),
                                Text(l.translate('marketing_tv_channel_zalo')),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: CampaignChannel.email,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: 16,
                                  color: _channelColor(CampaignChannel.email),
                                ),
                                const SizedBox(width: 8),
                                Text(l.translate('marketing_tv_channel_email')),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: CampaignChannel.sms,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.sms_outlined,
                                  size: 16,
                                  color: _channelColor(CampaignChannel.sms),
                                ),
                                const SizedBox(width: 8),
                                Text(l.translate('marketing_tv_channel_sms')),
                              ],
                            ),
                          ),
                        ],
                        onChanged:
                            (v) => setDialogState(() => selectedChannel = v!),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Hủy'),
                  ),
                  FilledButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      if (name.isEmpty) return;
                      Navigator.pop(ctx);
                      _store.setDraftTemplateName(name);
                      _store.setDraftTemplateChannel(selectedChannel);
                      _store.initDraftFromTemplate(null);
                      Navigator.pushNamed(
                        context,
                        Routes.templateCreateEdit,
                      ).then((_) => _store.fetchTemplates());
                    },
                    child: const Text('Tạo & Chỉnh sửa'),
                  ),
                ],
              ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 400;

    return Scaffold(
      appBar:
          widget.showAppBar
              ? AppBar(
                leading:
                    widget.onMenuTap != null
                        ? IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: widget.onMenuTap,
                        )
                        : null,
                title: Text(l.translate('marketing_tv_template_library')),
              )
              : null,
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: EdgeInsets.all(isSmall ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, l),
            SizedBox(height: isSmall ? 12 : 16),
            _buildSearchBar(),
            SizedBox(height: isSmall ? 10 : 12),
            _buildFilterChips(l),
            SizedBox(height: isSmall ? 12 : 16),
            Expanded(child: _buildGrid(context, l)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Observer(
      builder:
          (_) => TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm template...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon:
                  _store.templateSearchQuery.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _store.setTemplateSearchQuery('');
                        },
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l) {
    final isSmall = MediaQuery.of(context).size.width < 400;

    return isSmall
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.translate('marketing_tv_template_library'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _showCreateDialog(context, l),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l.translate('marketing_tv_create_template')),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.messengerBlue,
                ),
              ),
            ),
          ],
        )
        : Row(
          children: [
            Text(
              l.translate('marketing_tv_template_library'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: () => _showCreateDialog(context, l),
              icon: const Icon(Icons.add, size: 18),
              label: Text(l.translate('marketing_tv_create_template')),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.messengerBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ],
        );
  }

  Widget _buildFilterChips(AppLocalizations l) {
    return Observer(
      builder:
          (_) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _PlatformChip(
                  label: 'Tất cả nền tảng',
                  icon: Icons.apps,
                  selected: _store.templateFilterCategory == null,
                  onTap: () => _store.setTemplateFilterCategory(null),
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                _PlatformChip(
                  label: 'Facebook Messenger',
                  icon: Icons.chat_bubble_outline,
                  selected:
                      _store.draftChannelFilter == CampaignChannel.messenger,
                  onTap: () {
                    if (_store.draftChannelFilter ==
                        CampaignChannel.messenger) {
                      _store.setDraftChannelFilter(null);
                    } else {
                      _store.setDraftChannelFilter(CampaignChannel.messenger);
                    }
                  },
                  color: const Color(0xFF1877F2),
                ),
                const SizedBox(width: 8),
                _PlatformChip(
                  label: 'Zalo',
                  icon: Icons.message_outlined,
                  selected: _store.draftChannelFilter == CampaignChannel.zalo,
                  onTap: () {
                    if (_store.draftChannelFilter == CampaignChannel.zalo) {
                      _store.setDraftChannelFilter(null);
                    } else {
                      _store.setDraftChannelFilter(CampaignChannel.zalo);
                    }
                  },
                  color: const Color(0xFF0068FF),
                ),
                const SizedBox(width: 8),
                _PlatformChip(
                  label: 'Email',
                  icon: Icons.email_outlined,
                  selected: _store.draftChannelFilter == CampaignChannel.email,
                  onTap: () {
                    if (_store.draftChannelFilter == CampaignChannel.email) {
                      _store.setDraftChannelFilter(null);
                    } else {
                      _store.setDraftChannelFilter(CampaignChannel.email);
                    }
                  },
                  color: Colors.teal,
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildGrid(BuildContext context, AppLocalizations l) {
    return Observer(
      builder: (_) {
        if (_store.isLoadingOverview) {
          return const Center(child: CircularProgressIndicator());
        }

        var templates = _store.filteredTemplates.toList();
        if (_store.draftChannelFilter != null) {
          templates =
              templates
                  .where((t) => t.channel == _store.draftChannelFilter)
                  .toList();
        }

        if (templates.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.messengerBlue.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.article_outlined,
                    size: 40,
                    color: AppColors.messengerBlue.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l.translate('marketing_tv_empty_templates'),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (ctx, constraints) {
            final crossAxisCount =
                constraints.maxWidth > 900
                    ? 4
                    : constraints.maxWidth > 600
                    ? 3
                    : 2;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: templates.length,
              itemBuilder: (ctx, i) => _buildTemplateCard(ctx, templates[i], l),
            );
          },
        );
      },
    );
  }

  Widget _buildTemplateCard(
    BuildContext context,
    MarketingTemplate t,
    AppLocalizations l,
  ) {
    final channelColor = _channelColor(t.channel);
    final channelLabel = _channelLabel(t.channel, l);
    final channelIcon = _channelIcon(t.channel);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    t.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  iconSize: 18,
                  padding: EdgeInsets.zero,
                  itemBuilder:
                      (_) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 16),
                              SizedBox(width: 8),
                              Text('Chỉnh sửa'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outlined,
                                size: 16,
                                color: Colors.red,
                              ),
                              SizedBox(width: 8),
                              Text('Xóa', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                  onSelected: (action) {
                    if (action == 'edit') {
                      _store.initDraftFromTemplate(t);
                      Navigator.pushNamed(
                        context,
                        Routes.templateCreateEdit,
                        arguments: t,
                      ).then((_) => _store.fetchTemplates());
                    } else if (action == 'delete') {
                      _confirmDelete(context, t, l);
                    }
                  },
                ),
              ],
            ),
          ),
          // Platform badge
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: channelColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(channelIcon, size: 12, color: channelColor),
                  const SizedBox(width: 4),
                  Text(
                    channelLabel,
                    style: TextStyle(
                      fontSize: 11,
                      color: channelColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Message count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${t.variableKeys.length} msgs',
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ),
          const SizedBox(height: 8),
          // Preview section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                      ),
                      child: const Text(
                        'XEM TRƯỚC',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          t.content.length > 80
                              ? '${t.content.substring(0, 80)}...'
                              : t.content,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6B7280),
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
    BuildContext ctx,
    MarketingTemplate t,
    AppLocalizations l,
  ) {
    showDialog(
      context: ctx,
      builder:
          (_) => AlertDialog(
            title: const Text('Xóa template'),
            content: Text('Bạn có chắc muốn xóa "${t.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Hủy'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(ctx);
                  _store.deleteTemplate(t.id);
                },
                child: Text(l.translate('marketing_btn_delete_template')),
              ),
            ],
          ),
    );
  }

  String _channelLabel(CampaignChannel ch, AppLocalizations l) {
    switch (ch) {
      case CampaignChannel.messenger:
        return l.translate('marketing_tv_channel_messenger');
      case CampaignChannel.zalo:
        return l.translate('marketing_tv_channel_zalo');
      case CampaignChannel.email:
        return l.translate('marketing_tv_channel_email');
      case CampaignChannel.sms:
        return l.translate('marketing_tv_channel_sms');
    }
  }

  IconData _channelIcon(CampaignChannel ch) {
    switch (ch) {
      case CampaignChannel.messenger:
        return Icons.chat_bubble_outline;
      case CampaignChannel.zalo:
        return Icons.message_outlined;
      case CampaignChannel.email:
        return Icons.email_outlined;
      case CampaignChannel.sms:
        return Icons.sms_outlined;
    }
  }

  Color _channelColor(CampaignChannel ch) {
    switch (ch) {
      case CampaignChannel.messenger:
        return const Color(0xFF1877F2);
      case CampaignChannel.zalo:
        return const Color(0xFF0068FF);
      case CampaignChannel.email:
        return Colors.teal;
      case CampaignChannel.sms:
        return Colors.purple;
    }
  }
}

class _PlatformChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const _PlatformChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : const Color(0xFFD1D5DB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: selected ? color : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: selected ? color : const Color(0xFF374151),
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
