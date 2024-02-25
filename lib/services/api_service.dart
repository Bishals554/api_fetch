import 'dart:io';

import 'package:api_fetch/model/data_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataProvider = Provider<ApiService>((ref) => ApiService(dio: Dio()));

class ApiService {
  Dio dio;
  String url = 'https://dummy.restapiexample.com/api/v1/employees';
  ApiService({required this.dio});

  set userData(DataModel userData) {}
  Future<DataModel?> getData() async {
    try {
      final response = await dio.get(url);

      if (response.statusCode == HttpStatus.ok) {
        return DataModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
