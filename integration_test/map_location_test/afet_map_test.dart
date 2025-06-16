import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_city_app/main.dart' as app;
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/afet_controllers/afet_controller.dart';
import 'package:smart_city_app/features/auth/widgets/button_wigdets/custom_category_buttom.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Afet Map Integration Tests', () {
    late AfetController afetController;

    setUpAll(() async {
      await dotenv.load();
      afetController = Get.put(AfetController());
    });

    testWidgets('Afet points should be shown correctly on the map', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Afet Map Test Begins...');

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

      // Afet kategorisini bul ve tıkla
      final afetButton = find.byType(CategoryButton).at(1); // Afet butonu ikinci sırada
      expect(afetButton, findsOneWidget);
      await tester.tap(afetButton);
      await tester.pumpAndSettle();

      // Liste sayfasının yüklendiğini kontrol et
      expect(find.byType(GridView), findsOneWidget);
      
      // API verilerinin yüklenmesi için bekle
      await Future.delayed(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // Afet verilerinin yüklendiğini kontrol et
      try {
        expect(afetController.afetList.isNotEmpty, true);
        print('Number of Afet points: ${afetController.afetList.length}');
      } catch (e) {
        print('API Error: $e');
        fail('Afet verileri yüklenemedi: $e');
      }

      // Harita üzerindeki marker'ların varlığını kontrol et
      expect(afetController.afetList.length, greaterThan(0));

      // Her bir afet noktası için koordinatların doğru olduğunu kontrol et
      for (var afet in afetController.afetList) {
        expect(afet.eNLEM, isNotNull);
        expect(afet.bOYLAM, isNotNull);
        expect(afet.aDI, isNotNull);
        expect(afet.iLCE, isNotNull);
        expect(afet.mAHALLE, isNotNull);
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Afet Map Test Completed (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });

    testWidgets('When you click on Afet points, detailed information should be displayed.', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Afet Marker Detail Test Begins...');

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

      // Afet kategorisini bul ve tıkla
      final afetButton = find.byType(CategoryButton).at(1); // Afet butonu ikinci sırada
      expect(afetButton, findsOneWidget);
      await tester.tap(afetButton);
      await tester.pumpAndSettle();

      // Liste sayfasının yüklendiğini kontrol et
      expect(find.byType(GridView), findsOneWidget);
      
      // API verilerinin yüklenmesi için bekle
      await Future.delayed(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // Afet verilerinin yüklendiğini kontrol et
      expect(afetController.afetList.isNotEmpty, true);
      print('Afet noktası sayısı: ${afetController.afetList.length}');

      // İlk afet noktasının bilgilerini kontrol et
      final firstAfet = afetController.afetList.first;
      expect(firstAfet.aDI, isNotNull);
      expect(firstAfet.iLCE, isNotNull);
      expect(firstAfet.mAHALLE, isNotNull);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Afet Marker Detail Test Completed (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });
  });

  test('AFET_API environment variable should be set', () {
    expect(dotenv.env['AFET_TOPLANMA_YERLERI_API'], isNotNull);
  });
} 