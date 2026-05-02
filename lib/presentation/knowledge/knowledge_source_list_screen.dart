import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/presentation/knowledge/add_source/add_source_type_screen.dart';
import 'package:ai_helpdesk/presentation/knowledge/config/crawl_interval_config_screen.dart';
import 'package:ai_helpdesk/presentation/knowledge/store/knowledge_store.dart';
import 'package:ai_helpdesk/presentation/knowledge/widgets/source_list_card.dart';
import 'package:ai_helpdesk/presentation/knowledge/widgets/source_type_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// Knowledge sources list — entry point of the Knowledge Base feature.
///
/// Wires the store to:
///   * pull-to-refresh (`loadSources`),
///   * type filter pills,
///   * per-card actions (reindex / delete / configure interval),
///   * live status mode indicator (SSE / polling / disconnected),
///   * an "add source" bottom sheet that pushes the matching form screen.
class KnowledgeSourceListScreen extends StatefulWidget {
  final bool embedded;
  final VoidCallback? onMenuTap;

  const KnowledgeSourceListScreen({
    super.key,
    this.embedded = false,
    this.onMenuTap,
  });

  @override
  State<KnowledgeSourceListScreen> createState() =>
      _KnowledgeSourceListScreenState();
}

class _KnowledgeSourceListScreenState
    extends State<KnowledgeSourceListScreen> {
  static const _accent = Color(0xFF1A73E8);

  final KnowledgeStore _store = getIt<KnowledgeStore>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _store.loadSources();
    });
  }

  @override
  void dispose() {
    _store.stopLiveStatus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 8),
          Observer(
            builder: (_) => SourceTypeFilterBar(
              selected: _store.typeFilter,
              onSelected: _store.setTypeFilter,
            ),
          ),
          Observer(builder: (_) => _liveStatusStrip(_store.liveStatusMode)),
          Expanded(
            child: Observer(builder: (_) {
              if (_store.isLoading && _store.sources.isEmpty) {
                return _buildSkeletonList();
              }
              if (_store.tenantMissing) {
                return _buildTenantMissing();
              }
              if (_store.errorMessage != null && _store.sources.isEmpty) {
                return _buildError(_store.errorMessage!);
              }
              if (_store.visibleSources.isEmpty) {
                return _buildEmpty();
              }
              return RefreshIndicator(
                onRefresh: _store.loadSources,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100, top: 4),
                  itemCount: _store.visibleSources.length,
                  itemBuilder: (context, index) {
                    final source = _store.visibleSources[index];
                    return Observer(
                      builder: (_) => SourceListCard(
                        source: source,
                        isBusy: _store.busySourceIds.contains(source.id),
                        onConfigureInterval: () => _configureInterval(source),
                        onReindex: () => _reindex(source),
                        onDelete: () => _confirmDelete(source),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );

    if (widget.embedded) return body;

    return Scaffold(
      appBar: AppBar(title: const Text('Nạp kiến thức')),
      body: body,
    );
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
      child: Row(
        children: [
          if (widget.onMenuTap != null)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: widget.onMenuTap,
            ),
          const Expanded(
            child: Text(
              'Nạp kiến thức',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          FilledButton.icon(
            onPressed: _openAddSource,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Thêm nguồn'),
            style: FilledButton.styleFrom(backgroundColor: _accent),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Live status strip — SSE / polling indicator
  // ---------------------------------------------------------------------------

  Widget _liveStatusStrip(LiveStatusMode mode) {
    if (mode == LiveStatusMode.disconnected) return const SizedBox.shrink();
    final isPolling = mode == LiveStatusMode.polling;
    final fg = isPolling ? const Color(0xFF7C3AED) : const Color(0xFF1A73E8);
    final bg = isPolling
        ? const Color(0xFF7C3AED).withValues(alpha: 0.08)
        : const Color(0xFF1A73E8).withValues(alpha: 0.08);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              valueColor: AlwaysStoppedAnimation(fg),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isPolling ? 'Đang cập nhật trạng thái…' : 'Đang theo dõi trực tiếp',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // States: skeleton / empty / error
  // ---------------------------------------------------------------------------

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: 5,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        height: 110,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                size: 48, color: Color(0xFFDC2626)),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _store.loadSources,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTenantMissing() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspaces_outline,
                size: 36,
                color: _accent,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tài khoản chưa thuộc tenant nào',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Knowledge Base yêu cầu tenant gắn với tài khoản. '
              'Vui lòng liên hệ quản trị viên để được cấp quyền truy cập tenant. '
              'Sau khi admin cấp xong, nhấn "Tải lại hồ sơ" để cập nhật.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _onRefreshTenant,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Tải lại hồ sơ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefreshTenant() async {
    await _store.refreshTenantFromAccount();
    if (!mounted) return;
    if (_store.tenantMissing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tài khoản vẫn chưa được gán tenant. '
            'Vui lòng liên hệ quản trị viên.',
          ),
        ),
      );
    }
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hub_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _store.typeFilter == null
                ? 'Chưa có nguồn dữ liệu nào'
                : 'Chưa có nguồn nào ở loại này',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhấn "Thêm nguồn" để bắt đầu',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _openAddSource,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Thêm nguồn'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  void _openAddSource() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddSourceTypeScreen(store: _store),
    );
  }

  Future<void> _reindex(KnowledgeSource source) async {
    await _store.reindex(source.id);
    if (!mounted) return;
    final err = _store.errorMessage;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(err == null
            ? 'Đã yêu cầu reindex "${source.name}"'
            : 'Reindex thất bại: $err'),
        backgroundColor: err == null ? null : const Color(0xFFDC2626),
      ),
    );
  }

  Future<void> _configureInterval(KnowledgeSource source) async {
    final selected = await Navigator.of(context).push<CrawlInterval>(
      MaterialPageRoute(
        builder: (_) =>
            CrawlIntervalConfigScreen(current: source.interval),
      ),
    );
    if (!mounted || selected == null || selected == source.interval) return;
    await _store.updateInterval(source.id, selected);
    if (!mounted) return;
    final err = _store.errorMessage;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(err == null
            ? 'Đã cập nhật tần suất cho "${source.name}"'
            : err),
        backgroundColor: err == null ? null : const Color(0xFFDC2626),
      ),
    );
  }

  Future<void> _confirmDelete(KnowledgeSource source) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text(
          'Bạn có chắc muốn xóa nguồn "${source.name}"? '
          'Mọi dữ liệu đã index sẽ bị xóa vĩnh viễn.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _store.deleteSource(source.id);
    if (!mounted) return;
    final err = _store.errorMessage;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể xóa: $err'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    }
  }
}
