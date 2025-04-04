import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import 'package:smart_city_app/core/api/eczane/eczane_api_model.dart';
import 'package:smart_city_app/core/api/eczane/eczane_api_service.dart';

class EczaneController extends GetxController {
  final eczaneList = <Eczane>[].obs;
  final filteredList = <Eczane>[].obs;
  final isLoading = true.obs;
  final selectedRegion = ''.obs;
  final mapController = Get.put(MapController());

  @override
  void onInit() {
    fetchEczaneler();
    super.onInit();
  }

  void fetchEczaneler() async {
    try {
      isLoading(true);
      var eczaneler = await EczaneService().getEczaneler();
      eczaneList.value = eczaneler;
      filteredList.value = eczaneler;
      _updateMapMarkers(eczaneler);
    } finally {
      isLoading(false);
    }
  }

  void filterByRegion(String region) {
    selectedRegion.value = region;
    List<Eczane> filtered;
    
    if (region.isEmpty) {
      filtered = eczaneList;
    } else {
      filtered = eczaneList
          .where((eczane) => eczane.bolge?.toLowerCase() == region.toLowerCase())
          .toList();
    }
    
    filteredList.value = filtered;
    _updateMapMarkers(filtered);
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