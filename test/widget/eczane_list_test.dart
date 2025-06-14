import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_app/features/auth/views/eczane_pages/eczane_home_screen.dart';
import 'package:smart_city_app/controllers/eczane_api_controllers/eczane_controller.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import 'package:smart_city_app/core/api/eczane/eczane_api_model.dart';
import 'package:smart_city_app/features/auth/widgets/button_wigdets/custom_tab_bar.dart';
import 'dart:io';
import '../test_report_generator.dart';

// Dio mock için HttpOverrides
class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// Mock EczaneController sınıfı
class MockEczaneController extends EczaneController {
  @override
  void onInit() {
    // API çağrısını simüle etme
    isLoading.value = false;

    // Test için örnek veri oluştur
    eczaneList.assignAll([
      Eczane(
        adi: 'Test Eczanesi 1',
        bolge: 'Konak',
        adres: 'Test Adres 1',
        telefon: '0232 111 11 11',
        lokasyonX: '38.45',
        lokasyonY: '27.17',
      ),
      Eczane(
        adi: 'Test Eczanesi 2',
        bolge: 'Bornova',
        adres: 'Test Adres 2',
        telefon: '0232 222 22 22',
        lokasyonX: '38.46',
        lokasyonY: '27.18',
      ),
      Eczane(
        adi: 'Test Eczanesi 3',
        bolge: 'Karşıyaka',
        adres: 'Test Adres 3',
        telefon: '0232 333 33 33',
        lokasyonX: '38.47',
        lokasyonY: '27.19',
      ),
    ]);

    // Filtrelenmiş listeyi başlangıçta tüm eczanelerle doldur
    filteredList.assignAll(eczaneList);
  }

  @override
  Future<void> fetchEczaneler() async {
    // API çağrısını simüle etme
    isLoading.value = false;
  }

  @override
  void _updateMapMarkers(List<Eczane> eczaneler) {
    // Harita işlemlerini simüle etme
  }
}

// Mock MapController sınıfı
class MockMapController extends MapController {
  @override
  void onInit() {
    isLoading.value = false;
    initialPosition.value = const LatLng(38.41, 27.13); // İzmir merkezi
  }

  @override
  void addMarkers({
    required List locations,
    required double? Function(dynamic) getLatitude,
    required double? Function(dynamic) getLongitude,
    required String? Function(dynamic) getTitle,
    required String? Function(dynamic) getSnippet,
  }) {
    // Test için boş işlem
  }
}

// Test için özel bir wrapper widget
class TestApp extends StatelessWidget {
  final Widget child;

  const TestApp({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: child,
      debugShowCheckedModeBanner: false,
    );
  }
}

void eczaneTests(List<TestResult> testResults) {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  setUp(() {
    Get.reset();
    Get.put<EczaneController>(MockEczaneController());
    Get.put<MapController>(MockMapController());
  });

  testWidgets('PharmacyListPage list view test', (WidgetTester tester) async {
    try {
      Get.put<EczaneController>(MockEczaneController());
      Get.put<MapController>(MockMapController());
      await tester.pumpWidget(TestApp(child: const EczaneListPage()));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      expect(find.text('Nöbetçi Eczaneler'), findsOneWidget);
      expect(find.text('Liste Görünümü'), findsOneWidget);
      expect(find.text('Harita Görünümü'), findsOneWidget);
      expect(find.text('Test Eczanesi 1'), findsOneWidget);
      expect(find.text('Test Eczanesi 2'), findsOneWidget);
      expect(find.text('Test Eczanesi 3'), findsOneWidget);
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
      testResults.add(
          TestResult(name: 'PharmacyListPage list view test', success: true));
    } catch (e) {
      testResults.add(TestResult(
          name: 'PharmacyListPage list view test',
          success: false,
          error: e.toString()));
      rethrow;
    }
  });

  test('PharmacyController filtering functionality test', () {
    try {
      Get.put<EczaneController>(MockEczaneController());
      final eczaneController = Get.find<EczaneController>();
      expect(eczaneController.filteredList.length, 3);
      eczaneController.filterByRegion('Konak');
      expect(eczaneController.filteredList.length, 1);
      expect(eczaneController.filteredList[0].adi, 'Test Eczanesi 1');
      eczaneController.filterByRegion('Bornova');
      expect(eczaneController.filteredList.length, 1);
      expect(eczaneController.filteredList[0].adi, 'Test Eczanesi 2');
      eczaneController.filterByRegion('Olmayan Bölge');
      expect(eczaneController.filteredList.length, 0);
      eczaneController.filterByRegion('');
      expect(eczaneController.filteredList.length, 3);
      testResults.add(TestResult(
          name: 'PharmacyController filtering functionality test',
          success: true));
    } catch (e) {
      testResults.add(TestResult(
          name: 'PharmacyController filtering functionality test',
          success: false,
          error: e.toString()));
      rethrow;
    }
  });

  testWidgets('PharmacyListPage TabBar transition test',
      (WidgetTester tester) async {
    try {
      Get.put<EczaneController>(MockEczaneController());
      Get.put<MapController>(MockMapController());
      await tester.pumpWidget(TestApp(child: const EczaneListPage()));
      await tester.pump(const Duration(milliseconds: 500));

      final customTabBarFinder = find.byType(CustomTabBar);
      expect(customTabBarFinder, findsOneWidget);
      expect(find.byIcon(Icons.filter_list), findsOneWidget);

      await tester.tap(find.text('Harita Görünümü'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      expect(
          find.descendant(
            of: find.byType(AppBar).last,
            matching: find.byIcon(Icons.filter_list),
          ),
          findsNothing);
      testResults.add(TestResult(
          name: 'PharmacyListPage TabBar transition test', success: true));
    } catch (e) {
      testResults.add(TestResult(
          name: 'PharmacyListPage TabBar transition test',
          success: false,
          error: e.toString()));
      rethrow;
    }
  });

  testWidgets('PharmacyListPage filter bottomsheet test',
      (WidgetTester tester) async {
    try {
      Get.put<EczaneController>(MockEczaneController());
      Get.put<MapController>(MockMapController());
      await tester.pumpWidget(TestApp(child: const EczaneListPage()));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.filter_list), warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      expect(find.text('Bölgeye Göre Filtrele'), findsOneWidget);
      expect(find.text('Konak'), findsOneWidget);
      expect(find.text('Bornova'), findsOneWidget);
      expect(find.text('Karşıyaka'), findsOneWidget);
      testResults.add(TestResult(
          name: 'PharmacyListPage filter bottomsheet test', success: true));
    } catch (e) {
      testResults.add(TestResult(
          name: 'PharmacyListPage filter bottomsheet test',
          success: false,
          error: e.toString()));
      rethrow;
    }
  });
}
