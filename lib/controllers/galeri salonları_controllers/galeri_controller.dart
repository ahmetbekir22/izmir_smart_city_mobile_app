import 'package:get/get.dart';
import '../../core/api/galeri_api/galeri_model.dart';
import '../../core/api/galeri_api/galeri_service.dart';

class GaleriController extends GetxController {
  final galeriList = <GaleriSalon>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final GaleriApiService apiService = GaleriApiService();

  @override
  void onInit() {
    super.onInit();
    fetchGaleriData();
  }

  void fetchGaleriData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final fetchedData = await apiService.fetchGaleriSalonlar();
      galeriList.assignAll(fetchedData);
    } catch (e) {
      errorMessage.value = 'Veriler alınırken bir hata oluştu: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
