// home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/theme_contoller.dart';
import '../widgets/draggable_sheet_page.dart';
import 'latest_events_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    final HomeController homeController = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('İzmir Smart City'),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: Obx(() => Icon(
                  themeController.isDarkTheme.value
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: themeController.isDarkTheme.value
                      ? Get.theme.colorScheme.onPrimary
                      : Get.theme.colorScheme.onSecondary,
                )),
            onPressed: themeController.toggleTheme,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: LatestEventsScreen(),
              ),
            ],
          ),
          DraggableSheetPage(
            homeController: homeController,
            themeController: themeController,
          ),
        ],
      ),
    );
  }
}