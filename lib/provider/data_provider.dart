import 'package:api_fetch/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataProvider = FutureProvider((ref) async {
  return ref.watch(dataProvider).getData();
});
