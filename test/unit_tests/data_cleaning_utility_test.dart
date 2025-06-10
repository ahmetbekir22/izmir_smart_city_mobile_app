import 'package:flutter_test/flutter_test.dart';
import 'package:smart_city_app/utils/data_cleaning_utility.dart';

void main() {
  test('cleanHtmlText should remove HTML tags', () {
    final input = '<p>Test</p>';
    final expected = 'Test';
    expect(DataCleaningUtility.cleanHtmlText(input), equals(expected));
  });
}