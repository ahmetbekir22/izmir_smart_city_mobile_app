import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_city_app/features/auth/views/menu_pages/hakkinda_page.dart';
import 'advanced_performance_monitor.dart';
import 'page_transition_test_helper.dart';

// Import all pages
import 'package:smart_city_app/features/auth/views/eczane_pages/eczane_home_screen.dart';
import 'package:smart_city_app/features/auth/views/event_pages/event_list.dart';
import 'package:smart_city_app/features/auth/views/event_pages/event_detail_screen.dart';
import 'package:smart_city_app/features/auth/views/wifi_pages/wifi_list.dart';
import 'package:smart_city_app/features/auth/views/veteriner_pages/veteriner_list.dart';
import 'package:smart_city_app/features/auth/views/tarihi_yerler_pages/tarihi_list.dart';
import 'package:smart_city_app/features/auth/views/plaj_pages/plaj_list.dart';
import 'package:smart_city_app/features/auth/views/pazar_yeri_pages/pazar_yeri_home_screen.dart';
import 'package:smart_city_app/features/auth/views/menu_pages/menu_page.dart';
import 'package:smart_city_app/features/auth/views/map_pages/map_view.dart';
import 'package:smart_city_app/features/auth/views/kütüphane_pages/kutuphane_list.dart';
import 'package:smart_city_app/features/auth/views/home_screen_pages/home_screen.dart';
import 'package:smart_city_app/features/auth/views/galeri_salonu_pages/galeri_list.dart';
import 'package:smart_city_app/features/auth/views/afet_pages/afet_list.dart';
import 'package:smart_city_app/features/auth/views/antik_kent_pages/antik_list.dart';
import 'package:smart_city_app/features/auth/views/otopark_pages/otopark_home_screen.dart';
import 'package:smart_city_app/features/auth/views/bisiklet_home_pages/bisiklet_home_screen.dart';

class PageTransitionTests {
  static final PageTransitionTests _instance = PageTransitionTests._internal();
  factory PageTransitionTests() => _instance;
  PageTransitionTests._internal();

  Future<void> runAllTests(BuildContext context) async {
    await _testEczaneTransitions(context);
    await _testEventTransitions(context);
    await _testWifiTransitions(context);
    await _testVeterinerTransitions(context);
    await _testTarihiYerlerTransitions(context);
    await _testPlajTransitions(context);
    await _testPazarYeriTransitions(context);
    await _testMenuTransitions(context);
    await _testMapTransitions(context);
    await _testKutuphaneTransitions(context);
    await _testHomeScreenTransitions(context);
    await _testGaleriSalonuTransitions(context);
    await _testAfetTransitions(context);
    await _testAntikKentTransitions(context);
    await _testOtoparkTransitions(context);
    await _testBisikletTransitions(context);
  }

  Future<void> _testEczaneTransitions(BuildContext context) async {
    final helper = PageTransitionTestHelper();
    await helper.testPageTransition(
      context: context,
      fromPage: 'eczane_home',
      toPage: 'eczane_detail',
      pageBuilder: () => const EczaneListPage(),
    );
  }

  Future<void> _testEventTransitions(BuildContext context) async {
    final helper = PageTransitionTestHelper();
    
    // Test Event List to Detail
    await helper.testPageTransition(
      context: context,
      fromPage: 'event_list',
      toPage: 'event_detail',
      pageBuilder: () => EtkinlikListesiSayfasi(),
    );

    // Test Event Detail to List
    await helper.testPageTransition(
      context: context,
      fromPage: 'event_detail',
      toPage: 'event_list',
      pageBuilder: () => EtkinlikListesiSayfasi(),
    );
  }

  Future<void> _testWifiTransitions(BuildContext context) async {
    final helper = PageTransitionTestHelper();
    await helper.testPageTransition(
      context: context,
      fromPage: 'wifi_list',
      toPage: 'wifi_detail',
      pageBuilder: () => WifiList(),
    );
  }

  Future<void> _testVeterinerTransitions(BuildContext context) async {
    final helper = PageTransitionTestHelper();
    await helper.testPageTransition(
      context: context,
      fromPage: 'veteriner_list',
      toPage: 'veteriner_detail',
      pageBuilder: () =>  VeterinerList(),
    );
  }

