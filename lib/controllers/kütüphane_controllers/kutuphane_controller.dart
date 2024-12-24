import 'package:get/get.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import '../../core/api/kütüphane_api/kutuphane_model.dart';
import '../../core/api/kütüphane_api/kutuphane_service.dart';

class KutuphaneController extends GetxController {
  final kutuphaneList = <Onemliyer>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final KutuphaneApiService apiService = KutuphaneApiService();
  final mapController = Get.put(MapController());

  @override
  void onInit() {
    super.onInit();
    fetchKutuphaneData();
  }

  void fetchKutuphaneData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final fetchedData = await apiService.fetchKutuphaneler();
      kutuphaneList.assignAll(fetchedData);
      // Haritaya marker'ları ekle
      mapController.addMarkers(
        locations: kutuphaneList,
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
