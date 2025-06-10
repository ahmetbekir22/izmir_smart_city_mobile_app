import 'package:flutter_test/flutter_test.dart';
import 'package:smart_city_app/core/api/toilet_service.dart';

void main() {
  late CkanProvider toiletService;

  setUp(() {
    toiletService = CkanProvider();
  });

  test('getToilets should return a list of toilets', () async {
    final toilets = await toiletService.getToilets();
    expect(toilets, isNotEmpty);
  });
}