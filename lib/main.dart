import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/features/auth/views/home_screen.dart';

import 'controllers/theme_contoller.dart';
import 'themes/dark_theme.dart';
import 'themes/light_theme.dart';

Future<void> main() async {
  Get.put(ThemeController());
  await dotenv.load(fileName: ".env"); // .env dosyasını yükle
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart City',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      // Set initial theme mode
      home: const HomePage(),
      //home: EtkinlikListesiSayfasi(),
    );
  }
}
