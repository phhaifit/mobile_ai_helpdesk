import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/apis/ticket/ticket_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

class _MockDioClient extends Mock implements DioClient {}

void main() {
  late _MockDio dio;
  late _MockDioClient client;
  late TicketApi api;

  setUp(() {
    dio = _MockDio();
    client = _MockDioClient();
    when(() => client.dio).thenReturn(dio);
    api = TicketApi(client);
  });

  group('TicketApi.getCustomerTickets', () {
    test('parses {data: {tickets: [...]}} envelope on 200 OK', () async {
      when(() => dio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {
            'status': 'OK',
            'data': {
              'tickets': [
                {'id': 'tkt_1', 'title': 'Lỗi A', 'status': 'open'},
                {'id': 'tkt_2', 'title': 'Lỗi B', 'status': 'solved'},
              ],
              'total': 2,
            },
          },
        ),
      );

      final result = await api.getCustomerTickets('cust_1');
      expect(result.length, 2);
      expect(result.first.id, 'tkt_1');
    });

    test('returns empty list when BE answers 404 with data:[] (no history)', () async {
      when(() => dio.get(any(), queryParameters: any(named: 'queryParameters'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 404,
            data: {'status': 'NOT_FOUND', 'data': []},
          ),
        ),
      );

      final result = await api.getCustomerTickets('cust_1');
      expect(result, isEmpty);
    });

    test('rethrows on 404 without the empty-history shape (route missing)', () async {
      when(() => dio.get(any(), queryParameters: any(named: 'queryParameters'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 404,
            data: 'Not Found',
          ),
        ),
      );

      expect(() => api.getCustomerTickets('cust_1'), throwsA(isA<DioException>()));
    });
  });
}
