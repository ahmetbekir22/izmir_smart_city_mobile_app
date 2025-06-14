import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/api/etkinlik/event_api_service.dart';
import '../../core/api/etkinlik/events_model.dart';
import '../../utils/making_data_unique.dart';
import '../../core/mixins/performance_monitoring_mixin.dart';

class EtkinlikController extends GetxController {
  final EtkinlikApiService _eventsService = EtkinlikApiService();
  // Observable lists for events
  var etkinlikListesi = <Etkinlik>[].obs;
  var filteredEventList = <Etkinlik>[].obs;
  var favoriteEvents = <Etkinlik>[].obs;
  
  // Page control variables
  var currentIndex = 0.obs;
  late PageController pageController;
  Timer? _timer;

  // Filter variables
  var selectedLocation = Rxn<String>();
  var selectedType = Rxn<String>();
  var selectedDateRange = Rxn<DateTimeRange>();
  
  // Loading state
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    loadEtkinlikler();
    clearFilters();
    _startEventRotation();
    _loadFavorites();
  }

  @override
  void onClose() {
    _stopEventRotation();
    pageController.dispose();
    super.onClose();
  }

  // Event loading and management
  Future<void> loadEtkinlikler() async {
    isLoading.value = true;
    PerformanceMonitoringMixin.startApiCall('fetch_events');
    
    try {
      hasError.value = false;
      final etkinlikler = await _eventsService.fetchEtkinlikler();
      etkinlikListesi.value = filterUniqueById(etkinlikler, (etkinlik) => etkinlik.id);
      filteredEventList.value = etkinlikler;
      applyFilters();
      PerformanceMonitoringMixin.stopApiCall(
        'fetch_events',
        responseSize: etkinlikler.toString().length,
        statusCode: '200'
      );
    } catch (e) {
      PerformanceMonitoringMixin.stopApiCall(
        'fetch_events',
        statusCode: 'error'
      );
      hasError.value = true;
      errorMessage.value = 'Etkinlikler yüklenirken hata oluştu: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshEvents() async {
    await loadEtkinlikler();
  }

  // Carousel rotation methods
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

  // Filter methods
  List<String> getUniqueLocations() {
    return etkinlikListesi.map((e) => e.etkinlikMerkezi).toSet().toList()..sort();
  }

  List<String> getUniqueTypes() {
    return etkinlikListesi.map((e) => e.tur).toSet().toList()..sort();
  }

  void applyFilters() {
    PerformanceMonitoringMixin.startApiCall('apply_filters');
    List<Etkinlik> filteredList = etkinlikListesi.toList();
    
    if (selectedLocation.value != null) {
      filteredList = filteredList
          .where((etkinlik) => etkinlik.etkinlikMerkezi == selectedLocation.value)
          .toList();
    }

    if (selectedType.value != null) {
      filteredList = filteredList
          .where((etkinlik) => etkinlik.tur == selectedType.value)
          .toList();
    }

    if (selectedDateRange.value != null) {
      DateTimeRange range = selectedDateRange.value!;
      filteredList = filteredList.where((etkinlik) {
        DateTime etkinlikDate = DateTime.parse(etkinlik.etkinlikBaslamaTarihi);
        return etkinlikDate.isAfter(range.start.subtract(const Duration(days: 1))) &&
            etkinlikDate.isBefore(range.end.add(const Duration(days: 1)));
      }).toList();
    }

    // Sort by date
    filteredList.sort((a, b) => DateTime.parse(a.etkinlikBaslamaTarihi)
        .compareTo(DateTime.parse(b.etkinlikBaslamaTarihi)));

    filteredEventList.value = filteredList;
    PerformanceMonitoringMixin.stopApiCall('apply_filters');
  }

  void updateSelectedLocation(String? location) {
    PerformanceMonitoringMixin.startApiCall('filter_by_location');
    selectedLocation.value = location;
    applyFilters();
    PerformanceMonitoringMixin.stopApiCall('filter_by_location');
  }

  void updateSelectedType(String? type) {
    PerformanceMonitoringMixin.startApiCall('filter_by_type');
    selectedType.value = type;
    applyFilters();
    PerformanceMonitoringMixin.stopApiCall('filter_by_type');
  }

  void updateSelectedDateRange(DateTimeRange? range) {
    PerformanceMonitoringMixin.startApiCall('filter_by_date');
    selectedDateRange.value = range;
    applyFilters();
    PerformanceMonitoringMixin.stopApiCall('filter_by_date');
  }

  void clearFilters() {
    PerformanceMonitoringMixin.startApiCall('clear_filters');
    selectedLocation.value = null;
    selectedType.value = null;
    selectedDateRange.value = null;
    applyFilters();
    PerformanceMonitoringMixin.stopApiCall('clear_filters');
  }

  // Favorite events management
  void _loadFavorites() {
    // Implement loading from local storage if needed
  }

  void toggleFavorite(Etkinlik etkinlik) {
    if (favoriteEvents.contains(etkinlik)) {
      favoriteEvents.remove(etkinlik);
    } else {
      favoriteEvents.add(etkinlik);
    }
    // Implement saving to local storage if needed
  }

  bool isFavorite(Etkinlik etkinlik) {
    return favoriteEvents.contains(etkinlik);
  }

  // Date formatting utilities
  String formatDate(String etkinlikBaslamaTarihi) {
    try {
      final DateTime dateTime = DateTime.parse(etkinlikBaslamaTarihi);
      return DateFormat('dd.MM.yyyy').format(dateTime);
    } catch (e) {
      return 'Geçersiz tarih';
    }
  }

  String formatTime(String etkinlikBaslamaTarihi) {
    try {
      final DateTime dateTime = DateTime.parse(etkinlikBaslamaTarihi);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return 'Geçersiz saat';
    }
  }

  // Search functionality
  List<Etkinlik> searchEvents(String query) {
    if (query.isEmpty) {
      return filteredEventList;
    }
    return filteredEventList.where((etkinlik) =>
        etkinlik.adi.toLowerCase().contains(query.toLowerCase()) ||
        etkinlik.etkinlikMerkezi.toLowerCase().contains(query.toLowerCase()) ||
        etkinlik.tur.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Event status utilities
  bool isEventActive(Etkinlik etkinlik) {
    final now = DateTime.now();
    final startDate = DateTime.parse(etkinlik.etkinlikBaslamaTarihi);
    final endDate = DateTime.parse(etkinlik.etkinlikBitisTarihi);
    return now.isBefore(endDate) && now.isAfter(startDate);
  }

  bool isEventUpcoming(Etkinlik etkinlik) {
    final now = DateTime.now();
    final startDate = DateTime.parse(etkinlik.etkinlikBaslamaTarihi);
    return now.isBefore(startDate);
  }

  bool isEventPast(Etkinlik etkinlik) {
    final now = DateTime.now();
    final endDate = DateTime.parse(etkinlik.etkinlikBitisTarihi);
    return now.isAfter(endDate);
  }
}