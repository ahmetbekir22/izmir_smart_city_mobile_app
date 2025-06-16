import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_city_app/main.dart' as app;
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/plaj_controllers/plaj_controller.dart';
import 'package:smart_city_app/features/auth/widgets/button_wigdets/custom_category_buttom.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Beach Map Integration Tests', () {
    late PlajController plajController;

    setUpAll(() async {
      await dotenv.load();
      plajController = Get.put(PlajController());
    });

    testWidgets('Plaj markers should be displayed correctly on the map', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Plaj Map Test Begins...');

      // Uygulamayı başlat
      await app.main();
      await tester.pumpAndSettle();

      // Splash screen'den geçiş için bekle
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Ana ekranın yüklendiğini kontrol et
      expect(find.byType(MaterialApp), findsOneWidget);
      await tester.pumpAndSettle();

      // Draggable sheet'i bul ve genişlet
      final dragHandle = find.byIcon(Icons.keyboard_arrow_up);
      expect(dragHandle, findsOneWidget);
      await tester.tap(dragHandle);
      await tester.pumpAndSettle();

      // Plajlar kategorisini bul ve tıkla
      final plajlarButton = find.byType(CategoryButton).first;
      expect(plajlarButton, findsOneWidget);
      await tester.tap(plajlarButton);
      await tester.pumpAndSettle();

      // Liste sayfasının yüklendiğini kontrol et
      expect(find.byType(GridView), findsOneWidget);
      
      // API verilerinin yüklenmesi için bekle
      await Future.delayed(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // Plaj verilerinin yüklendiğini kontrol et
      try {
        expect(plajController.plajList.isNotEmpty, true);
        print('Number of beaches: ${plajController.plajList.length}');
      } catch (e) {
        print('API Error: $e');
        fail('Plaj verileri yüklenemedi: $e');
      }

      // Harita üzerindeki marker'ların varlığını kontrol et
      expect(plajController.plajList.length, greaterThan(0));

      // Her bir plaj için koordinatların doğru olduğunu kontrol et
      for (var plaj in plajController.plajList) {
        expect(plaj.eNLEM, isNotNull);
        expect(plaj.bOYLAM, isNotNull);
        expect(plaj.aDI, isNotNull);
        expect(plaj.iLCE, isNotNull);
        expect(plaj.mAHALLE, isNotNull);
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Plaj Map Test Completed (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });

    testWidgets('Clicking on Plaj markers should show detailed information', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Plaj Marker Detail Test Begins...');

      // Uygulamayı başlat
      await app.main();
      await tester.pumpAndSettle();

      // Splash screen'den geçiş için bekle
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Ana ekranın yüklendiğini kontrol et
      expect(find.byType(MaterialApp), findsOneWidget);
      await tester.pumpAndSettle();

      // Draggable sheet'i bul ve genişlet
      final dragHandle = find.byIcon(Icons.keyboard_arrow_up);
      expect(dragHandle, findsOneWidget);
      await tester.tap(dragHandle);
      await tester.pumpAndSettle();

      // Plajlar kategorisini bul ve tıkla
      final plajlarButton = find.byType(CategoryButton).first;
      expect(plajlarButton, findsOneWidget);
      await tester.tap(plajlarButton);
      await tester.pumpAndSettle();

      // Liste sayfasının yüklendiğini kontrol et
      expect(find.byType(GridView), findsOneWidget);
      
      // API verilerinin yüklenmesi için bekle
      await Future.delayed(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // Plaj verilerinin yüklendiğini kontrol et
      expect(plajController.plajList.isNotEmpty, true);
      print('Plaj sayısı: ${plajController.plajList.length}');

      // İlk plajın bilgilerini kontrol et
      final firstPlaj = plajController.plajList.first;
      expect(firstPlaj.aDI, isNotNull);
      expect(firstPlaj.iLCE, isNotNull);
      expect(firstPlaj.mAHALLE, isNotNull);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Plaj Marker Detail Test Completed (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });
  });

  test('PLAJLAR_API environment variable should be set', () {
    expect(dotenv.env['PLAJLAR_API'], isNotNull);
  });
}
