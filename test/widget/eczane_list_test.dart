import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_app/features/auth/views/eczane_pages/eczane_home_screen.dart';
import 'package:smart_city_app/controllers/eczane_api_controllers/eczane_controller.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import 'package:smart_city_app/core/api/eczane/eczane_api_model.dart';
import 'package:smart_city_app/features/auth/widgets/button_wigdets/custom_tab_bar.dart';

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
  void fetchEczaneler() {
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

void main() {
  setUp(() {
    // Her test öncesi GetX bağımlılıklarını sıfırla
    Get.reset();
    // Mock controller'ları enjekte et
    Get.put<EczaneController>(MockEczaneController());
    Get.put<MapController>(MockMapController());
  });

  testWidgets('EczaneListPage liste görünümü testi',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      TestApp(child: const EczaneListPage()),
    );

    // İlk render sonrası widget ağacının oluşması için pump
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Başlık kontrolü
    expect(find.text('Nöbetçi Eczaneler'), findsOneWidget);

    // Tab bar kontrolü
    expect(find.text('Liste Görünümü'), findsOneWidget);
    expect(find.text('Harita Görünümü'), findsOneWidget);

    // Eczane listesi kontrolü
    expect(find.text('Test Eczanesi 1'), findsOneWidget);
    expect(find.text('Test Eczanesi 2'), findsOneWidget);
    expect(find.text('Test Eczanesi 3'), findsOneWidget);

    // Filtre butonu kontrolü
    expect(find.byIcon(Icons.filter_list), findsOneWidget);
  });

  test('EczaneController filtreleme işlevsellik testi', () {
    // Controller üzerinden direkt filtreleme işlevini test etme
    final eczaneController = Get.find<EczaneController>();

    // Başlangıçta filtresiz liste
    expect(eczaneController.filteredList.length, 3);

    // Konak bölgesine filtrele
    eczaneController.filterByRegion('Konak');
    expect(eczaneController.filteredList.length, 1);
    expect(eczaneController.filteredList[0].adi, 'Test Eczanesi 1');

    // Bornova bölgesine filtrele
    eczaneController.filterByRegion('Bornova');
    expect(eczaneController.filteredList.length, 1);
    expect(eczaneController.filteredList[0].adi, 'Test Eczanesi 2');

    // Olmayan bir bölge ile filtrele
    eczaneController.filterByRegion('Olmayan Bölge');
    expect(eczaneController.filteredList.length, 0);

    // Filtreyi temizle
    eczaneController.filterByRegion('');
    expect(eczaneController.filteredList.length, 3);
  });

  testWidgets('EczaneListPage TabBar geçiş testi', (WidgetTester tester) async {
    await tester.pumpWidget(
      TestApp(child: const EczaneListPage()),
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

  testWidgets('EczaneListPage filtre bottomsheet testi',
      (WidgetTester tester) async {
    // Test için EczaneListPage widget'ını oluştur
    await tester.pumpWidget(
      TestApp(child: const EczaneListPage()),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Filtre butonuna tıkla
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();

    // BottomSheet'in görünüp görünmediğini kontrol et
    expect(find.text('Bölgeye Göre Filtrele'), findsOneWidget);

    // Filtreleme seçeneklerinin görünüp görünmediğini kontrol et
    expect(find.text('Konak'), findsOneWidget);
    expect(find.text('Bornova'), findsOneWidget);
    expect(find.text('Karşıyaka'), findsOneWidget);
  });
}
