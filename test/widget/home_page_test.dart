import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/features/auth/views/home_screen_pages/home_screen.dart';
import 'package:smart_city_app/controllers/etkinlik_api_controllers/event_controller.dart';

// Timer hatasını önlemek için mock controller
class MockEtkinlikController extends EtkinlikController {
  @override
  void onInit() {
    // Timer başlatma!
    pageController = PageController();
    // Diğer init işlemleri
    loadEtkinlikler();
    clearFilters();
    _loadFavorites();
  }

  @override
  void _startEventRotation() {/* override, timer başlatma */}
  @override
  void _loadFavorites() {/* override, favori yükleme yok */}
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

void main() {
  setUp(() {
    // Her testten önce mock controller'ı enjekte et
    Get.reset();
    Get.put<EtkinlikController>(MockEtkinlikController());
  });

  testWidgets('HomePage widget temel görünürlük testi',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: HomePage(),
      ),
    );

    // İlk render sonrası birkaç kez pump yapalım
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Kent Rehberim'), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.byIcon(Icons.light_mode), findsOneWidget);
    expect(find.text('Hayatı Kolaylaştıran Hizmetler...'), findsOneWidget);
  });

  testWidgets('HomePage widget kategoriler testi', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: HomePage(),
      ),
    );

    // pumpAndSettle yerine belirli sayıda pump kullanıyoruz
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Sadece kesin olarak görünecek kategorileri test edelim
    expect(find.text('ACİL'), findsOneWidget);
    expect(find.text('Seyahat'), findsOneWidget);
    expect(find.text('İhtiyaç'), findsOneWidget);

    // DraggableSheetPage'deki ok ikonları
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
  });

  testWidgets('HomePage kategori seçimi testi', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: HomePage(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Kategori butonlarından birine tıkla
    await tester.tap(find.text('Seyahat'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Ok ikonuna tıkla
    await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
  });

  testWidgets('HomePage etkinlikler yüklenme durumu testi',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: HomePage(),
      ),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });
}
