import 'package:get/get.dart';
import '../core/api/kutuphane_model.dart';
import '../core/api/kutuphane_service.dart';

class KutuphaneController extends GetxController {
  final kutuphaneList = <KutuphaneBilgi>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final KutuphaneApiService apiService = KutuphaneApiService();

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
    } catch (e) {
      errorMessage.value = 'Veriler alınırken bir hata oluştu: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
