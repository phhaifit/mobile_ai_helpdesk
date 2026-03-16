import 'package:flutter/material.dart';
import 'package:ai_helpdesk/data/local/mock_data.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/ticket_card_widget.dart';

class TicketListScreen extends StatelessWidget {
  const TicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate mock data for display
    final mockTickets = MockDataGenerator.generateTickets(
      MockDataGenerator.generateAgents(),
      MockDataGenerator.generateCustomers(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
        elevation: 0,
      ),
      body: mockTickets.isEmpty
          ? Center(
              child: Text(
                'No tickets found',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : ListView.builder(
              itemCount: mockTickets.length,
              itemBuilder: (context, index) {
                final ticket = mockTickets[index];
                return TicketCardWidget(
                  ticket: ticket,
                  onTap: () {
                    // TODO: Navigate to ticket detail screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tapped: ${ticket.id}')),
                    );
                  },
                  onDelete: () {
                    // TODO: Delete ticket
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Delete: ${ticket.id}')),
                    );
                  },
                );
              },
            ),
    );
  }
}
