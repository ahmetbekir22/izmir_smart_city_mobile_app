import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_city_app/main.dart' as app;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/antik_yerler_controllers/antik_controller.dart';
import 'package:smart_city_app/core/api/antik_api/antik_model.dart';
import 'package:smart_city_app/features/auth/widgets/button_wigdets/custom_category_buttom.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Antik Kentler API Integration Tests', () {
    late Dio dio;
    late AntikController antikController;

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
      antikController = Get.put(AntikController());
    });

    testWidgets('Antik Kentler API endpoint should be accessible', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Antik Kent API Testi Başlıyor...');

      try {
        final apiUrl = dotenv.env['ANTIK_KENTLER']!;
        final response = await dio.get(apiUrl);
        
        expect(response.statusCode, 200);
        expect(response.data, isA<Map>());
        
        // API yanıtını model sınıfına dönüştür
        final antikKent = AntikKent.fromJson(response.data);
        
        // Model yapısını kontrol et
        expect(antikKent.onemliyer, isNotNull);
        expect(antikKent.onemliyer, isNotEmpty);
        expect(antikKent.toplamSayfaSayisi, isNotNull);
        
        // İlk antik kent verisini kontrol et
        final firstAntikKent = antikKent.onemliyer!.first;
        expect(firstAntikKent.aDI, isNotNull);
        expect(firstAntikKent.iLCE, isNotNull);
        expect(firstAntikKent.mAHALLE, isNotNull);
        expect(firstAntikKent.eNLEM, isNotNull);
        expect(firstAntikKent.bOYLAM, isNotNull);
        
        print('✅ ${antikKent.onemliyer!.length} adet antik kent verisi alındı');
      } catch (e) {
        fail('API endpoint test failed: $e');
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Antik Kent API Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });

    testWidgets('Antik kentler listesi UI\'da gösterilmeli', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Antik Kent UI Testi Başlıyor...');

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

      // Antik Kent kategorisini bul ve tıkla
      final antikKentButton = find.byType(CategoryButton).first;
      expect(antikKentButton, findsOneWidget);
      await tester.tap(antikKentButton);
      await tester.pumpAndSettle();

      // Liste görünümünün yüklendiğini kontrol et
      expect(find.byType(ListView), findsOneWidget);
      
      // Antik kent kartlarının varlığını kontrol et
      expect(find.byType(Card), findsWidgets);
      
      // Konum bilgilerinin gösterildiğini kontrol et
      expect(find.byType(Icon), findsWidgets);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Antik Kent UI Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });

    testWidgets('Antik kent detayları doğru gösterilmeli', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('📋 Antik Kent Detay Testi Başlıyor...');

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

      // Antik Kent kategorisini bul ve tıkla
      final antikKentButton = find.byType(CategoryButton).first;
      expect(antikKentButton, findsOneWidget);
      await tester.tap(antikKentButton);
      await tester.pumpAndSettle();

      // İlk antik kent kartına tıkla
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
      print('✅ Antik Kent Detay Testi Tamamlandı (${duration.inSeconds}.${duration.inMilliseconds % 1000}s)');
    });
  });
} 