  Future<void> _testTarihiYerlerTransitions(BuildContext context) async {
    final helper = PageTransitionTestHelper();
    await helper.testPageTransition(
      context: context,
      fromPage: 'tarihi_yerler_list',
      toPage: 'tarihi_yerler_detail',
      pageBuilder: () =>  TarihiList(),
    );
  }

  Future<void> _testPlajTransitions(BuildContext context) async {
    final helper = PageTransitionTestHelper();
    await helper.testPageTransition(
      context: context,
      fromPage: 'plaj_list',
      toPage: 'plaj_detail',
      pageBuilder: () => PlajList(),
    );
  }

  Future<void> _testPazarYeriTransitions(BuildContext context) async {
    final helper = PageTransitionTestHelper();
    await helper.testPageTransition(
      context: context,
      fromPage: 'pazar_yeri_list',
      toPage: 'pazar_yeri_detail',
      pageBuilder: () => PazarYeriHomeScreen(),
    );
  }

  Future<void> _testMenuTransitions(BuildContext context) async {
    final helper = PageTransitionTestHelper();
    await helper.testPageTransition(
      context: context,
      fromPage: 'menu_list',
      toPage: 'menu_detail',
      pageBuilder: () => const HakkindaPage(),
    );
  }

  Future<void> _testMapTransitions(BuildContext context) async {
    final helper = PageTransitionTestHelper();
    await helper.testPageTransition(
      context: context,
      fromPage: 'map_view',
      toPage: 'map_detail',
      pageBuilder: () => const MapView(),
    );
  }

  Future<void> _testKutuphaneTransitions(BuildContext context) async {
    final helper = PageTransitionTestHelper();
    await helper.testPageTransition(
      context: context,
      fromPage: 'kutuphane_list',
      toPage: 'kutuphane_detail',
      pageBuilder: () =>  KutuphaneList(),
    );
  }

  Future<void> _testHomeScreenTransitions(BuildContext context) async {
    final helper = PageTransitionTestHelper();
    await helper.testPageTransition(
      context: context,
      fromPage: 'home_screen',
      toPage: 'home_detail',
      pageBuilder: () => const HomePage(),
    );
  }

  Future<void> _testGaleriSalonuTransitions(BuildContext context) async {
    final helper = PageTransitionTestHelper();
    await helper.testPageTransition(
      context: context,
      fromPage: 'galeri_salonu_list',
      toPage: 'galeri_salonu_detail',
      pageBuilder: () => GaleriList(),
    );
  }

  Future<void> _testAfetTransitions(BuildContext context) async {
    final helper = PageTransitionTestHelper();
    await helper.testPageTransition(
      context: context,
      fromPage: 'afet_list',
      toPage: 'afet_detail',
      pageBuilder: () => AfetList(),
    );
  }

  Future<void> _testAntikKentTransitions(BuildContext context) async {
    final helper = PageTransitionTestHelper();
    await helper.testPageTransition(
      context: context,
      fromPage: 'antik_kent_list',
      toPage: 'antik_kent_detail',
      pageBuilder: () => AntikList(),
    );
  }

  Future<void> _testOtoparkTransitions(BuildContext context) async {
    final helper = PageTransitionTestHelper();
    await helper.testPageTransition(
      context: context,
      fromPage: 'otopark_list',
      toPage: 'otopark_detail',
      pageBuilder: () => OtoparkHomeScreen(),
    );
  }

  Future<void> _testBisikletTransitions(BuildContext context) async {
    final helper = PageTransitionTestHelper();
    await helper.testPageTransition(
      context: context,
      fromPage: 'bisiklet_list',
      toPage: 'bisiklet_detail',
      pageBuilder: () => BisikletHomeScreen(),
    );
  }
}

// Test widget to run all transitions
class PageTransitionTestWidget extends StatelessWidget {
  const PageTransitionTestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdvancedPerformanceMonitor(
      screenName: 'page_transition_test',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Page Transition Tests'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => PageTransitionTests().runAllTests(context),
                child: const Text('Run All Page Transition Tests'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 