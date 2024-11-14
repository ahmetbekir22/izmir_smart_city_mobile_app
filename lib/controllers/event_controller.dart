import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_city_app/core/api/event_api_service.dart';
import '../core/api/events_model.dart';
import '../utils/making_data_unique.dart';

class EtkinlikController extends GetxController {
  var etkinlikListesi = <Etkinlik>[].obs;
  var filteredEventList = <Etkinlik>[].obs;
  var currentIndex = 0.obs;
  late PageController pageController;
  Timer? _timer;

  var selectedLocation = Rxn<String>();
  var selectedDateRange = Rxn<DateTimeRange>();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    loadEtkinlikler();
    clearFilters(); // Clear filters when entering the page
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
      etkinlikListesi.value =
          filterUniqueById(etkinlikler, (etkinlik) => etkinlik.id);
      applyFilters();
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
      if (pageController.hasClients) {
        pageController.animateToPage(
          currentIndex.value,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void _stopEventRotation() {
    _timer?.cancel();
  }

  List<String> getUniqueLocations() {
    return etkinlikListesi.map((e) => e.etkinlikMerkezi).toSet().toList();
  }

  void applyFilters() {
    List<Etkinlik> filteredList = etkinlikListesi.toList();

    if (selectedLocation.value != null) {
      filteredList = filteredList
          .where(
              (etkinlik) => etkinlik.etkinlikMerkezi == selectedLocation.value)
          .toList();
    }

    if (selectedDateRange.value != null) {
      DateTimeRange range = selectedDateRange.value!;
      filteredList = filteredList.where((etkinlik) {
        DateTime etkinlikDate = DateTime.parse(etkinlik.etkinlikBaslamaTarihi);
        return etkinlikDate
                .isAfter(range.start.subtract(const Duration(days: 1))) &&
            etkinlikDate.isBefore(range.end.add(const Duration(days: 1)));
      }).toList();
    }

    filteredEventList.value = filteredList;
  }

  void updateSelectedLocation(String? location) {
    selectedLocation.value = location;
    applyFilters();
  }

  void updateSelectedDateRange(DateTimeRange? range) {
    selectedDateRange.value = range;
    applyFilters();
  }

  // Clear filters
  void clearFilters() {
    selectedLocation.value = null;
    selectedDateRange.value = null;
    applyFilters(); // Reset the filtered list to show all events
  }
}
