import 'package:get/get.dart';
import '../../core/api/wifi_api/wifi_model.dart';
import '../../core/api/wifi_api/wifi_service.dart';

class WifiController extends GetxController {
  final wifiList = <Onemliyer>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final WifiApiService apiService = WifiApiService();

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
    } catch (e) {
      errorMessage.value = 'Veriler alınırken bir hata oluştu: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
