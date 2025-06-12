import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import 'package:smart_city_app/controllers/pazar_yer_controllers/pazar_yeri_controller.dart';
import 'package:smart_city_app/core/api/pazarYeri/pazar_yeri_api_service.dart';
import 'package:smart_city_app/core/api/pazarYeri/pazar_yeri_api_model.dart';

import 'pazar_yeri_unit_test.mocks.dart';

@GenerateMocks([PazarYeriApiService, MapController])
void main() {
  late PazarYeriController controller;
  late MockPazarYeriApiService mockService;
  late MockMapController mockMap;

  final sample = [
    Onemliyer(
        iLCE: 'A',
        kAPINO: '1',
        eNLEM: 1.0,
        aCIKLAMA: '',
        iLCEID: '',
        mAHALLE: 'X',
        aDI: 'D1',
        bOYLAM: 2.0,
        yOL: ''),
    Onemliyer(
        iLCE: 'B',
        kAPINO: '2',
        eNLEM: 3.0,
        aCIKLAMA: '',
        iLCEID: '',
        mAHALLE: 'Y',
        aDI: 'D2',
        bOYLAM: 4.0,
        yOL: ''),
  ];

  setUp(() {
    mockService = MockPazarYeriApiService();
    mockMap = MockMapController();

    //  Disable automatic onInit fetch so tests start clean:
    controller = PazarYeriController(
      apiService: mockService,
      mapController: mockMap,
      autoFetchOnInit: false,
    );
  });

  tearDown(() {
    reset(mockService);
    reset(mockMap);
    Get.reset(); // clear any leftover Get.put()
  });

  group('fetchPazarYerleri', () {
    test('sets loading, fetches data, populates list and adds markers',
        () async {
      when(mockService.getPazarYerleri()).thenAnswer((_) async => sample);

      // initial state
      expect(controller.isLoading.value, isFalse);
      expect(controller.pazarYerleri, isEmpty);

      // call
      final call = controller.fetchPazarYerleri();
      expect(controller.isLoading.value, isTrue);

      await call;

      expect(controller.isLoading.value, isFalse);
      expect(controller.pazarYerleri, sample);

      verify(mockMap.addMarkers(
        locations: sample,
        getLatitude: anyNamed('getLatitude'),
        getLongitude: anyNamed('getLongitude'),
        getTitle: anyNamed('getTitle'),
        getSnippet: anyNamed('getSnippet'),
      )).called(1);
    });

    test('on error, still stops loading and does not add markers', () async {
      when(mockService.getPazarYerleri()).thenThrow(Exception('fail'));

      expectLater(
        controller.isLoading.stream,
        emitsInOrder([true, false]),
      );

      await controller.fetchPazarYerleri();

      expect(controller.pazarYerleri, isEmpty);
      verifyNever(mockMap.addMarkers(
        locations: anyNamed('locations'),
        getLatitude: anyNamed('getLatitude'),
        getLongitude: anyNamed('getLongitude'),
        getTitle: anyNamed('getTitle'),
        getSnippet: anyNamed('getSnippet'),
      ));
    });
  });

  group('extractDay', () {
    test('finds and capitalizes weekday names', () {
      expect(controller.extractDay('her Pazartesi büyük pazar kurulur'),
          'Pazartesi');
      expect(controller.extractDay('salı günü'), 'Salı');
      expect(controller.extractDay('bir şey'), 'Gün Bilinmiyor');
      expect(controller.extractDay(null), 'Gün Bilinmiyor');
    });
  });

  group('filterByIlce', () {
    test('filters pazarYerleri by iLCE', () {
      controller.pazarYerleri.assignAll(sample);
      controller.filterByIlce('B');
      expect(controller.filteredPazarYerleri, [sample[1]]);
    });

    test('empty result when none match', () {
      controller.pazarYerleri.assignAll(sample);
      controller.filterByIlce('Z');
      expect(controller.filteredPazarYerleri, isEmpty);
    });
  });
}
