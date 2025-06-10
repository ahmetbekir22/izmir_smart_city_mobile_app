import 'package:flutter_test/flutter_test.dart';
import 'package:smart_city_app/utils/making_data_unique.dart';

void main() {
  test('filterUniqueById should remove duplicates', () {
    final input = [1, 2, 2, 3, 3, 4];
    final expected = [1, 2, 3, 4];
    expect(filterUniqueById(input, (item) => item), equals(expected));
  });
}