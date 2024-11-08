import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/features/auth/views/home_page.dart';

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
      title: 'Etkinlik Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
