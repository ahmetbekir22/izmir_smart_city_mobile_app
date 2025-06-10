import 'package:flutter_test/flutter_test.dart';
import 'package:smart_city_app/utils/generic_functions.dart';

void main() {
  test('formatDate should return formatted date string', () {
    final date = '2023-01-01';
    expect(EventUtils.formatDate(date), equals('01 Ocak 2023 - 00:00'));
  });
}