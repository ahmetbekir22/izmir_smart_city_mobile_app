// test/unit_tests/veteriner_all_tests.dart

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
  // ---------- Ortak Test Verisi ----------
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

  // ---------- MODEL TESTLERİ ----------
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
      expectedMap['MAHALLEID'] = null; // Eksik olan alan testte de yer almalı
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
  });

  // ---------- SERVICE TESTLERİ ----------
  group('VeterinerApiService', () {
    late MockClient mockClient;
    late VeterinerApiService service;

    setUp(() {
      mockClient = MockClient();
      service = VeterinerApiService(client: mockClient);
    });

    test('returns list of Onemliyer on 200 response', () async {
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(
          json.encode([sampleJson]),
          200,
          headers: {
            'content-type': 'application/json; charset=utf-8'
          }, // Türkçe karakter sorunu çözülür
        ),
      );

      final result = await service.fetchVeteriner();
      expect(result, isA<List<Onemliyer>>());
      expect(result.first.iLCE, 'Konak');
    });

    test('throws exception on non-200 response', () {
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response('Error', 404));

      expect(service.fetchVeteriner(), throwsA(isA<Exception>()));
    });
  });

  // ------- CONTROLLER TESTLERİ --------
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
  });
}
