// test/unit_tests/antik_kent_unit_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_city_app/controllers/antik_yerler_controllers/antik_controller.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import 'package:smart_city_app/core/api/antik_api/antik_model.dart';
import 'package:smart_city_app/core/api/antik_api/antik_service.dart';

class MockAntikApiService extends Mock implements AntikApiService {}
class MockMapController extends Mock implements MapController {}

void main() {
  late AntikController controller;
  late MockAntikApiService mockApiService;
  late MockMapController mockMapController;

  final dummyList = <Onemliyer>[
    Onemliyer(
      iLCE: 'Selçuk',
      kAPINO: '12',
      eNLEM: 37.95,
      aCIKLAMA: 'Efes antik kenti',
      iLCEID: '1',
      mAHALLE: 'İsabey',
      aDI: 'Efes',
      bOYLAM: 27.37,
      yOL: 'Antik Yolu',
    ),
    Onemliyer(
      iLCE: 'Bergama',
      kAPINO: '23',
      eNLEM: 39.12,
      aCIKLAMA: 'Pergamon antik kenti',
      iLCEID: '2',
      mAHALLE: 'Akropol',
      aDI: 'Pergamon',
      bOYLAM: 27.18,
      yOL: 'Antik Yol',
    ),
  ];

  setUp(() {
    mockApiService = MockAntikApiService();
    mockMapController = MockMapController();
    controller = AntikController(
      apiService: mockApiService,
      mapController: mockMapController,
    );
  });

  tearDown(() {
    reset(mockApiService);
    reset(mockMapController);
  });

  group('AntikController State Management', () {
    test('Initial state should be correct', () {
      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isEmpty);
      expect(controller.antikList, isEmpty);
    });

    test('Loading state should be true while fetching data', () async {
      when(mockApiService.fetchAntikKentler())
          .thenAnswer((_) async => dummyList);

      final future = controller.fetchAntikData();
      expect(controller.isLoading.value, isTrue);
      await future;
    });
  });

  group('AntikController.fetchAntikData', () {
    test('should successfully fetch and process antik data', () async {
      when(mockApiService.fetchAntikKentler())
          .thenAnswer((_) async => dummyList);

      await controller.fetchAntikData();

      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isEmpty);
      expect(controller.antikList, dummyList);
      expect(controller.antikList.length, 2);

      verify(() => mockMapController.addMarkers(
            locations: dummyList,
            getLatitude: (dynamic item) => (item as Onemliyer).eNLEM ?? 0.0,
            getLongitude: (dynamic item) => (item as Onemliyer).bOYLAM ?? 0.0,
            getTitle: (dynamic item) => (item as Onemliyer).aDI ?? '',
            getSnippet: (dynamic item) => (item as Onemliyer).aCIKLAMA ?? '',
          )).called(1);
    });

    test('should handle empty response correctly', () async {
      when(mockApiService.fetchAntikKentler())
          .thenAnswer((_) async => <Onemliyer>[]);

      await controller.fetchAntikData();

      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isEmpty);
      expect(controller.antikList, isEmpty);
    });

    test('should handle API error and set appropriate error message', () async {
      when(mockApiService.fetchAntikKentler())
          .thenThrow(Exception('API error'));

      await controller.fetchAntikData();

      expect(controller.isLoading.value, isFalse);
      expect(controller.antikList, isEmpty);
      expect(
        controller.errorMessage.value,
        contains('Veriler alınırken bir hata oluştu'),
      );

      verifyNever(() => mockMapController.addMarkers(
            locations: dummyList,
            getLatitude: (dynamic item) => (item as Onemliyer).eNLEM ?? 0.0,
            getLongitude: (dynamic item) => (item as Onemliyer).bOYLAM ?? 0.0,
            getTitle: (dynamic item) => (item as Onemliyer).aDI ?? '',
            getSnippet: (dynamic item) => (item as Onemliyer).aCIKLAMA ?? '',
          ));
    });
  });

  group('Onemliyer Model', () {
    test('should correctly parse from JSON with valid data', () {
      final json = {
        'ILCE': 'Bergama',
        'KAPINO': '23',
        'ENLEM': '39.1200',
        'ACIKLAMA': 'Pergamon',
        'ILCEID': '3',
        'MAHALLE': 'Akropol',
        'ADI': 'Pergamon',
        'BOYLAM': '27.1800',
        'YOL': 'Antik Yol',
      };
      final yer = Onemliyer.fromJson(json);

      expect(yer.iLCE, 'Bergama');
      expect(yer.aDI, 'Pergamon');
      expect(yer.eNLEM, 39.1200);
      expect(yer.bOYLAM, 27.1800);
      expect(yer.aCIKLAMA, 'Pergamon');
      expect(yer.mAHALLE, 'Akropol');
    });

    test('should handle invalid coordinate values in JSON', () {
      final json = {
        'ILCE': 'Bergama',
        'KAPINO': '23',
        'ENLEM': 'invalid',
        'ACIKLAMA': 'Pergamon',
        'ILCEID': '3',
        'MAHALLE': 'Akropol',
        'ADI': 'Pergamon',
        'BOYLAM': 'invalid',
        'YOL': 'Antik Yol',
      };
      
      expect(() => Onemliyer.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('should handle null values in JSON', () {
      final json = {
        'ILCE': null,
        'KAPINO': '23',
        'ENLEM': '39.1200',
        'ACIKLAMA': null,
        'ILCEID': '3',
        'MAHALLE': 'Akropol',
        'ADI': 'Pergamon',
        'BOYLAM': '27.1800',
        'YOL': null,
      };
      
      final yer = Onemliyer.fromJson(json);
      expect(yer.iLCE, '');
      expect(yer.aCIKLAMA, '');
      expect(yer.yOL, '');
    });

    test('should correctly convert to JSON', () {
      final yer = Onemliyer(
        iLCE: 'Bergama',
        kAPINO: '23',
        eNLEM: 39.12,
        aCIKLAMA: 'Pergamon',
        iLCEID: '3',
        mAHALLE: 'Akropol',
        aDI: 'Pergamon',
        bOYLAM: 27.18,
        yOL: 'Antik Yol',
      );
      final map = yer.toJson();

      expect(map['ILCE'], 'Bergama');
      expect(map['ADI'], 'Pergamon');
      expect(map['ENLEM'], 39.12);
      expect(map['BOYLAM'], 27.18);
      expect(map['ACIKLAMA'], 'Pergamon');
      expect(map['MAHALLE'], 'Akropol');
    });
  });
}