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
      print('\n🔄 Test Started: Etkinlik API endpoint should be accessible');

      try {
        // Etkinlik API'sini test et
        final apiUrl = dotenv.env['KULTUR_SANAT_ETKINLILERI_API']!;
        print('📡 API URL: $apiUrl');
        
        final response = await dio.get(apiUrl);
        expect(response.statusCode, 200);
        
        // API yanıtının doğru formatta olduğunu kontrol et
        expect(response.data, isA<List>());
        print('✅ API response received successfully');
        
        // Yanıt verilerini Etkinlik modeline dönüştür
        final List<dynamic> eventsData = response.data;
        final events = eventsData.map((data) => Etkinlik.fromJson(data)).toList();
        expect(events, isNotEmpty);
        print('✅ ${events.length} activity data were received');
      } catch (e) {
        print('❌ API Error: $e');
        fail('API endpoint test failed: $e');
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Test Completed: Etkinlik API endpoint should be accessible');
      print('⏱️ Time: ${duration.inSeconds}.${duration.inMilliseconds % 1000} seconds\n');
    });

    testWidgets('Event data should be displayed in the UI', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('\n🔄 Test Started: Event data should be displayed in the UI');

      app.main();
      await tester.pumpAndSettle();

      // Splash screen'den geçiş için bekle
      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pumpAndSettle();

      // Etkinlik verilerinin yüklenmesini bekle
      await tester.pump(const Duration(seconds: 2));
      
      // Etkinlik listesinin yüklendiğini kontrol et
      expect(find.byType(PageView), findsOneWidget);
      print('✅ PageView widget found');
      
      // Etkinlik başlıklarının gösterildiğini kontrol et
      expect(find.byType(Text), findsWidgets);
      print('✅ Event titles found');

      // Etkinlik kartlarının varlığını kontrol et
      expect(find.byType(Card), findsWidgets);
      print('✅ Event cards found');

      // Etkinlik resimlerinin yüklendiğini kontrol et
      expect(find.byType(Image), findsWidgets);
      print('✅ Event images found');

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Test Complated: Event data should be displayed in the UI');
      print('⏱️ Time: ${duration.inSeconds}.${duration.inMilliseconds % 1000} seconds\n');
    });

    testWidgets('The event detail page should open', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('\n🔄 Test Started: The event detail page should open');

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
      print('✅ Detail page Scaffold found');
      
      expect(find.byType(AppBar), findsOneWidget);
      print('✅ Detail page AppBar found');

      // Detay sayfası içeriğini kontrol et
      expect(find.byType(Image), findsWidgets);
      print('✅ Detail page image found');

      expect(find.byType(ListTile), findsWidgets);
      print('✅ Detail page information cards found');

      // Etkinlik başlığının gösterildiğini kontrol et
      expect(find.byType(Text), findsWidgets);
      print('✅ Detail page texts found');

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Test Completed: The event detail page should open');
      print('⏱️ Time: ${duration.inSeconds}.${duration.inMilliseconds % 1000} seconds\n');
    });
  });
} 