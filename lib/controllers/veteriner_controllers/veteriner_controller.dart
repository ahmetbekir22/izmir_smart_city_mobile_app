import 'package:get/get.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import '../../core/api/veteriner_api/veteriner_model.dart';
import '../../core/api/veteriner_api/veteriner_service.dart';

class VeterinerController extends GetxController {
  final veterinerList = <Onemliyer>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final VeterinerApiService apiService = VeterinerApiService();
  final mapController = Get.put(MapController());

  @override
  void onInit() {
    super.onInit();
    fetchVeterinerData();
  }

  void fetchVeterinerData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final fetchedData = await apiService.fetchVeteriner();
      veterinerList.assignAll(fetchedData);
      // Haritaya marker'ları ekle
      mapController.addMarkers(
        locations: veterinerList,
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
