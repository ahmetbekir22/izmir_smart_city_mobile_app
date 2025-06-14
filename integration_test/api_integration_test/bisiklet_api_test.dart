import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_city_app/main.dart' as app;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/bisiklet_api_controllers/bisiklet_controller.dart';
import 'package:smart_city_app/features/auth/widgets/button_wigdets/custom_category_buttom.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Bisiklet İstasyonları API Integration Tests', () {
    late Dio dio;
    late BisikletController bisikletController;

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
      bisikletController = Get.put(BisikletController());
    });

    testWidgets('Bisiklet İstasyonları API endpoint should be accessible', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Bisiklet API Testi Başlıyor...');

      try {
        final apiUrl = dotenv.env['BISIKLET_ISTASYONLARI']!;
        final response = await dio.get(apiUrl);
        
        expect(response.statusCode, 200);
        expect(response.data, isA<Map>());
        expect(response.data['status'], 'ok');
        expect(response.data['stations'], isA<List>());
        
        final List<dynamic> istasyonData = response.data['stations'];
        expect(istasyonData, isNotEmpty);
        print('✅ ${istasyonData.length} adet istasyon verisi alındı');

        // İlk istasyonun yapısını kontrol et
        final firstStation = istasyonData.first;
        expect(firstStation, isA<Map>());
        expect(firstStation['IstasyonAdi'], isNotNull);
        expect(firstStation['IstasyonID'], isNotNull);
        expect(firstStation['Durumu'], isNotNull);
        expect(firstStation['Kapasite'], isNotNull);
        expect(firstStation['BisikletSayisi'], isNotNull);
      } catch (e) {
        fail('API endpoint test failed: $e');
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Bisiklet API Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });

    testWidgets('Bisiklet istasyonları listesi UI\'da gösterilmeli', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Bisiklet UI Testi Başlıyor...');

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

      // Bisiklet kategorisini bul ve tıkla
      final bisikletButton = find.byType(CategoryButton).first;
      expect(bisikletButton, findsOneWidget);
      await tester.tap(bisikletButton);
      await tester.pumpAndSettle();

      // Liste görünümünün yüklendiğini kontrol et
      expect(find.byType(ListView), findsOneWidget);
      
      // İstasyon kartlarının varlığını kontrol et
      expect(find.byType(Card), findsWidgets);
      
      // İstasyon bilgilerinin gösterildiğini kontrol et
      expect(find.byType(Text), findsWidgets);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Bisiklet UI Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });

    testWidgets('İstasyon detayları doğru gösterilmeli', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 İstasyon Detay Testi Başlıyor...');

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

      // Bisiklet kategorisini bul ve tıkla
      final bisikletButton = find.byType(CategoryButton).first;
      expect(bisikletButton, findsOneWidget);
      await tester.tap(bisikletButton);
      await tester.pumpAndSettle();

      // İlk istasyon kartına tıkla
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
      print('✅ İstasyon Detay Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });
  });
} 