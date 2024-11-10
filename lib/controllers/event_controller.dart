import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/core/api/event_api_service.dart';

import '../core/api/events_model.dart';
import '../utils/data_cleaning_utility.dart';
import '../utils/making_data_unique.dart';

class EtkinlikController extends GetxController {
  var etkinlikListesi = <Etkinlik>[].obs;
  var currentIndex = 0.obs;
  late PageController pageController;
  Timer? _timer;
  var events = <dynamic>[].obs;

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
      final etkinlikler = await EtkinlikApiService().fetchEtkinlikler();
      etkinlikListesi.value = filterUniqueById(etkinlikler, (etkinlik) => etkinlik.id);
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

  void setEventDetails(dynamic event) {
    String cleanedDescription = DataCleaningUtility.cleanHtmlText(event["KisaAciklama"]);
    event["KisaAciklama"] = cleanedDescription;
    events.add(event); // Temizlenmiş veriyi listeye ekle
  }
}
