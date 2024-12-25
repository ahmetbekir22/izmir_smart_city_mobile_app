import 'package:get/get.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import '../../core/api/antik_api/antik_model.dart';
import '../../core/api/antik_api/antik_service.dart';

class AntikController extends GetxController {
  final antikList = <Onemliyer>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final AntikApiService apiService = AntikApiService();
  final mapController = Get.put(MapController());


  @override
  void onInit() {
    super.onInit();
    fetchAntikData();
  }

  void fetchAntikData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final fetchedData = await apiService.fetchAntikKentler();
      antikList.assignAll(fetchedData);
      // Haritaya marker'ları ekle
      mapController.addMarkers(
        locations: antikList,
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
