import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'page_transition_tests.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PageTransitionTestApp());
}

class PageTransitionTestApp extends StatelessWidget {
  const PageTransitionTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page Transition Tests',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PageTransitionTestWidget(),
    );
  }
} 