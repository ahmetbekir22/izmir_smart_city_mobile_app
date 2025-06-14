import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/features/auth/views/home_screen_pages/home_screen.dart';
import 'package:smart_city_app/controllers/etkinlik_api_controllers/event_controller.dart';
import 'dart:io';
import '../test_report_generator.dart';

// NetworkImage mock için HttpOverrides
class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// Timer hatasını önlemek için mock controller
class MockEtkinlikController extends EtkinlikController {
  @override
  void onInit() {
    isLoading.value = true;
    pageController = PageController();
    loadEtkinlikler();
    clearFilters();
    _loadFavorites();
    // Yükleme durumunu kısa süre sonra false yap
    Future.delayed(Duration(milliseconds: 200), () {
      isLoading.value = false;
    });
  }

  @override
  void _startEventRotation() {/* override, timer başlatma */}
  @override
  void _loadFavorites() {/* override, favori yükleme yok */}
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

void homePageTests(List<TestResult> testResults) {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  setUp(() {
    Get.reset();
    Get.put<EtkinlikController>(MockEtkinlikController());
  });

  testWidgets('HomePage basic visibility test', (WidgetTester tester) async {
    try {
      await tester.pumpWidget(GetMaterialApp(home: HomePage()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Kent Rehberim'), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byIcon(Icons.light_mode), findsOneWidget);
      expect(find.text('Hayatı Kolaylaştıran Hizmetler...'), findsOneWidget);
      testResults.add(
          TestResult(name: 'HomePage basic visibility test', success: true));
    } catch (e) {
      testResults.add(TestResult(
          name: 'HomePage basic visibility test',
          success: false,
          error: e.toString()));
      rethrow;
    }
  });

  testWidgets('HomePage categories test', (WidgetTester tester) async {
    try {
      await tester.pumpWidget(GetMaterialApp(home: HomePage()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('ACİL'), findsOneWidget);
      expect(find.text('Seyahat'), findsOneWidget);
      expect(find.text('İhtiyaç'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
      testResults
          .add(TestResult(name: 'HomePage categories test', success: true));
    } catch (e) {
      testResults.add(TestResult(
          name: 'HomePage categories test',
          success: false,
          error: e.toString()));
      rethrow;
    }
  });

  testWidgets('HomePage category selection test', (WidgetTester tester) async {
    try {
      await tester.pumpWidget(GetMaterialApp(home: HomePage()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.text('Seyahat'), warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byIcon(Icons.keyboard_arrow_up),
          warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      testResults.add(
          TestResult(name: 'HomePage category selection test', success: true));
    } catch (e) {
      testResults.add(TestResult(
          name: 'HomePage category selection test',
          success: false,
          error: e.toString()));
      rethrow;
    }
  });

  testWidgets('HomePage events loading state test',
      (WidgetTester tester) async {
    try {
      await tester.pumpWidget(GetMaterialApp(home: HomePage()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      testResults.add(TestResult(
          name: 'HomePage events loading state test', success: true));
    } catch (e) {
      testResults.add(TestResult(
          name: 'HomePage events loading state test',
          success: false,
          error: e.toString()));
      rethrow;
    }
  });
}
