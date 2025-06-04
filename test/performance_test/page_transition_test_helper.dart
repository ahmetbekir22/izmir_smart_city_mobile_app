import 'package:flutter/material.dart';
import 'advanced_performance_helper.dart';

class PageTransitionTestHelper {
  static final PageTransitionTestHelper _instance = PageTransitionTestHelper._internal();
  factory PageTransitionTestHelper() => _instance;
  PageTransitionTestHelper._internal();

  Future<void> testPageTransition({
    required BuildContext context,
    required String fromPage,
    required String toPage,
    required Widget Function() pageBuilder,
  }) async {
    await AdvancedPerformanceHelper().trackScreenTransition(
      fromScreen: fromPage,
      toScreen: toPage,
      transition: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pageBuilder()),
        );
      },
    );
  }

  Future<void> testPageTransitionWithData({
    required BuildContext context,
    required String fromPage,
    required String toPage,
    required Widget Function(dynamic data) pageBuilder,
    required dynamic data,
  }) async {
    await AdvancedPerformanceHelper().trackScreenTransition(
      fromScreen: fromPage,
      toScreen: toPage,
      transition: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => pageBuilder(data),
          ),
        );
      },
    );
  }
} 