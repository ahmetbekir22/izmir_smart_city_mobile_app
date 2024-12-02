import 'package:get/get.dart';

import '../../core/api/otopark_api/otopark_api_model.dart';
import '../../core/api/otopark_api/otopark_api_service.dart';

class ParkingController extends GetxController {
  var parkingList = <ParkingModel>[].obs; // Observable list
  var isLoading = false.obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    fetchParkingData(); // Uygulama başlarken veri çekiliyor
    super.onInit();
  }

  void fetchParkingData() async {
    try {
      isLoading(true);
      var data = await _apiService.fetchParkingData();
      parkingList.assignAll(data); // Liste güncelleniyor
    } catch (e) {
      Get.snackbar('Error', e.toString()); // Hata mesajı gösteriliyor
    } finally {
      isLoading(false);
    }
  }
}
