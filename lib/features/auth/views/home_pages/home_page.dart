import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/mixins/performance_monitoring_mixin.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with PerformanceMonitoringMixin {
  @override
  void initState() {
    super.initState();
    startPageLoadTrace('home_page');
  }

  @override
  void dispose() {
    stopPageLoadTrace();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/eczane');
              },
              child: const Text('Eczaneler'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/etkinlik');
              },
              child: const Text('Etkinlikler'),
            ),
          ],
        ),
      ),
    );
  }
} 