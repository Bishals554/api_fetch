import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:api_fetch/model/data_model.dart';
import 'package:api_fetch/services/api_service.dart';

void main() {
  group('ApiService', () {
    test('getData returns DataModel when HTTP status code is 200', () async {
      final container = ProviderContainer(overrides: [
        dataProvider.overrideWithValue(ApiService()),
      ]);

      final result = await container.read(dataProvider).getData();

      expect(result, isA<DataModel>());
    });
    test('getData returns null when HTTP status code is not 200', () async {
      final container = ProviderContainer(overrides: [
        dataProvider.overrideWithValue(ApiService()),
      ]);
      final result = await container.read(dataProvider).getData();

      expect(result, isNull);
    });
  });
}
