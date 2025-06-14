import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_city_app/main.dart' as app;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/veteriner_controllers/veteriner_controller.dart';
import 'package:smart_city_app/core/api/veteriner_api/veteriner_model.dart';
import 'package:smart_city_app/features/auth/widgets/button_wigdets/custom_category_buttom.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Veteriner API Integration Tests', () {
    late Dio dio;
    late VeterinerController veterinerController;

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
      veterinerController = Get.put(VeterinerController());
    });

    testWidgets('Veteriner API endpoint should be accessible', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Veteriner API Testi Başlıyor...');

      try {
        final apiUrl = dotenv.env['VETERINER_API'];
        if (apiUrl == null) {
          fail('VETERINER_API URL is not defined in .env file');
          return;
        }

        final response = await dio.get(apiUrl);
        
        expect(response.statusCode, 200);
        expect(response.data, isA<Map>());
        
        // API yanıtını model sınıfına dönüştür
        final veteriner = Veteriner.fromJson(response.data);
        
        // Model yapısını kontrol et
        expect(veteriner.onemliyer, isNotNull);
        expect(veteriner.onemliyer, isNotEmpty);
        expect(veteriner.toplamSayfaSayisi, isNotNull);
        
        // İlk veteriner verisini kontrol et
        final firstVeteriner = veteriner.onemliyer!.first;
        expect(firstVeteriner.aDI, isNotNull);
        expect(firstVeteriner.iLCE, isNotNull);
        expect(firstVeteriner.mAHALLE, isNotNull);
        expect(firstVeteriner.eNLEM, isNotNull);
        expect(firstVeteriner.bOYLAM, isNotNull);
        
        print('✅ ${veteriner.onemliyer!.length} adet veteriner verisi alındı');
      } catch (e) {
        fail('API endpoint test failed: $e');
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Veteriner API Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });

    testWidgets('Veteriner listesi UI\'da gösterilmeli', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Veteriner UI Testi Başlıyor...');

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

      // Veteriner kategorisini bul ve tıkla
      final veterinerButton = find.byType(CategoryButton).first;
      expect(veterinerButton, findsOneWidget);
      await tester.tap(veterinerButton);
      await tester.pumpAndSettle();

      // Liste görünümünün yüklendiğini kontrol et
      expect(find.byType(ListView), findsOneWidget);
      
      // Veteriner kartlarının varlığını kontrol et
      expect(find.byType(Card), findsWidgets);
      
      // Konum bilgilerinin gösterildiğini kontrol et
      expect(find.byType(Icon), findsWidgets);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Veteriner UI Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });

    testWidgets('Veteriner detayları doğru gösterilmeli', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Veteriner Detay Testi Başlıyor...');

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

      // Veteriner kategorisini bul ve tıkla
      final veterinerButton = find.byType(CategoryButton).first;
      expect(veterinerButton, findsOneWidget);
      await tester.tap(veterinerButton);
      await tester.pumpAndSettle();

      // İlk veteriner kartına tıkla
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
      print('✅ Veteriner Detay Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });
  });
} 