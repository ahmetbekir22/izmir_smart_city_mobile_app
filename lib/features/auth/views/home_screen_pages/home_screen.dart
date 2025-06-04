import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/home_controllers/home_controller.dart';
import '../../../../controllers/theme_contoller.dart';
import '../../../../core/mixins/performance_monitoring_mixin.dart';
import '../../widgets/draggable_sheet_page.dart';
import 'latest_events_screen.dart';
import '../menu_pages/menu_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
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
    final ThemeController themeController = Get.put(ThemeController());
    final HomeController homeController = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
         leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            startPageLoadTrace('menu_page_transition');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuPage()),
            ).then((_) => stopPageLoadTrace());
          },
        ),
        title: const Text(
          'Kent Rehberim',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Obx(() => Icon(
                  themeController.isDarkTheme.value
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Get.theme.colorScheme.onPrimary,
                )),
            onPressed: () {
              startPageLoadTrace('theme_toggle');
              themeController.toggleTheme();
              stopPageLoadTrace();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Get.theme.colorScheme.primary,
                  Get.theme.colorScheme.secondary,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: LatestEventsScreen(),
          ),
          Positioned.fill(
            child: DraggableSheetPage(
              homeController: homeController,
              themeController: themeController,
            ),
          ),
        ],
      ),
    );
  }
}
