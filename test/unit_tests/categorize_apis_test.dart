import 'package:flutter_test/flutter_test.dart';
import 'package:smart_city_app/core/categorize_apis.dart';

void main() {
  test('categorizedApis should be defined', () {
    expect(categorizedApis, isNotEmpty);
  });

  test('categoryKeys should be defined', () {
    expect(categoryKeys, isNotEmpty);
  });
}