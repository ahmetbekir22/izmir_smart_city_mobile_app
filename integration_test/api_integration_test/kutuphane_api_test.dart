import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_city_app/main.dart' as app;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/kütüphane_controllers/kutuphane_controller.dart';
import 'package:smart_city_app/core/api/kütüphane_api/kutuphane_model.dart';
import 'package:smart_city_app/features/auth/widgets/button_wigdets/custom_category_buttom.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Kütüphane API Integration Tests', () {
    late Dio dio;
    late KutuphaneController kutuphaneController;

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
      kutuphaneController = Get.put(KutuphaneController());
    });

    testWidgets('Kütüphane API endpoint should be accessible', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Kütüphane API Testi Başlıyor...');

      try {
        final apiUrl = dotenv.env['KUTUPHANE_API']!;
        if (apiUrl == null) {
          fail('KUTUPHANE API URL is not defined in .env file');
          return;
        }

        final response = await dio.get(apiUrl);
        
        expect(response.statusCode, 200);
        expect(response.data, isA<Map>());
        
        // API yanıtını model sınıfına dönüştür
        final kutuphane = Kutuphane.fromJson(response.data);
        
        // Model yapısını kontrol et
        expect(kutuphane.onemliyer, isNotNull);
        expect(kutuphane.onemliyer, isNotEmpty);
        expect(kutuphane.toplamSayfaSayisi, isNotNull);
        
        // İlk kütüphane verisini kontrol et
        final firstKutuphane = kutuphane.onemliyer!.first;
        expect(firstKutuphane.aDI, isNotNull);
        expect(firstKutuphane.iLCE, isNotNull);
        expect(firstKutuphane.mAHALLE, isNotNull);
        expect(firstKutuphane.eNLEM, isNotNull);
        expect(firstKutuphane.bOYLAM, isNotNull);
        
        print('✅ ${kutuphane.onemliyer!.length} adet kütüphane verisi alındı');
      } catch (e) {
        fail('API endpoint test failed: $e');
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Kütüphane API Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });

    testWidgets('Kütüphane listesi UI\'da gösterilmeli', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Kütüphane UI Testi Başlıyor...');

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

      // Kütüphane kategorisini bul ve tıkla
      final kutuphaneButton = find.byType(CategoryButton).first;
      expect(kutuphaneButton, findsOneWidget);
      await tester.tap(kutuphaneButton);
      await tester.pumpAndSettle();

      // Liste görünümünün yüklendiğini kontrol et
      expect(find.byType(ListView), findsOneWidget);
      
      // Kütüphane kartlarının varlığını kontrol et
      expect(find.byType(Card), findsWidgets);
      
      // Konum bilgilerinin gösterildiğini kontrol et
      expect(find.byType(Icon), findsWidgets);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Kütüphane UI Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });

    testWidgets('Kütüphane detayları doğru gösterilmeli', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Kütüphane Detay Testi Başlıyor...');

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

      // Kütüphane kategorisini bul ve tıkla
      final kutuphaneButton = find.byType(CategoryButton).first;
      expect(kutuphaneButton, findsOneWidget);
      await tester.tap(kutuphaneButton);
      await tester.pumpAndSettle();

      // İlk kütüphane kartına tıkla
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
      print('✅ Kütüphane Detay Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });
  });
} 