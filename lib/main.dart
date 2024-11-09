import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/features/auth/views/home_screen.dart';

import 'themes/dark_theme.dart';
import 'themes/light_theme.dart';

Future<void> main() async {
  await dotenv.load(
      fileName:
          "/Users/ahmetbekir/smart_city_app/smart_city_app/.env"); // .env dosyasını yükle
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Set initial theme mode
      home: const HomePage(),
    );
  }
}
