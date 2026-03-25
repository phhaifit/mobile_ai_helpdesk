import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/presentation/knowledge/add_source/add_source_type_screen.dart';
import 'package:ai_helpdesk/presentation/knowledge/store/knowledge_store.dart';
import 'package:ai_helpdesk/presentation/knowledge/widgets/source_list_card.dart';
import 'package:ai_helpdesk/presentation/knowledge/widgets/source_type_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class KnowledgeSourceListScreen extends StatefulWidget {
  final bool embedded;
  final VoidCallback? onMenuTap;
  const KnowledgeSourceListScreen({super.key, this.embedded = false, this.onMenuTap});

  @override
  State<KnowledgeSourceListScreen> createState() =>
      _KnowledgeSourceListScreenState();
}

class _KnowledgeSourceListScreenState
    extends State<KnowledgeSourceListScreen> {
  final KnowledgeStore _store = getIt<KnowledgeStore>();

  @override
  void initState() {
    super.initState();
    _store.loadSources();
  }

  @override
  Widget build(BuildContext context) {
    final body = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
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
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1A73E8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Observer(
            builder: (_) => SourceTypeFilterBar(
              selected: _store.selectedCategory,
              onSelected: _store.filterByCategory,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Observer(builder: (_) {
              if (_store.isLoading && _store.sources.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_store.errorMessage != null && _store.sources.isEmpty) {
                return _buildError();
              }
              if (_store.filteredSources.isEmpty) {
                return _buildEmpty();
              }
              return RefreshIndicator(
                onRefresh: _store.loadSources,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: _store.filteredSources.length,
                  itemBuilder: (context, index) {
                    final source = _store.filteredSources[index];
                    return SourceListCard(
                      source: source,
                      onReindex: () => _reindex(source),
                      onDelete: () => _confirmDelete(source),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );

    if (widget.embedded) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nạp kiến thức')),
      body: body,
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(_store.errorMessage ?? 'Đã xảy ra lỗi'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _store.loadSources,
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hub_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Chưa có nguồn dữ liệu nào',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhấn "Thêm nguồn" để bắt đầu',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _openAddSource() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddSourceTypeScreen(store: _store),
    );
  }

  Future<void> _reindex(KnowledgeSource source) async {
    await _store.reindexSource(source.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đang reindex "${source.name}"...'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _confirmDelete(KnowledgeSource source) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa nguồn "${source.name}"?'),
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
    if (confirmed == true) {
      await _store.deleteSource(source.id);
    }
  }
}
