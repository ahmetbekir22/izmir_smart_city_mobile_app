import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/features/auth/views/plaj_pages/plaj_list.dart';
import 'package:smart_city_app/controllers/plaj_controllers/plaj_controller.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import 'package:smart_city_app/core/api/plaj_api/plaj_model.dart';
import 'package:smart_city_app/controllers/filter_controllers/general_filter_controller.dart';
import 'package:smart_city_app/features/auth/views/filter_pages/general_filter_UI.dart';
import 'package:smart_city_app/features/auth/widgets/button_wigdets/custom_tab_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

// Mock PlajController sınıfı
class MockPlajController extends PlajController {
  @override
  void onInit() {
    // Test için veri oluştur
    isLoading.value = false;
    plajList.assignAll([
      Onemliyer(
        iLCE: 'Konak',
        mAHALLE: 'Alsancak',
        aDI: 'Alsancak Plajı',
        eNLEM: 38.45,
        bOYLAM: 27.17,
        aCIKLAMA: 'Güzel bir plaj',
      ),
      Onemliyer(
        iLCE: 'Çeşme',
        mAHALLE: 'Alaçatı',
        aDI: 'Alaçatı Plajı',
        eNLEM: 38.28,
        bOYLAM: 26.37,
        aCIKLAMA: 'Sörf için ideal',
      ),
      Onemliyer(
        iLCE: 'Foça',
        mAHALLE: 'Merkez',
        aDI: 'Foça Plajı',
        eNLEM: 38.67,
        bOYLAM: 26.75,
        aCIKLAMA: 'Sakin bir plaj',
      ),
    ]);
  }

  @override
  Future<void> fetchPlajData() async {
    // API çağrısını simüle etme
    isLoading.value = false;
  }

  @override
  void _loadFavorites() {/* override */}
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

// Test için özel bir wrapper widget oluşturuyoruz
class TestApp extends StatelessWidget {
  final Widget child;

  const TestApp({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: child,
      // Test sırasında görsellerin gösterilmesini sağlamak için
      debugShowCheckedModeBanner: false,
    );
  }
}

void plajTests(List<TestResult> testResults) {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  setUp(() {
    Get.reset();
    final plajController = Get.put<PlajController>(MockPlajController());
    Get.put<MapController>(MockMapController());
    Get.put(GenericFilterController<Onemliyer>(
      extractIlce: (plaj) => plaj.iLCE ?? '',
      extractMahalle: (plaj) => plaj.mAHALLE ?? '',
    ));
    final filterController = Get.find<GenericFilterController<Onemliyer>>();
    filterController.initializeFilterData(plajController.plajList);
  });

  testWidgets('BeachList list view test', (WidgetTester tester) async {
    try {
      Get.put<PlajController>(MockPlajController());
      Get.put<MapController>(MockMapController());
      Get.put(GenericFilterController<Onemliyer>(
        extractIlce: (plaj) => plaj.iLCE ?? '',
        extractMahalle: (plaj) => plaj.mAHALLE ?? '',
      ));
      await tester.pumpWidget(TestApp(child: PlajList()));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      expect(find.text('Plajlar'), findsOneWidget);
      expect(find.text('Liste Görünümü'), findsOneWidget);
      expect(find.text('Harita Görünümü'), findsOneWidget);
      expect(find.text('Alsancak Plajı'), findsOneWidget);
      expect(find.text('Alaçatı Plajı'), findsOneWidget);
      expect(find.text('Foça Plajı'), findsOneWidget);
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
      testResults
          .add(TestResult(name: 'BeachList list view test', success: true));
    } catch (e) {
      testResults.add(TestResult(
          name: 'BeachList list view test',
          success: false,
          error: e.toString()));
      rethrow;
    }
  });

  test('BeachList filtering functionality test', () {
    try {
      Get.put<PlajController>(MockPlajController());
      Get.put(GenericFilterController<Onemliyer>(
        extractIlce: (plaj) => plaj.iLCE ?? '',
        extractMahalle: (plaj) => plaj.mAHALLE ?? '',
      ));
      final filterController = Get.find<GenericFilterController<Onemliyer>>();
      expect(filterController.selectedIlce.value, '');
      expect(filterController.selectedMahalle.value, '');
      expect(filterController.filteredList.isEmpty, true);
      filterController.selectedIlce.value = 'Konak';
      filterController.filterList();
      expect(filterController.filteredList.length, 1);
      expect(filterController.filteredList[0].aDI, 'Alsancak Plajı');
      filterController.selectedIlce.value = 'Çeşme';
      filterController.filterList();
      expect(filterController.filteredList.length, 1);
      expect(filterController.filteredList[0].aDI, 'Alaçatı Plajı');
      filterController.resetFilter();
      filterController.filterList();
      expect(filterController.selectedIlce.value, '');
      expect(filterController.selectedMahalle.value, '');
      expect(filterController.filteredList.length, 3);
      testResults.add(TestResult(
          name: 'BeachList filtering functionality test', success: true));
    } catch (e) {
      testResults.add(TestResult(
          name: 'BeachList filtering functionality test',
          success: false,
          error: e.toString()));
      rethrow;
    }
  });

  testWidgets('BeachList TabBar transition test', (WidgetTester tester) async {
    try {
      Get.put<PlajController>(MockPlajController());
      Get.put<MapController>(MockMapController());
      Get.put(GenericFilterController<Onemliyer>(
        extractIlce: (plaj) => plaj.iLCE ?? '',
        extractMahalle: (plaj) => plaj.mAHALLE ?? '',
      ));
      await tester.pumpWidget(TestApp(child: PlajList()));
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
      testResults.add(
          TestResult(name: 'BeachList TabBar transition test', success: true));
    } catch (e) {
      testResults.add(TestResult(
          name: 'BeachList TabBar transition test',
          success: false,
          error: e.toString()));
      rethrow;
    }
  });

  testWidgets('BeachList dialog UI test', (WidgetTester tester) async {
    try {
      Get.put<PlajController>(MockPlajController());
      Get.put(GenericFilterController<Onemliyer>(
        extractIlce: (plaj) => plaj.iLCE ?? '',
        extractMahalle: (plaj) => plaj.mAHALLE ?? '',
      ));
      final filterController = Get.find<GenericFilterController<Onemliyer>>();
      await tester.pumpWidget(TestApp(
        child: Builder(
          builder: (context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => GenericFilterDialog<Onemliyer>(
                      filterController: filterController,
                      allItems: Get.find<PlajController>().plajList,
                      title: 'Plajlar Filtrele',
                    ),
                  );
                },
                child: const Text('Filtre Aç'),
              ),
            );
          },
        ),
      ));
      await tester.tap(find.text('Filtre Aç'), warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      expect(find.text('Plajlar Filtrele'), findsOneWidget);
      expect(find.text('İlçe Seç'), findsOneWidget);
      expect(find.text('Mahalle Seç'), findsOneWidget);
      expect(find.text('Temizle'), findsOneWidget);
      expect(find.text('Uygula'), findsOneWidget);
      testResults
          .add(TestResult(name: 'BeachList dialog UI test', success: true));
    } catch (e) {
      testResults.add(TestResult(
          name: 'BeachList dialog UI test',
          success: false,
          error: e.toString()));
      rethrow;
    }
  });
}
