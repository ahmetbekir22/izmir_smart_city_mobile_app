// import 'package:flutter_test/flutter_test.dart';
// import 'package:get/get.dart';
// import 'package:mockito/mockito.dart';
// import 'package:smart_city_app/controllers/afet_controllers/afet_controller.dart';
// import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
// import 'package:smart_city_app/core/api/afet_api/afet_model.dart';
// import 'package:smart_city_app/core/api/afet_api/afet_service.dart';

// // Mock sınıflar
// class MockAfetApiService extends Mock implements AfetApiService {}

// class MockMapController extends Mock implements MapController {}

// void main() {
//   late AfetController afetController;
//   late MockAfetApiService mockApiService;
//   late MockMapController mockMapController;

//   setUp(() {
//     mockApiService = MockAfetApiService();
//     mockMapController = MockMapController();

//     Get.testMode = true;

//     afetController = AfetController(
//       apiService: mockApiService,
//       mapController: mockMapController,
//     );
//   });
//   test('fetchAfetData() should populate afetList and call addMarkers',
//       () async {
//     // 1) Mock veriyi hazırla
//     final mockData = [
//       Onemliyer(
//         aDI: 'Test Noktası',
//         bOYLAM: 27.84,
//         eNLEM: 37.87,
//         mAHALLE: 'Alsancak',
//         iLCE: 'Konak',
//       ),
//     ];
//     when(mockApiService.fetchAfet()).thenAnswer((_) async => mockData);

//     // 2) Metodu çağır (void dönüyor, await yok)
//     afetController.fetchAfetData();

//     // 3) Async queue’da bekle ki tüm Future’lar işlesin
//     await Future<void>.delayed(Duration.zero);

//     // 4) Şimdi doğrula
//     expect(afetController.isLoading.value, false);
//     expect(afetController.afetList.length, 1);
//     expect(afetController.afetList.first.aDI, 'Test Noktası');
//     expect(afetController.errorMessage.value, '');

//     verify(mockApiService.fetchAfet()).called(1);
//     verify(mockMapController.addMarkers(
//       locations: mockData,
//       getLatitude: anyNamed('getLatitude'),
//       getLongitude: anyNamed('getLongitude'),
//       getTitle: anyNamed('getTitle'),
//       getSnippet: anyNamed('getSnippet'),
//     )).called(1);
//   });
// }
