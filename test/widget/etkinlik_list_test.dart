import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/features/auth/views/event_pages/event_list.dart';
import 'package:smart_city_app/controllers/etkinlik_api_controllers/event_controller.dart';
import 'package:smart_city_app/core/api/etkinlik/events_model.dart';
import 'package:smart_city_app/features/auth/views/filter_pages/filter_dialog.dart';
import 'package:smart_city_app/controllers/filter_controllers/filter_controller.dart';
import 'package:smart_city_app/controllers/theme_contoller.dart';

// Mock EtkinlikController sınıfı
class MockEtkinlikController extends EtkinlikController {
  @override
  void onInit() {
    // API çağrısını simüle etme
    isLoading.value = false;

    // Timer başlatmayı devre dışı bırak
    pageController = PageController();

    // Test için örnek veri oluştur
    etkinlikListesi.assignAll([
      Etkinlik(
        id: 1,
        adi: 'Test Etkinliği 1',
        tur: 'Konser',
        etkinlikMerkezi: 'Kültür Merkezi',
        etkinlikBaslamaTarihi: '2024-07-01T19:00:00',
        etkinlikBitisTarihi: '2024-07-01T22:00:00',
        kisaAciklama: 'Test açıklama 1',
        kucukAfis: 'https://example.com/afis1.jpg',
        resim: 'https://example.com/resim1.jpg',
        etkinlikUrl: 'https://example.com/etkinlik1',
        ucretsizMi: true,
      ),
      Etkinlik(
        id: 2,
        adi: 'Test Etkinliği 2',
        tur: 'Sergi',
        etkinlikMerkezi: 'Sanat Galerisi',
        etkinlikBaslamaTarihi: '2024-07-05T10:00:00',
        etkinlikBitisTarihi: '2024-07-05T18:00:00',
        kisaAciklama: 'Test açıklama 2',
        kucukAfis: 'https://example.com/afis2.jpg',
        resim: 'https://example.com/resim2.jpg',
        etkinlikUrl: 'https://example.com/etkinlik2',
        ucretsizMi: true,
      ),
      Etkinlik(
        id: 3,
        adi: 'Test Etkinliği 3',
        tur: 'Tiyatro',
        etkinlikMerkezi: 'Kültür Merkezi',
        etkinlikBaslamaTarihi: '2024-07-10T20:00:00',
        etkinlikBitisTarihi: '2024-07-10T23:00:00',
        kisaAciklama: 'Test açıklama 3',
        kucukAfis: 'https://example.com/afis3.jpg',
        resim: 'https://example.com/resim3.jpg',
        etkinlikUrl: 'https://example.com/etkinlik3',
        ucretsizMi: false,
      ),
    ]);

    // Filtrelenmiş listeyi başlangıçta tüm etkinliklerle doldur
    filteredEventList.assignAll(etkinlikListesi);
  }

  @override
  Future<void> loadEtkinlikler() async {
    // API çağrısını simüle etme
    isLoading.value = false;
  }

  @override
  void _startEventRotation() {
    // Timer başlatmayı devre dışı bırak
  }

  @override
  void _loadFavorites() {
    // Favori yükleme işlemlerini devre dışı bırak
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
    Get.put<EtkinlikController>(MockEtkinlikController());
    Get.put<ThemeController>(ThemeController());
    Get.put<FilterDialogController>(FilterDialogController());
  });

  testWidgets('EtkinlikListesiSayfasi liste görünümü testi',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      TestApp(child: EtkinlikListesiSayfasi()),
    );

    // İlk render sonrası widget ağacının oluşması için pump
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Başlık kontrolü
    expect(find.text('Güncel Etkinlikler'), findsOneWidget);

    // Etkinlik listesi kontrolü
    expect(find.text('Test Etkinliği 1'), findsOneWidget);
    expect(find.text('Test Etkinliği 2'), findsOneWidget);
    expect(find.text('Test Etkinliği 3'), findsOneWidget);

    // Etkinlik türlerinin görünürlüğü
    expect(find.text('Konser'), findsOneWidget);
    expect(find.text('Sergi'), findsOneWidget);
    expect(find.text('Tiyatro'), findsOneWidget);

    // Etkinlik mekanlarının görünürlüğü
    expect(find.text('Kültür Merkezi'), findsAtLeastNWidgets(1));
    expect(find.text('Sanat Galerisi'), findsOneWidget);

    // Filtre butonu kontrolü
    expect(find.byIcon(Icons.filter_list), findsOneWidget);
  });

  test('EtkinlikController filtreleme işlevsellik testi', () {
    // Controller üzerinden direkt filtreleme işlevini test etme
    final etkinlikController = Get.find<EtkinlikController>();

    // Başlangıçta filtresiz liste
    expect(etkinlikController.filteredEventList.length, 3);

    // Konumu filtreleme
    etkinlikController.updateSelectedLocation('Kültür Merkezi');
    expect(etkinlikController.filteredEventList.length, 2);
    expect(etkinlikController.filteredEventList[0].adi, 'Test Etkinliği 1');
    expect(etkinlikController.filteredEventList[1].adi, 'Test Etkinliği 3');

    // Türü filtreleme
    etkinlikController.clearFilters(); // Önce filtreyi temizle
    etkinlikController.updateSelectedType('Sergi');
    expect(etkinlikController.filteredEventList.length, 1);
    expect(etkinlikController.filteredEventList[0].adi, 'Test Etkinliği 2');

    // Tarih aralığını filtreleme
    etkinlikController.clearFilters(); // Önce filtreyi temizle
    etkinlikController.updateSelectedDateRange(DateTimeRange(
      start: DateTime(2024, 7, 1),
      end: DateTime(2024, 7, 5),
    ));
    expect(etkinlikController.filteredEventList.length, 2);

    // Birden fazla filtre uygulama
    etkinlikController.clearFilters(); // Önce filtreyi temizle
    etkinlikController.updateSelectedLocation('Kültür Merkezi');
    etkinlikController.updateSelectedType('Konser');
    expect(etkinlikController.filteredEventList.length, 1);
    expect(etkinlikController.filteredEventList[0].adi, 'Test Etkinliği 1');

    // Filtreyi temizle
    etkinlikController.clearFilters();
    expect(etkinlikController.filteredEventList.length, 3);
  });

  testWidgets('EtkinlikListesiSayfasi filtre dialog testi',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      TestApp(child: EtkinlikListesiSayfasi()),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Filtre butonuna tıkla
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();

    // Dialog'un görünüp görünmediğini kontrol et
    expect(find.text('Filtrele'), findsOneWidget);

    // Filtre seçeneklerinin varlığını kontrol et
    expect(find.text('Konum'), findsOneWidget);
    expect(find.text('Tür'), findsOneWidget);
    expect(find.text('Tarih Aralığı'), findsOneWidget);

    // Dropdown ipuçlarının varlığını kontrol et
    expect(find.text('Konum seçiniz'), findsOneWidget);
    expect(find.text('Tür seçiniz'), findsOneWidget);

    // Tarih seçim alanlarının varlığını kontrol et
    expect(find.text('Başlangıç'), findsOneWidget);
    expect(find.text('Bitiş'), findsOneWidget);

    // Butonların varlığını kontrol et
    expect(find.text('Temizle'), findsOneWidget);
    expect(find.text('Uygula'), findsOneWidget);
  });
}
