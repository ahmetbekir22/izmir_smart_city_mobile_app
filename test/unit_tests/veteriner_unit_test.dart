import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import 'package:smart_city_app/controllers/veteriner_controllers/veteriner_controller.dart';
import 'package:smart_city_app/core/api/veteriner_api/veteriner_model.dart';
import 'package:smart_city_app/core/api/veteriner_api/veteriner_service.dart';

import 'veteriner_unit_test.mocks.dart';

@GenerateMocks([VeterinerApiService, MapController])
void main() {
  late VeterinerController controller;
  late MockVeterinerApiService mockApiService;
  late MockMapController mockMap;

  final sampleData = [
    Onemliyer(
      iLCE: 'Konak',
      kAPINO: '10',
      eNLEM: 38.4192,
      aCIKLAMA: 'Açıklama',
      iLCEID: '1',
      mAHALLE: 'Alsancak',
      aDI: 'VetCenter',
      bOYLAM: 27.1287,
      yOL: 'Birinci Cadde',
    ),
  ];

  setUp(() {
    mockApiService = MockVeterinerApiService();
    mockMap = MockMapController();

    controller = VeterinerController();
    controller.apiService = mockApiService;
    controller.mapController = mockMap;
  });

  tearDown(() {
    Get.reset();
  });

  test(
    'fetchVeterinerData - hata oluşursa errorMessage atanır ve marker eklenmez',
    () async {
      // API hata fırlatacak
      when(mockApiService.fetchVeteriner()).thenThrow(Exception('API failed'));

      await controller.fetchVeterinerData();

      // Hata mesajı atanmış mı?
      expect(
        controller.errorMessage.value,
        contains('Veriler alınırken bir hata oluştu'),
      );
      // Liste boş kalmalı
      expect(controller.veterinerList, isEmpty);
      // Marker ekleme çağrısı yapılmamalı
      verifyNever(
        mockMap.addMarkers(
          locations: anyNamed('locations'),
          getLatitude: anyNamed('getLatitude'),
          getLongitude: anyNamed('getLongitude'),
          getTitle: anyNamed('getTitle'),
          getSnippet: anyNamed('getSnippet'),
        ),
      );
    },
  );

  test('fetchVeterinerData - başarıyla veri çeker ve marker ekler', () async {
    when(mockApiService.fetchVeteriner()).thenAnswer((_) async => sampleData);

    await controller.fetchVeterinerData();

    expect(controller.veterinerList, sampleData);
    expect(controller.errorMessage.value, '');

    verify(mockMap.addMarkers(
      locations: sampleData,
      getLatitude: anyNamed('getLatitude'),
      getLongitude: anyNamed('getLongitude'),
      getTitle: anyNamed('getTitle'),
      getSnippet: anyNamed('getSnippet'),
    )).called(1);
  });
}
