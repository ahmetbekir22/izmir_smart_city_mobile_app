import 'package:get/get.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import '../../core/api/wifi_api/wifi_model.dart';
import '../../core/api/wifi_api/wifi_service.dart';

class WifiController extends GetxController {
  final wifiList = <Onemliyer>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final WifiApiService apiService = WifiApiService();
  final mapController = Get.put(MapController());

  @override
  void onInit() {
    super.onInit();
    fetchWifiData();
  }

  void fetchWifiData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final fetchedData = await apiService.fetchWifi();
      wifiList.assignAll(fetchedData);
      // Haritaya marker'ları ekle
      mapController.addMarkers(
        locations: wifiList,
        getLatitude: (location) => location.eNLEM ?? 0,
        getLongitude: (location) => location.bOYLAM ?? 0,
        getTitle: (location) => location.aDI ?? 'Bilinmeyen Konum',
        getSnippet: (location) => '${location.mAHALLE ?? ''}, ${location.iLCE ?? ''}',
      );
    } catch (e) {
      errorMessage.value = 'Veriler alınırken bir hata oluştu: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
