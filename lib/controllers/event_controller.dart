import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_city_app/core/api/event_api_service.dart';

import '../core/api/events_model.dart';

class EtkinlikController extends GetxController {
  var etkinlikListesi = <Etkinlik>[].obs; // Tüm etkinlikler
  var filteredEventList = <Etkinlik>[].obs; // Filtrelenmiş etkinlikler
  var selectedLocation = Rxn<String>(); // Seçilen konum
  var selectedDateRange = Rxn<DateTimeRange>(); // Seçilen tarih aralığı

  late PageController pageController;
  Timer? _timer;
  var currentIndex = 0.obs;

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

  // Etkinlikleri yüklerken tarihleri formatlıyoruz
  void loadEtkinlikler() async {
    try {
      final etkinlikler = await EtkinlikApiService().fetchEtkinlikler();
      // Verileri alırken saatleri formatla
      for (var etkinlik in etkinlikler) {
        etkinlik.etkinlikBaslamaTarihi = _formatTime(etkinlik.etkinlikBaslamaTarihi);
        etkinlik.etkinlikBitisTarihi = _formatTime(etkinlik.etkinlikBitisTarihi);
      }

      // Verileri listeye ekle
      etkinlikListesi.value = etkinlikler;
      applyFilters(); // Filtreleme işlemi uygula
    } catch (e) {
      throw Exception('Failed to load etkinlikler: $e');
    }
  }

  // Zamanı formatlama işlemi
  String _formatTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('HH:mm').format(dateTime); // Saat: Dakika formatı
  }

  // Filtreleme işlemi
  void applyFilters() {
    List<Etkinlik> filteredList = etkinlikListesi.toList();

    if (selectedLocation.value != null) {
      filteredList = filteredList.where((etkinlik) {
        return etkinlik.etkinlikMerkezi == selectedLocation.value;
      }).toList();
    }

    if (selectedDateRange.value != null) {
      DateTimeRange range = selectedDateRange.value!;
      filteredList = filteredList.where((etkinlik) {
        DateTime etkinlikDate = DateTime.parse(etkinlik.etkinlikBaslamaTarihi);
        return etkinlikDate.isAfter(range.start) && etkinlikDate.isBefore(range.end);
      }).toList();
    }

    filteredEventList.value = filteredList;
  }

  // Etkinlikleri döngüye al
  void _startEventRotation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentIndex.value < etkinlikListesi.length - 1) {
        currentIndex.value++;
      } else {
        currentIndex.value = 0;
      }
      if (pageController.hasClients) {
        pageController.animateToPage(
          currentIndex.value,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  // Döngüyü durdur
  void _stopEventRotation() {
    _timer?.cancel();
  }
}
