import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/apis/customer/customer_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}
class MockDioClient extends Mock implements DioClient {}

void main() {
  late CustomerApi customerApi;
  late MockDio mockDio;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDio = MockDio();
    mockDioClient = MockDioClient();
    when(() => mockDioClient.dio).thenReturn(mockDio);
    customerApi = CustomerApi(mockDioClient);
  });

  group('CustomerApi Tests', () {
    test('getCustomers calls correct endpoint and returns list', () async {
      final mockResponse = {
        'status': 'OK',
        'data': [
          {'customerID': '1', 'name': 'User 1'},
          {'customerID': '2', 'name': 'User 2'},
        ]
      };

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: mockResponse,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await customerApi.getCustomers(limit: 10, offset: 0);

      expect(result.length, 2);
      expect(result.first.customerID, '1');
      verify(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).called(1);
    });

    test('checkEmailAvailability returns true for NOT_FOUND', () async {
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {'status': 'NOT_FOUND'},
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await customerApi.checkEmailAvailability('test@example.com');
      expect(result, isTrue);
    });

    test('checkEmailAvailability returns true for DioException 404', () async {
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 404,
          data: {'status': 'NOT_FOUND'},
          requestOptions: RequestOptions(path: ''),
        ),
      ));

      final result = await customerApi.checkEmailAvailability('test@example.com');
      expect(result, isTrue);
    });

    test('createCustomer calls POST and returns DTO', () async {
      final mockData = {'customerID': 'new_id', 'name': 'New User'};
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {'status': 'OK', 'data': mockData},
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await customerApi.createCustomer(name: 'New User', email: 'test@test.com');
      
      expect(result.customerID, 'new_id');
      verify(() => mockDio.post(any(), data: any(named: 'data'))).called(1);
    });
  });
}
