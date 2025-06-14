import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smart_city_app/main.dart' as app;
import 'package:smart_city_app/features/splash_screen.dart';
import 'package:smart_city_app/features/auth/views/home_screen_pages/home_screen.dart';
import 'package:smart_city_app/features/auth/views/menu_pages/menu_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Flow Tests', () {
    testWidgets('Splash screen should show and transition to home screen', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('\n🔄 Test başladı: Splash screen should show and transition to home screen');
      
      app.main();
      await tester.pumpAndSettle();

      // Splash screen'in yüklendiğini kontrol et
      expect(find.byType(SplashScreen), findsOneWidget);
      
      // Animasyonların tamamlanmasını bekle
      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pumpAndSettle();
      
      // Home screen'e geçişi kontrol et
      expect(find.byType(HomePage), findsOneWidget);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Test tamamlandı: Splash screen should show and transition to home screen');
      print('⏱️ Süre: ${duration.inSeconds}.${duration.inMilliseconds % 1000} saniye\n');
    });

    testWidgets('Home screen should show all required elements', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('\n🔄 Test başladı: Home screen should show all required elements');
      
      app.main();
      await tester.pumpAndSettle();
      
      // Splash screen'den geçiş için bekle
      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pumpAndSettle();

      // AppBar başlığını kontrol et
      expect(find.text('Kent Rehberim'), findsOneWidget);

      // Menü butonunu kontrol et
      expect(find.byIcon(Icons.menu), findsOneWidget);

      // Tema değiştirme butonunu kontrol et
      expect(find.byIcon(Icons.light_mode), findsOneWidget);

      // LatestEventsScreen'in yüklendiğini kontrol et
      expect(find.byType(PageView), findsOneWidget);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Test tamamlandı: Home screen should show all required elements');
      print('⏱️ Süre: ${duration.inSeconds}.${duration.inMilliseconds % 1000} saniye\n');
    });

    testWidgets('Menu navigation should work', (WidgetTester tester) async {
      final startTime = DateTime.now();
      print('\n🔄 Test başladı: Menu navigation should work');
      
      app.main();
      await tester.pumpAndSettle();
      
      // Splash screen'den geçiş için bekle
      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pumpAndSettle();

      // Menü butonuna tıkla
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Menü sayfasının açıldığını kontrol et
      expect(find.byType(MenuPage), findsOneWidget);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('✅ Test tamamlandı: Menu navigation should work');
      print('⏱️ Süre: ${duration.inSeconds}.${duration.inMilliseconds % 1000} saniye\n');
    });
  });
} 