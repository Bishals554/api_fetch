import 'package:api_fetch/main.dart';
import 'package:api_fetch/model/data_model.dart';
import 'package:api_fetch/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  group('ApiService', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late ApiService apiService;

    setUp(() {
      dio = Dio();
      dioAdapter = DioAdapter(dio: dio);
      apiService = ApiService(dio: dio);
    });

    test('returns DataModel when the HTTP call completes successfully',
        () async {
      const data = {
        'status': 'success',
        'data': [
          {
            'id': 1,
            'employee_name': 'Test',
            'employee_salary': 123,
            'employee_age': 23,
            'profile_image': ''
          },
        ],
      };

      dioAdapter.onGet(
        apiService.url,
        (request) => request.reply(200, data),
      );

      expect(await apiService.getData(), isA<DataModel>());
    });

    test('throws an exception when the HTTP call completes with an error',
        () async {
      dioAdapter.onGet(
        apiService.url,
        (request) => request.reply(500, {}),
      );

      expect(apiService.getData(), throwsA(isA<DioException>()));
    });
  });
}
