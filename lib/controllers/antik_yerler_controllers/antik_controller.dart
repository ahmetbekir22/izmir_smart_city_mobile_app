import 'package:get/get.dart';
import '../../core/api/antik_api/antik_model.dart';
import '../../core/api/antik_api/antik_service.dart';

class AntikController extends GetxController {
  final antikList = <Antik>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final AntikApiService apiService = AntikApiService();

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
    } catch (e) {
      errorMessage.value = 'Veriler alınırken bir hata oluştu: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
