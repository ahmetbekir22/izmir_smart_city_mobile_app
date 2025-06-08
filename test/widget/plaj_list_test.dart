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
  void fetchPlajData() {
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

void main() {
  setUp(() {
    // Her test öncesi GetX bağımlılıklarını sıfırla
    Get.reset();
    // Mock controller'ları enjekte et
    final plajController = Get.put<PlajController>(MockPlajController());
    Get.put<MapController>(MockMapController());

    // Generic filter controller için de bir instance oluştur
    Get.put(GenericFilterController<Onemliyer>(
      extractIlce: (plaj) => plaj.iLCE ?? '',
      extractMahalle: (plaj) => plaj.mAHALLE ?? '',
    ));

    // FilterController'ı başlat
    final filterController = Get.find<GenericFilterController<Onemliyer>>();
    filterController.initializeFilterData(plajController.plajList);
  });

  testWidgets('PlajList liste görünümü testi', (WidgetTester tester) async {
    await tester.pumpWidget(
      TestApp(child: PlajList()),
    );

    // İlk render sonrası widget ağacının oluşması için pump
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Başlık kontrolü
    expect(find.text('Plajlar'), findsOneWidget);

    // Tab bar kontrolü
    expect(find.text('Liste Görünümü'), findsOneWidget);
    expect(find.text('Harita Görünümü'), findsOneWidget);

    // Plaj listesi kontrolü
    expect(find.text('Alsancak Plajı'), findsOneWidget);
    expect(find.text('Alaçatı Plajı'), findsOneWidget);
    expect(find.text('Foça Plajı'), findsOneWidget);

    // Filtre butonu kontrolü
    expect(find.byIcon(Icons.filter_list), findsOneWidget);
  });

  test('PlajList filtreleme işlevsellik testi', () {
    // Bu test widget testi değil, filtreleme mantığını doğrudan test ediyor
    final filterController = Get.find<GenericFilterController<Onemliyer>>();

    // Filtre başlangıç durumunu kontrol et
    expect(filterController.selectedIlce.value, '');
    expect(filterController.selectedMahalle.value, '');
    expect(filterController.filteredList.isEmpty, true);

    // Konak ilçesini seç
    filterController.selectedIlce.value = 'Konak';
    filterController.filterList();

    // Filtrelenmiş liste kontrolü
    expect(filterController.filteredList.length, 1);
    expect(filterController.filteredList[0].aDI, 'Alsancak Plajı');

    // Çeşme ilçesini seç
    filterController.selectedIlce.value = 'Çeşme';
    filterController.filterList();

    // Filtrelenmiş liste kontrolü
    expect(filterController.filteredList.length, 1);
    expect(filterController.filteredList[0].aDI, 'Alaçatı Plajı');

    // Filtreyi temizle
    filterController.resetFilter();
    filterController.filterList();

    // Tüm plajların filtrede olmasını kontrol et
    expect(filterController.selectedIlce.value, '');
    expect(filterController.selectedMahalle.value, '');
    expect(filterController.filteredList.length, 3);
  });

  testWidgets('PlajList TabBar geçiş testi', (WidgetTester tester) async {
    // Test öncesi widget tree render edelim
    await tester.pumpWidget(
      TestApp(child: PlajList()),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Başlangıçta Liste Görünümü sekmesinin aktif olduğunu kontrol et
    final customTabBarFinder = find.byType(CustomTabBar);
    expect(customTabBarFinder, findsOneWidget);

    // Filtre butonunun görünür olduğunu kontrol et (sadece liste görünümünde görünür)
    expect(find.byIcon(Icons.filter_list), findsOneWidget);

    // Harita Görünümü sekmesine tıkla
    await tester.tap(find.text('Harita Görünümü'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Filtre butonunun artık görünmediğini kontrol et (harita görünümünde gizlenir)
    expect(
        find.descendant(
          of: find.byType(AppBar).last,
          matching: find.byIcon(Icons.filter_list),
        ),
        findsNothing);
  });

  testWidgets('PlajList dialog UI testi', (WidgetTester tester) async {
    // Dialog widget'ını doğrudan test edelim
    final filterController = Get.find<GenericFilterController<Onemliyer>>();

    await tester.pumpWidget(
      TestApp(
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
      ),
    );

    // Filtre dialog'unu açacak butona tıkla
    await tester.tap(find.text('Filtre Aç'));
    await tester.pumpAndSettle();

    // Dialog bileşenlerinin varlığını kontrol et
    expect(find.text('Plajlar Filtrele'), findsOneWidget);
    expect(find.text('İlçe Seç'), findsOneWidget);
    expect(find.text('Mahalle Seç'), findsOneWidget);
    expect(find.text('Temizle'), findsOneWidget);
    expect(find.text('Uygula'), findsOneWidget);
  });
}
