import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/presentation/ticket/screens/create_ticket_screen.dart';
import 'package:ai_helpdesk/presentation/ticket/store/create_ticket_store.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_tab_store.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

/// Ticket list screen — clean redesign that avoids `ElevatedButton`/`OutlinedButton`.
///
/// The app theme sets `minimumSize: Size.fromHeight(N)` (= `Size(infinity, N)`)
/// for those Material buttons, which is fine for login/register forms but
/// crashes any button placed inside a Row (infinite width). This screen uses
/// `InkWell` + `Container` for tabs + the add button so it doesn't depend on
/// the global button theme.
class TicketListScreen extends StatefulWidget {
  /// Tap callback for the hamburger button. Wired from [MainScreen] so the
  /// mobile-side drawer can be toggled from this screen's header. When null
  /// (e.g. desktop or standalone navigation), the hamburger is hidden.
  final VoidCallback? onMenuTap;

  const TicketListScreen({super.key, this.onMenuTap});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  late final TicketTabStore _store;
  late final CreateTicketStore _createTicketStore;

  @override
  void initState() {
    super.initState();
    _store = GetIt.instance<TicketTabStore>();
    _createTicketStore = GetIt.instance<CreateTicketStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Observer(
          builder: (_) {
            if (_store.isCreateMode) {
              return CreateTicketScreenBody(
                store: _createTicketStore,
                onCreated: (_) async {
                  await _store.loadTickets();
                },
                onClose: _store.closeCreateMode,
              );
            }
            return Column(
              children: [
                _header(),
                _tabSelector(),
                Expanded(child: _body()),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Header (title + count + add button) ──────────────────────────────────

  Widget _header() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Hamburger to open the MainScreen sidebar (mobile). Hidden on
          // desktop where the sidebar is always visible (widget.onMenuTap == null).
          if (widget.onMenuTap != null)
            IconButton(
              icon: const Icon(Icons.menu, color: AppColors.textPrimary),
              onPressed: widget.onMenuTap,
              tooltip: 'Mở menu',
            ),
          if (widget.onMenuTap == null) const SizedBox(width: 8),
          Expanded(
            child: Observer(
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _store.tabTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_store.ticketCount} phiếu',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Custom add button — Material + InkWell instead of ElevatedButton
          // to bypass the global button-theme `minimumSize` crash.
          Material(
            color: AppColors.primaryBlue,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _store.openCreateMode,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.add, color: Colors.white, size: 22),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  // ── Tab selector (3 pills) ───────────────────────────────────────────────

  Widget _tabSelector() {
    const titles = ['Phiếu của tôi', 'Chưa tiếp nhận', 'Tất cả phiếu'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Observer(
        builder: (_) => Row(
          children: List.generate(titles.length, (i) {
            final selected = _store.selectedTabIndex == i;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < titles.length - 1 ? 6 : 0),
                child: InkWell(
                  onTap: () => _store.setSelectedTab(i),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primaryBlue
                          : const Color(0xFFEFF1F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      titles[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── Body (loading / error / empty / list) ────────────────────────────────

  Widget _body() {
    return Observer(
      builder: (_) {
        if (_store.isLoading && _store.filteredTickets.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_store.errorMessage != null && _store.filteredTickets.isEmpty) {
          return _errorState();
        }
        if (_store.filteredTickets.isEmpty) {
          return _emptyState();
        }
        return RefreshIndicator(
          onRefresh: () => _store.loadTickets(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount:
                _store.filteredTickets.length + (_store.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _store.filteredTickets.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }
              if (index == _store.filteredTickets.length - 1 &&
                  _store.hasMore &&
                  !_store.isLoadingMore) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _store.loadMore();
                });
              }
              return _ticketCard(_store.filteredTickets[index]);
            },
          ),
        );
      },
    );
  }

  Widget _errorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Color(0xFFDC2626)),
            const SizedBox(height: 12),
            const Text(
              'Không tải được danh sách phiếu',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _store.errorMessage ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _store.loadTickets(),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Thử lại',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Color(0xFFB8C0CC)),
            SizedBox(height: 12),
            Text(
              'Chưa có phiếu nào',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Bấm nút + ở trên cùng để tạo phiếu mới.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  // ── Ticket card ──────────────────────────────────────────────────────────

  Widget _ticketCard(Ticket ticket) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.ticketDetail,
            arguments: ticket.id,
          ).then((_) => _store.loadTickets());
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      ticket.title.isEmpty
                          ? '(Không có tiêu đề)'
                          : ticket.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _statusChip(ticket.status),
                ],
              ),
              if (ticket.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  ticket.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 14,
                    color: Color(0xFF8B95A1),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      ticket.customerName.isEmpty
                          ? 'Không xác định'
                          : ticket.customerName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _priorityChip(ticket.priority),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 12,
                    color: Color(0xFF8B95A1),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(ticket.createdAt),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8B95A1),
                    ),
                  ),
                  const Spacer(),
                  if (ticket.assignedAgentId != null &&
                      ticket.assignedAgentId!.isNotEmpty)
                    Text(
                      ticket.assignedAgentName ?? 'Đã giao',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8B95A1),
                      ),
                    )
                  else
                    const Text(
                      'Chưa giao',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFD97706),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Chips ────────────────────────────────────────────────────────────────

  Widget _statusChip(TicketStatus status) {
    final v = _statusVisual(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: v.$2.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        v.$1,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: v.$2,
        ),
      ),
    );
  }

  (String, Color) _statusVisual(TicketStatus s) {
    switch (s) {
      case TicketStatus.open:
        return ('Mở', const Color(0xFF2563EB));
      case TicketStatus.pending:
        return ('Chờ', const Color(0xFFD97706));
      case TicketStatus.inProgress:
        return ('Đang XL', const Color(0xFF7C3AED));
      case TicketStatus.resolved:
        return ('Đã GQ', const Color(0xFF059669));
      case TicketStatus.closed:
        return ('Đã đóng', const Color(0xFF6B7280));
      case TicketStatus.processingByAI:
        return ('AI', const Color(0xFF0EA5E9));
    }
  }

  Widget _priorityChip(TicketPriority p) {
    final v = _priorityVisual(p);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: v.$2.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        v.$1,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: v.$2,
        ),
      ),
    );
  }

  (String, Color) _priorityVisual(TicketPriority p) {
    switch (p) {
      case TicketPriority.low:
        return ('Thấp', const Color(0xFF6B7280));
      case TicketPriority.medium:
        return ('TB', const Color(0xFF2563EB));
      case TicketPriority.high:
        return ('Cao', const Color(0xFFD97706));
      case TicketPriority.urgent:
        return ('Khẩn', const Color(0xFFDC2626));
    }
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
