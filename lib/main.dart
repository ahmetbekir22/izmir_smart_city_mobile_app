import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance/firebase_performance.dart';

import 'controllers/theme_contoller.dart';
import 'features/splash_screen.dart';
import 'themes/dark_theme.dart';
import 'themes/light_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Start app launch trace
  final trace = FirebasePerformance.instance.newTrace('app_launch');
  await trace.start();
  
  Get.put(ThemeController());
  await dotenv.load(fileName: ".env");
  
  runApp(const MyApp());
  
  // Stop app launch trace after app is built
  await trace.stop();
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
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
