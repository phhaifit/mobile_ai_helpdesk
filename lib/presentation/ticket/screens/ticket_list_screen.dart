import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_tab_store.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/ticket_tab_bar_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/ticket_header_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/ticket_search_filter_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/ticket_table_widget.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  late final TicketTabStore _store;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _store = GetIt.instance<TicketTabStore>();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Tab bar
            Observer(
              builder: (_) => TicketTabBarWidget(
                selectedTabIndex: _store.selectedTabIndex,
                onTabChanged: _store.setSelectedTab,
              ),
            ),

            // Header with title and action buttons
            Observer(
              builder: (_) => TicketHeaderWidget(
                tabTitle: _store.tabTitle,
                ticketCount: _store.ticketCount,
                onExportPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Xuất Excel: Tính năng đang phát triển')),
                  );
                },
                onAddTicketPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thêm phiếu: Tính năng đang phát triển')),
                  );
                },
              ),
            ),

            // Search and filter + Table with tickets (grouped)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.dividerColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    // Search and filter
                    TicketSearchFilterWidget(
                      searchController: _searchController,
                      onSearchChanged: _store.setSearchQuery,
                      onFilterPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Bộ lọc: Tính năng đang phát triển'),
                          ),
                        );
                      },
                    ),

                    // Divider
                    Container(
                      height: 1,
                      color: AppColors.dividerColor,
                    ),

                    // Table with tickets
                    Expanded(
                      child: Observer(
                        builder: (_) => TicketTableWidget(
                          tickets: _store.filteredTickets,
                          onAcceptTicket: (ticket) {
                            _store.acceptTicket(ticket);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Tiếp nhận phiếu: ${ticket.id}'),
                              ),
                            );
                          },
                          onViewDetails: (ticket) {
                            _store.viewTicketDetails(ticket);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Xem chi tiết phiếu: ${ticket.id}'),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
