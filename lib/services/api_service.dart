import 'dart:io';

import 'package:api_fetch/model/data_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataProvider = Provider<ApiService>((ref) => ApiService());

class ApiService {
  final dio = Dio();
  String url = 'https://dummy.restapiexample.com/api/v1/employees';

  Future<DataModel?> getData() async {
    try {
      final response = await dio.get(url);
      print(response.data);
      print(response.statusCode);

      if (response.statusCode == HttpStatus.ok) {
        return DataModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      if (e is DioException &&
          e.response?.statusCode == HttpStatus.tooManyRequests) {
        // Retry after a short delay
        await Future.delayed(Duration(seconds: 5));
      } else {
        rethrow; // Rethrow the exception if it's not a 429 error
      }
    }
    return null;
  }
}
