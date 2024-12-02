import 'package:get/get.dart';
import '../core/api/veteriner_model.dart';
import '../core/api/veteriner_service.dart';

class VeterinerController extends GetxController {
  final veterinerList = <Onemliyer>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final VeterinerApiService apiService = VeterinerApiService();

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
    } catch (e) {
      errorMessage.value = 'Veriler alınırken bir hata oluştu: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
