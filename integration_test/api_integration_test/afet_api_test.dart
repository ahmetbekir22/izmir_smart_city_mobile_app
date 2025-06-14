import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_city_app/main.dart' as app;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/afet_controllers/afet_controller.dart';
import 'package:smart_city_app/core/api/afet_api/afet_model.dart';
import 'package:smart_city_app/features/auth/widgets/button_wigdets/custom_category_buttom.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Afet API Integration Tests', () {
    late Dio dio;
    late AfetController afetController;

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
      afetController = Get.put(AfetController());
    });

    testWidgets('Afet API endpoint should be accessible', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Afet API Testi Başlıyor...');

      try {
        final apiUrl = dotenv.env['AFET_TOPLANMA_YERLERI_API']!;
        final response = await dio.get(apiUrl);
        
        expect(response.statusCode, 200);
        expect(response.data, isA<Map>());
        
        // API yanıtını model sınıfına dönüştür
        final afet = Afet.fromJson(response.data);
        
        // Model yapısını kontrol et
        expect(afet.onemliyer, isNotNull);
        expect(afet.onemliyer, isNotEmpty);
        expect(afet.toplamSayfaSayisi, isNotNull);
        
        // İlk afet verisini kontrol et
        final firstAfet = afet.onemliyer!.first;
        expect(firstAfet.aDI, isNotNull);
        expect(firstAfet.iLCE, isNotNull);
        expect(firstAfet.mAHALLE, isNotNull);
        expect(firstAfet.eNLEM, isNotNull);
        expect(firstAfet.bOYLAM, isNotNull);
        
        print('✅ ${afet.onemliyer!.length} adet afet verisi alındı');
      } catch (e) {
        fail('API endpoint test failed: $e');
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Afet API Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });

    testWidgets('Afet listesi UI\'da gösterilmeli', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Afet UI Testi Başlıyor...');

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
      final afetButton = find.byType(CategoryButton).first;
      expect(afetButton, findsOneWidget);
      await tester.tap(afetButton);
      await tester.pumpAndSettle();

      // Liste görünümünün yüklendiğini kontrol et
      expect(find.byType(ListView), findsOneWidget);
      
      // Afet kartlarının varlığını kontrol et
      expect(find.byType(Card), findsWidgets);
      
      // Konum bilgilerinin gösterildiğini kontrol et
      expect(find.byType(Icon), findsWidgets);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Afet UI Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });

    testWidgets('Afet detayları doğru gösterilmeli', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Afet Detay Testi Başlıyor...');

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
      final afetButton = find.byType(CategoryButton).first;
      expect(afetButton, findsOneWidget);
      await tester.tap(afetButton);
      await tester.pumpAndSettle();

      // İlk afet kartına tıkla
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
      print('✅ Afet Detay Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });
  });
} 