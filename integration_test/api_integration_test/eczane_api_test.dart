import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_city_app/main.dart' as app;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/eczane_api_controllers/eczane_controller.dart';
import 'package:smart_city_app/features/auth/widgets/button_wigdets/custom_category_buttom.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Eczane API Integration Tests', () {
    late Dio dio;
    late EczaneController eczaneController;

    setUpAll(() async {
      await dotenv.load(fileName: ".env");
      dio = Dio()
        ..options = BaseOptions(
          validateStatus: (status) => status! < 500,
          headers: {'Content-Type': 'application/json'},
        )
        ..interceptors.add(LogInterceptor(
          requestBody: false,
          responseBody: false,
          logPrint: (object) {}, // Logları devre dışı bırak
        ));
      eczaneController = Get.put(EczaneController());
    });

    testWidgets('Eczane API endpoint should be accessible', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Eczane API Testi Başlıyor...');

      try {
        final apiUrl = dotenv.env['NOBETCI_ECZANE_API']!;
        final response = await dio.get(apiUrl);
        
        expect(response.statusCode, 200);
        expect(response.data, isA<List>());
        
        final List<dynamic> eczaneData = response.data;
        expect(eczaneData, isNotEmpty);
        print('✅ ${eczaneData.length} adet eczane verisi alındı');
      } catch (e) {
        fail('API endpoint test failed: $e');
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Eczane API Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });

    testWidgets('Eczane listesi UI\'da gösterilmeli', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Eczane UI Testi Başlıyor...');

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

      // Eczane kategorisini bul ve tıkla
      final eczaneButton = find.byType(CategoryButton).first;
      expect(eczaneButton, findsOneWidget);
      await tester.tap(eczaneButton);
      await tester.pumpAndSettle();

      // Liste görünümünün yüklendiğini kontrol et
      expect(find.byType(ListView), findsOneWidget);
      
      // Eczane kartlarının varlığını kontrol et
      expect(find.byType(Card), findsWidgets);
      
      // Kart içeriğinin doğru gösterildiğini kontrol et
      expect(find.byType(Text), findsWidgets);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Eczane UI Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });

    testWidgets('Eczane detayları doğru gösterilmeli', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Eczane Detay Testi Başlıyor...');

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

      // Eczane kategorisini bul ve tıkla
      final eczaneButton = find.byType(CategoryButton).first;
      expect(eczaneButton, findsOneWidget);
      await tester.tap(eczaneButton);
      await tester.pumpAndSettle();

      // İlk eczane kartına tıkla
      final firstCard = find.byType(Card).first;
      expect(firstCard, findsOneWidget);
      
      // Kartın görünür olduğundan emin ol
      await tester.ensureVisible(firstCard);
      await tester.pumpAndSettle();
      
      // Kartın merkezine tıkla
      await tester.tap(firstCard, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Detay sayfasının açıldığını kontrol et
      expect(find.byType(Scaffold), findsWidgets);
      
      // Detay bilgilerinin gösterildiğini kontrol et
      expect(find.byType(Text), findsWidgets);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Eczane Detay Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });
  });
} 