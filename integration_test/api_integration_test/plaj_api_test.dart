import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_city_app/main.dart' as app;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/plaj_controllers/plaj_controller.dart';
import 'package:smart_city_app/core/api/plaj_api/plaj_model.dart';
import 'package:smart_city_app/features/auth/widgets/button_wigdets/custom_category_buttom.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Plajlar API Integration Tests', () {
    late Dio dio;
    late PlajController plajController;

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
      plajController = Get.put(PlajController());
    });

    testWidgets('Plajlar API endpoint should be accessible', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Plajlar API Testi Başlıyor...');

      try {
        final apiUrl = dotenv.env['PLAJLAR_API']!;
        final response = await dio.get(apiUrl);
        
        expect(response.statusCode, 200);
        expect(response.data, isA<Map>());
        expect(response.data['onemliyer'], isA<List>());
        
        final List<dynamic> plajData = response.data['onemliyer'];
        expect(plajData, isNotEmpty);
        
        // Model dönüşümünü test et
        final plajlar = plajData.map((item) => Onemliyer.fromJson(item)).toList();
        expect(plajlar.first, isA<Onemliyer>());
        expect(plajlar.first.aDI, isNotNull);
        expect(plajlar.first.eNLEM, isNotNull);
        expect(plajlar.first.bOYLAM, isNotNull);
      } catch (e) {
        fail('API endpoint test failed: $e');
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Plajlar API Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });

    testWidgets('Plajlar listesi UI\'da gösterilmeli', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Plajlar UI Testi Başlıyor...');

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

      // Liste görünümünün yüklendiğini kontrol et
      expect(find.byType(GridView), findsOneWidget);
      
      // Plaj kartlarının varlığını kontrol et
      expect(find.byType(Card), findsWidgets);
      
      // Kart içeriğinin doğru gösterildiğini kontrol et
      expect(find.byType(Image), findsWidgets);
      expect(find.byType(Text), findsWidgets);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Plajlar UI Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });

    testWidgets('Plaj detayları doğru gösterilmeli', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Plaj Detay Testi Başlıyor...');

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

      // İlk plaj kartına tıkla
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
      
      // Konum bilgilerinin gösterildiğini kontrol et
      expect(find.byType(Icon), findsWidgets);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Plaj Detay Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });
  });
} 