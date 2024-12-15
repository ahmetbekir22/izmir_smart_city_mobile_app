import 'package:get/get.dart';
import '../../core/api/afet_api/afet_model.dart';
import '../../core/api/afet_api/afet_service.dart';

class AfetController extends GetxController {
  final afetList = <Onemliyer>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final AfetApiService apiService = AfetApiService();

  @override
  void onInit() {
    super.onInit();
    fetchAfetData();
  }

  void fetchAfetData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final fetchedData = await apiService.fetchAfet();
      afetList.assignAll(fetchedData);
    } catch (e) {
      errorMessage.value = 'Veriler alınırken bir hata oluştu: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
