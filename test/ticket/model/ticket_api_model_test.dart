import 'package:ai_helpdesk/data/models/ticket/ticket_api_model.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/ticket_fixtures.dart';

void main() {
  // ---------------------------------------------------------------------------
  // TicketApiModel.fromJson
  // ---------------------------------------------------------------------------

  group('TicketApiModel.fromJson', () {
    test('maps all fields from well-formed JSON', () {
      final model = TicketApiModel.fromJson(kApiTicketJson);

      expect(model.id, kTestTicketId);
      expect(model.title, 'Login issue');
      expect(model.status, 'open');
      expect(model.priority, 'high');
      expect(model.customerId, kTestCustomerId);
      expect(model.channelType, 'web');
      expect(model.createdAt, DateTime.utc(2024, 6, 1, 10, 0, 0));
    });

    test('uses safe defaults for missing fields', () {
      final model = TicketApiModel.fromJson({});

      expect(model.id, '');
      expect(model.title, '');
      expect(model.status, 'open');
      expect(model.priority, 'medium');
      expect(model.customerId, '');
      expect(model.assigneeId, isNull);
      expect(model.channelType, isNull);
    });

    test('parses assigneeId when present', () {
      final model = TicketApiModel.fromJson({
        ...kApiTicketJson,
        'assigneeId': 'agent-007',
      });

      expect(model.assigneeId, 'agent-007');
    });
  });

  // ---------------------------------------------------------------------------
  // TicketApiModel.toDomain — status mapping
  // ---------------------------------------------------------------------------

  group('TicketApiModel.toDomain — status mapping', () {
    TicketStatus statusFor(String raw) =>
        TicketApiModel.fromJson({...kApiTicketJson, 'status': raw})
            .toDomain()
            .status;

    test('"open" → TicketStatus.open', () {
      expect(statusFor('open'), TicketStatus.open);
    });

    test('"pending" → TicketStatus.pending', () {
      expect(statusFor('pending'), TicketStatus.pending);
    });

    test('"solved" → TicketStatus.resolved', () {
      expect(statusFor('solved'), TicketStatus.resolved);
    });

    test('"closed" → TicketStatus.closed', () {
      expect(statusFor('closed'), TicketStatus.closed);
    });

    test('unknown status falls back to open', () {
      expect(statusFor('archived'), TicketStatus.open);
    });
  });

  // ---------------------------------------------------------------------------
  // TicketApiModel.toDomain — priority mapping
  // ---------------------------------------------------------------------------

  group('TicketApiModel.toDomain — priority mapping', () {
    TicketPriority priorityFor(String raw) =>
        TicketApiModel.fromJson({...kApiTicketJson, 'priority': raw})
            .toDomain()
            .priority;

    test('"low" → TicketPriority.low', () {
      expect(priorityFor('low'), TicketPriority.low);
    });

    test('"medium" → TicketPriority.medium', () {
      expect(priorityFor('medium'), TicketPriority.medium);
    });

    test('"high" → TicketPriority.high', () {
      expect(priorityFor('high'), TicketPriority.high);
    });

    test('"urgent" → TicketPriority.urgent', () {
      expect(priorityFor('urgent'), TicketPriority.urgent);
    });

    test('unknown priority falls back to medium', () {
      expect(priorityFor('critical'), TicketPriority.medium);
    });
  });

  // ---------------------------------------------------------------------------
  // TicketApiModel.toDomain — channelType (source) mapping
  // ---------------------------------------------------------------------------

  group('TicketApiModel.toDomain — source mapping', () {
    TicketSource sourceFor(String? raw) => TicketApiModel.fromJson({
          ...kApiTicketJson,
          'channelType': raw,
        }).toDomain().source;

    test('"messenger" → TicketSource.messenger', () {
      expect(sourceFor('messenger'), TicketSource.messenger);
    });

    test('"zalo" → TicketSource.zalo', () {
      expect(sourceFor('zalo'), TicketSource.zalo);
    });

    test('"email" → TicketSource.email', () {
      expect(sourceFor('email'), TicketSource.email);
    });

    test('"phone" → TicketSource.phone', () {
      expect(sourceFor('phone'), TicketSource.phone);
    });

    test('"web" → TicketSource.web', () {
      expect(sourceFor('web'), TicketSource.web);
    });

    test('null channelType falls back to web', () {
      expect(sourceFor(null), TicketSource.web);
    });

    test('unknown channelType falls back to web', () {
      expect(sourceFor('telegram'), TicketSource.web);
    });
  });

  // ---------------------------------------------------------------------------
  // TicketApiModel.toDomain — field mapping
  // ---------------------------------------------------------------------------

  group('TicketApiModel.toDomain — full mapping', () {
    test('domain ticket has correct id and title', () {
      final ticket = TicketApiModel.fromJson(kApiTicketJson).toDomain();

      expect(ticket.id, kTestTicketId);
      expect(ticket.title, 'Login issue');
      expect(ticket.customerId, kTestCustomerId);
    });

    test('assignedAgentId is propagated', () {
      final ticket = TicketApiModel.fromJson({
        ...kApiTicketJson,
        'assigneeId': 'agent-007',
      }).toDomain();

      expect(ticket.assignedAgentId, 'agent-007');
    });

    test('missing assigneeId → assignedAgentId is null', () {
      final ticket = TicketApiModel.fromJson(kApiTicketJson).toDomain();

      expect(ticket.assignedAgentId, isNull);
    });
  });
}
