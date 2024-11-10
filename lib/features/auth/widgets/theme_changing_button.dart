import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/theme_contoller.dart';

class ThemeToggleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ThemeToggleAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: Obx(() => Icon(
                themeController.isDarkTheme.value ? Icons.dark_mode : Icons.light_mode,
                color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
              )),
          onPressed: themeController.toggleTheme,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
