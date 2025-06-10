import 'package:flutter_test/flutter_test.dart';
import 'package:smart_city_app/core/coordiantes_calculations.dart';

void main() {
  test('openMapWithCoordinates should open map', () async {
    await openMapWithCoordinates('38.4192', '27.1287');
    // Bu test, harita açma işlevselliğini kontrol eder.
  });
}