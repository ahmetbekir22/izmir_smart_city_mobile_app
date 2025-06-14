import 'package:get/get.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import '../../core/api/afet_api/afet_model.dart';
import '../../core/api/afet_api/afet_service.dart';
import '../../core/mixins/performance_monitoring_mixin.dart';

class AfetController extends GetxController {
  final afetList = <Onemliyer>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final AfetApiService apiService = AfetApiService();
  final mapController = Get.put(MapController());


  @override
  void onInit() {
    super.onInit();
    fetchAfetData();
  }

  void fetchAfetData() async {
    isLoading.value = true;
    errorMessage.value = '';
    PerformanceMonitoringMixin.startApiCall('fetch_afet_data');
    
    try {
      final fetchedData = await apiService.fetchAfet();
      afetList.assignAll(fetchedData);
      // Haritaya marker'ları ekle
      mapController.addMarkers(
        locations: afetList,
        getLatitude: (location) => location.eNLEM ?? 0,
        getLongitude: (location) => location.bOYLAM ?? 0,
        getTitle: (location) => location.aDI ?? 'Bilinmeyen Konum',
        getSnippet: (location) => '${location.mAHALLE ?? ''}, ${location.iLCE ?? ''}',
      );
      
      PerformanceMonitoringMixin.stopApiCall(
        'fetch_afet_data',
        responseSize: fetchedData.toString().length,
        statusCode: '200'
      );
    } catch (e) {
      errorMessage.value = 'Veriler alınırken bir hata oluştu: $e';
      PerformanceMonitoringMixin.stopApiCall(
        'fetch_afet_data',
        statusCode: 'error'
      );
    } finally {
      isLoading.value = false;
    }
  }
}
