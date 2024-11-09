import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/core/api/event_api_service.dart';
import '../core/api/events_model.dart';

class EtkinlikController extends GetxController {
  var etkinlikListesi = <Etkinlik>[].obs;
  var currentIndex = 0.obs;
  late PageController pageController;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    loadEtkinlikler();
    _startEventRotation();
  }

  @override
  void onClose() {
    _stopEventRotation();
    pageController.dispose();
    super.onClose();
  }

  void loadEtkinlikler() async {
    try {
      etkinlikListesi.value = await EtkinlikApiService().fetchEtkinlikler();
    } catch (e) {
      throw Exception('Failed to load etkinlikler: $e');
    }
  }

  void _startEventRotation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentIndex.value < etkinlikListesi.length - 1) {
        currentIndex.value++;
      } else {
        currentIndex.value = 0;
      }
      pageController.animateToPage(
        currentIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  void _stopEventRotation() {
    _timer?.cancel();
  }
}
