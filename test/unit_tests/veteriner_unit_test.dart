// test/unit_tests/veteriner_unit_test.dart

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import 'package:smart_city_app/controllers/veteriner_controllers/veteriner_controller.dart';
import 'package:smart_city_app/core/api/veteriner_api/veteriner_model.dart';
import 'package:smart_city_app/core/api/veteriner_api/veteriner_service.dart';

import 'veteriner_unit_test.mocks.dart';

@GenerateMocks([http.Client, VeterinerApiService, MapController])
void main() {
  final sampleJson = {
    'ILCE': 'Konak',
    'KAPINO': '10',
    'ENLEM': 38.4192,
    'ACIKLAMA': 'Açıklama',
    'ILCEID': '1',
    'MAHALLE': 'Alsancak',
    'ADI': 'VetCenter',
    'BOYLAM': 27.1287,
    'YOL': 'Birinci Cadde',
  };
  final sampleData = [Onemliyer.fromJson(sampleJson)];

  // ------------------ Onemliyer Model Testleri ------------------
  group('Onemliyer model', () {
    test('fromJson maps all fields correctly', () {
      final obj = Onemliyer.fromJson(sampleJson);
      expect(obj.iLCE, 'Konak');
      expect(obj.kAPINO, '10');
      expect(obj.eNLEM, 38.4192);
      expect(obj.aCIKLAMA, 'Açıklama');
      expect(obj.iLCEID, '1');
      expect(obj.mAHALLE, 'Alsancak');
      expect(obj.aDI, 'VetCenter');
      expect(obj.bOYLAM, 27.1287);
      expect(obj.yOL, 'Birinci Cadde');
    });

    test('toJson produces a matching map', () {
      final obj = Onemliyer.fromJson(sampleJson);
      final expectedMap = Map<String, dynamic>.from(sampleJson);
      expectedMap['MAHALLEID'] = null;
      expect(obj.toJson(), expectedMap);
    });

    test('handles missing/null fields gracefully', () {
      final partial = <String, dynamic>{
        'ILCE': null,
        'BOYLAM': null,
      };
      final obj = Onemliyer.fromJson(partial);
      expect(obj.iLCE, isNull);
      expect(obj.bOYLAM, isNull);
      final out = obj.toJson();
      expect(out['ILCE'], null);
      expect(out['BOYLAM'], null);
    });

    test('fromJson assigns default values for missing optional fields', () {
      final input = {
        'ILCE': 'Bornova',
        'ADI': 'VetX',
      };
      final obj = Onemliyer.fromJson(input);
      expect(obj.iLCE, 'Bornova');
      expect(obj.aDI, 'VetX');
      expect(obj.bOYLAM, isNull);
    });

    test('toJson includes all present fields even if value is 0', () {
      final obj = Onemliyer(iLCE: 'Karabağlar', bOYLAM: 0.0, eNLEM: 0.0);
      final json = obj.toJson();
      expect(json['BOYLAM'], 0.0);
      expect(json['ENLEM'], 0.0);
    });
  });

  // ------------------ Veteriner Model Testleri ------------------
  group('Veteriner model', () {
    test('Veteriner.fromJson parses all fields correctly', () {
      final json = {
        'sayfadaki_kayitsayisi': 10,
        'kayit_sayisi': 100,
        'sayfa_numarasi': 1,
        'toplam_sayfa_sayisi': 10,
        'onemliyer': [sampleJson],
      };

      final model = Veteriner.fromJson(json);

      expect(model.sayfadakiKayitsayisi, 10);
      expect(model.kayitSayisi, 100);
      expect(model.sayfaNumarasi, 1);
      expect(model.toplamSayfaSayisi, 10);
      expect(model.onemliyer, isA<List<Onemliyer>>());
      expect(model.onemliyer!.first.iLCE, 'Konak');
    });

    test('Veteriner.toJson returns correct map', () {
      final model = Veteriner(
        sayfadakiKayitsayisi: 10,
        kayitSayisi: 100,
        sayfaNumarasi: 1,
        toplamSayfaSayisi: 10,
        onemliyer: [Onemliyer.fromJson(sampleJson)],
      );

      final json = model.toJson();

      expect(json['sayfadaki_kayitsayisi'], 10);
      expect(json['kayit_sayisi'], 100);
      expect(json['sayfa_numarasi'], 1);
      expect(json['toplam_sayfa_sayisi'], 10);
      expect(json['onemliyer'], isA<List>());
      expect(json['onemliyer'][0]['ILCE'], 'Konak');
    });
  });

  // ------------------ VeterinerApiService Testleri ------------------
  group('VeterinerApiService', () {
    late MockClient mockClient;
    late VeterinerApiService service;

    setUp(() {
      mockClient = MockClient();
      service = VeterinerApiService(client: mockClient);
    });

    test('returns list of Onemliyer on 200 response', () async {
      when(mockClient.get(any)).thenAnswer((_) async => http.Response(
            json.encode([sampleJson]),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          ));

      final result = await service.fetchVeteriner();
      expect(result, isA<List<Onemliyer>>());
      expect(result.first.iLCE, 'Konak');
    });

    test('throws exception on non-200 response', () {
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response('Error', 404));
      expect(service.fetchVeteriner(), throwsA(isA<Exception>()));
    });

    test('throws exception when response is not valid JSON', () async {
      when(mockClient.get(any)).thenAnswer((_) async => http.Response(
          'INVALID_JSON', 200,
          headers: {'content-type': 'application/json'}));
      expect(() async => await service.fetchVeteriner(),
          throwsA(isA<Exception>()));
    });

    test('returns empty list when response is empty array', () async {
      when(mockClient.get(any)).thenAnswer((_) async => http.Response('[]', 200,
          headers: {'content-type': 'application/json'}));
      final result = await service.fetchVeteriner();
      expect(result, isEmpty);
    });

    test('throws exception when network error occurs', () {
      when(mockClient.get(any)).thenThrow(Exception('Network error'));
      expect(service.fetchVeteriner(), throwsA(isA<Exception>()));
    });
  });

  // ------------------ VeterinerController Testleri ------------------
  group('VeterinerController', () {
    late MockVeterinerApiService mockApiService;
    late MockMapController mockMap;
    late VeterinerController controller;

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

    test(
        'fetchVeterinerData - hata oluşursa errorMessage atanır ve marker eklenmez',
        () async {
      when(mockApiService.fetchVeteriner()).thenThrow(Exception('API failed'));

      await controller.fetchVeterinerData();

      expect(controller.errorMessage.value,
          contains('Veriler alınırken bir hata oluştu'));
      expect(controller.veterinerList, isEmpty);

      verifyNever(mockMap.addMarkers(
        locations: anyNamed('locations'),
        getLatitude: anyNamed('getLatitude'),
        getLongitude: anyNamed('getLongitude'),
        getTitle: anyNamed('getTitle'),
        getSnippet: anyNamed('getSnippet'),
      ));
    });

    test('fetchVeterinerData clears previous list before fetching', () async {
      controller.veterinerList.add(Onemliyer(iLCE: 'Eski'));

      when(mockApiService.fetchVeteriner()).thenAnswer((_) async => sampleData);

      await controller.fetchVeterinerData();

      expect(controller.veterinerList.length, sampleData.length);
      expect(controller.veterinerList.first.iLCE, 'Konak');
    });

    test('onInit triggers fetchVeterinerData', () async {
      when(mockApiService.fetchVeteriner()).thenAnswer((_) async => sampleData);

      controller.onInit();

      await Future.delayed(Duration.zero); // onInit async içinde çalışabilir

      verify(mockApiService.fetchVeteriner()).called(1);
    });

    test('fetchVeterinerData fallback defaults (null values)', () async {
      final sampleWithNulls = Onemliyer(
        iLCE: null,
        mAHALLE: null,
        bOYLAM: null,
        eNLEM: null,
        aDI: null,
      );

      when(mockApiService.fetchVeteriner())
          .thenAnswer((_) async => [sampleWithNulls]);

      await controller.fetchVeterinerData();

      expect(controller.veterinerList.length, 1);
      expect(controller.errorMessage.value, '');
    });
  });
}
