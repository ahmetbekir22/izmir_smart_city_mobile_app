import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'widget/home_page_test.dart';
import 'widget/eczane_list_test.dart';
import 'widget/plaj_list_test.dart';
import 'widget/etkinlik_list_test.dart';
import 'test_report_generator.dart';

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

void main() {
  HttpOverrides.global = TestHttpOverrides();
  setUpAll(() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (_) {
      // Eğer .env yoksa, test için boş bırak.
    }
  });

  final testResults = <TestResult>[];

  group('HomePage Widget Tests', () {
    homePageTests(testResults);
  });

  group('EczaneList Widget Tests', () {
    eczaneTests(testResults);
  });

  group('PlajList Widget Tests', () {
    plajTests(testResults);
  });

  group('EtkinlikList Widget Tests', () {
    etkinlikTests(testResults);
  });

  tearDownAll(() {
    TestReportGenerator.generateReport(testResults);
  });
}
