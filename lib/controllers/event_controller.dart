import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_city_app/core/api/event_api_service.dart';
import '../core/api/events_model.dart';
import '../utils/data_cleaning_utility.dart';
import '../utils/making_data_unique.dart';

class EtkinlikController extends GetxController {
  var etkinlikListesi = <Etkinlik>[].obs;
  var filteredEventList = <Etkinlik>[].obs;
  var currentIndex = 0.obs;
  late PageController pageController;
  Timer? _timer;

  // Observables for selected location and date range
  var selectedLocation = Rxn<String>();
  var selectedDateRange = Rxn<DateTimeRange>();

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
      applyFilters(); // Apply filters after loading events
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

  // Get unique locations for the filter dropdown
  List<String> getUniqueLocations() {
    return etkinlikListesi.map((e) => e.etkinlikMerkezi).toSet().toList();
  }

  // Apply filters based on selected location and date range
  void applyFilters() {
    List<Etkinlik> filteredList = etkinlikListesi.toList();

    if (selectedLocation.value != null) {
      filteredList = filteredList
          .where((etkinlik) => etkinlik.etkinlikMerkezi == selectedLocation.value)
          .toList();
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

  // Update selected location and apply filters
  void updateSelectedLocation(String? location) {
    selectedLocation.value = location;
    applyFilters();
  }

  // Update selected date range and apply filters
  void updateSelectedDateRange(DateTimeRange? range) {
    selectedDateRange.value = range;
    applyFilters();
  }
}
