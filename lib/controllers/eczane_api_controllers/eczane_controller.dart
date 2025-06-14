import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import 'package:smart_city_app/core/api/eczane/eczane_api_model.dart';
import 'package:smart_city_app/core/api/eczane/eczane_api_service.dart';
import 'package:smart_city_app/core/mixins/performance_monitoring_mixin.dart';
import 'package:smart_city_app/features/auth/views/eczane_pages/eczane_home_screen.dart';

class EczaneController extends GetxController {
  final EczaneService _eczaneService = EczaneService();
  final RxList<Eczane> eczaneList = <Eczane>[].obs;
  final RxList<Eczane> filteredList = <Eczane>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedRegion = ''.obs;
  final mapController = Get.put(MapController());

  @override
  void onInit() {
    super.onInit();
    fetchEczaneler();
  }

  Future<void> fetchEczaneler() async {
    isLoading.value = true;
    PerformanceMonitoringMixin.startApiCall('fetch_pharmacies');
    
    try {
      final response = await _eczaneService.getEczaneler();
      eczaneList.value = response;
      filteredList.value = response;
      _updateMapMarkers(response);
      PerformanceMonitoringMixin.stopApiCall(
        'fetch_pharmacies',
        responseSize: response.toString().length,
        statusCode: '200'
      );
    } catch (e) {
      PerformanceMonitoringMixin.stopApiCall(
        'fetch_pharmacies',
        statusCode: 'error'
      );
      print('Error fetching pharmacies: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterByRegion(String region) {
    PerformanceMonitoringMixin.startApiCall('filter_by_region');
    selectedRegion.value = region;
    
    if (region.isEmpty) {
      filteredList.value = eczaneList;
    } else {
      filteredList.value = eczaneList.where((eczane) => 
        eczane.bolge?.toLowerCase().contains(region.toLowerCase()) ?? false
      ).toList();
    }
    
    _updateMapMarkers(filteredList.value);
    PerformanceMonitoringMixin.stopApiCall('filter_by_region');
  }

  void clearFilters() {
    PerformanceMonitoringMixin.startApiCall('clear_pharmacy_filters');
    selectedRegion.value = '';
    filteredList.value = eczaneList;
    _updateMapMarkers(eczaneList.value);
    PerformanceMonitoringMixin.stopApiCall('clear_pharmacy_filters');
  }

  void _updateMapMarkers(List<Eczane> eczaneler) {
    mapController.addMarkers(
      locations: eczaneler,
      getLatitude: (eczane) => double.tryParse(eczane.lokasyonX ?? '0') ?? 0,
      getLongitude: (eczane) => double.tryParse(eczane.lokasyonY ?? '0') ?? 0,
      getTitle: (eczane) => eczane.adi ?? 'Bilinmiyor',
      getSnippet: (eczane) => 
          'Bölge: ${eczane.bolge ?? 'Bilinmiyor'}',
    );
  }
}