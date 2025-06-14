import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_city_app/main.dart' as app;
import 'package:dio/dio.dart';
import 'package:smart_city_app/controllers/etkinlik_api_controllers/event_controller.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/core/api/etkinlik/events_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('API Integration Tests', () {
    late Dio dio;
    late EtkinlikController etkinlikController;

    setUpAll(() async {
      // .env dosyasını yükle
      await dotenv.load(fileName: ".env");
      dio = Dio();
      etkinlikController = Get.put(EtkinlikController());
    });

    testWidgets('Etkinlik API endpoint should be accessible', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('\n🔄 Test başladı: Etkinlik API endpoint should be accessible');

      try {
        // Etkinlik API'sini test et
        final apiUrl = dotenv.env['KULTUR_SANAT_ETKINLILERI_API']!;
        print('📡 API URL: $apiUrl');
        
        final response = await dio.get(apiUrl);
        expect(response.statusCode, 200);
        
        // API yanıtının doğru formatta olduğunu kontrol et
        expect(response.data, isA<List>());
        print('✅ API yanıtı başarıyla alındı');
        
        // Yanıt verilerini Etkinlik modeline dönüştür
        final List<dynamic> eventsData = response.data;
        final events = eventsData.map((data) => Etkinlik.fromJson(data)).toList();
        expect(events, isNotEmpty);
        print('✅ ${events.length} adet etkinlik verisi alındı');
      } catch (e) {
        print('❌ API Hatası: $e');
        fail('API endpoint test failed: $e');
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Test tamamlandı: Etkinlik API endpoint should be accessible');
      print('⏱️ Süre: ${duration.inSeconds}.${duration.inMilliseconds % 1000} saniye\n');
    });

    testWidgets('Etkinlik verileri UI\'da gösterilmeli', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('\n🔄 Test başladı: Etkinlik verileri UI\'da gösterilmeli');

      app.main();
      await tester.pumpAndSettle();

      // Splash screen'den geçiş için bekle
      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pumpAndSettle();

      // Etkinlik verilerinin yüklenmesini bekle
      await tester.pump(const Duration(seconds: 2));
      
      // Etkinlik listesinin yüklendiğini kontrol et
      expect(find.byType(PageView), findsOneWidget);
      print('✅ PageView widget\'ı bulundu');
      
      // Etkinlik başlıklarının gösterildiğini kontrol et
      expect(find.byType(Text), findsWidgets);
      print('✅ Etkinlik başlıkları bulundu');

      // Etkinlik kartlarının varlığını kontrol et
      expect(find.byType(Card), findsWidgets);
      print('✅ Etkinlik kartları bulundu');

      // Etkinlik resimlerinin yüklendiğini kontrol et
      expect(find.byType(Image), findsWidgets);
      print('✅ Etkinlik resimleri bulundu');

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Test tamamlandı: Etkinlik verileri UI\'da gösterilmeli');
      print('⏱️ Süre: ${duration.inSeconds}.${duration.inMilliseconds % 1000} saniye\n');
    });

    testWidgets('Etkinlik detay sayfası açılmalı', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('\n🔄 Test başladı: Etkinlik detay sayfası açılmalı');

      app.main();
      await tester.pumpAndSettle();

      // Splash screen'den geçiş için bekle
      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pumpAndSettle();

      // İlk etkinliğe tıkla
      await tester.tap(find.byType(PageView).first);
      await tester.pumpAndSettle();

      // Detay sayfasının açıldığını kontrol et
      expect(find.byType(Scaffold), findsWidgets);
      print('✅ Detay sayfası Scaffold\'u bulundu');
      
      expect(find.byType(AppBar), findsOneWidget);
      print('✅ Detay sayfası AppBar\'ı bulundu');

      // Detay sayfası içeriğini kontrol et
      expect(find.byType(Image), findsWidgets);
      print('✅ Detay sayfası resmi bulundu');

      expect(find.byType(ListTile), findsWidgets);
      print('✅ Detay sayfası bilgi kartları bulundu');

      // Etkinlik başlığının gösterildiğini kontrol et
      expect(find.byType(Text), findsWidgets);
      print('✅ Detay sayfası metinleri bulundu');

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Test tamamlandı: Etkinlik detay sayfası açılmalı');
      print('⏱️ Süre: ${duration.inSeconds}.${duration.inMilliseconds % 1000} saniye\n');
    });
  });
} 