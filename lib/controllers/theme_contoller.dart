import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final isDarkTheme = false.obs;

  // void toggleTheme() {
  //   if (themeMode.value == ThemeMode.light) {
  //     themeMode.value = ThemeMode.dark;
  //   } else {
  //     themeMode.value = ThemeMode.light;
  //   }
  //   update(); // Tüm dinleyicilere değişiklik olduğunu bildir
  // }

  void toggleTheme() {
    isDarkTheme.value = !isDarkTheme.value;
    Get.changeThemeMode(isDarkTheme.value ? ThemeMode.dark : ThemeMode.light);
  }
}
